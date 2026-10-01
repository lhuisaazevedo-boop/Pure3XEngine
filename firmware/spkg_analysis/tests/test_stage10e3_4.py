#!/usr/bin/env python3
"""Lightweight unit tests for Stage 10E-3-4 (structural location of the Segment
Certification Header entries).

Run with:
    python3 -m unittest firmware/spkg_analysis/tests/test_stage10e3_4.py -v

No third-party dependencies; uses only the standard library, consistent with
the stage script itself.
"""

from __future__ import annotations

import importlib.util
import json
import sys
import tempfile
import unittest
from pathlib import Path

SCRIPT_PATH = (
    Path(__file__).resolve().parent.parent
    / "stage10e3_4_coreos_segment_cert_headers_locate.py"
)

spec = importlib.util.spec_from_file_location("stage10e3_4_module", SCRIPT_PATH)
assert spec is not None and spec.loader is not None
stage = importlib.util.module_from_spec(spec)
sys.modules[spec.name] = stage
spec.loader.exec_module(stage)


def make_synthetic_blob(sign_offset: int = 0x250, trailer: int = 0x20) -> bytes:
    """Build a synthetic decrypted CORE OS certification blob large enough to
    contain a valid 0x90-byte Segment Certification Header region followed by
    padding up to `sign_offset`, plus `trailer` extra bytes standing in for the
    signature region.
    """
    data = bytearray(range(stage.CERT_HEADER_SIZE))
    for index in range(3):
        data += bytes([index + 1]) * stage.ENTRY_SIZE
    data += bytes([0xAA]) * (sign_offset - len(data))
    data += bytes([0xFF]) * trailer
    return bytes(data)


class LookupIntTests(unittest.TestCase):
    def test_returns_value_and_found_true_when_present(self) -> None:
        value, found = stage._lookup_int({"a": "0x10"}, {}, ("a",), default=0)
        self.assertEqual(value, 0x10)
        self.assertTrue(found)

    def test_falls_back_to_manifest_root_when_absent_in_parsed(self) -> None:
        value, found = stage._lookup_int({}, {"a": 5}, ("a",), default=0)
        self.assertEqual(value, 5)
        self.assertTrue(found)

    def test_returns_default_and_found_false_when_absent(self) -> None:
        value, found = stage._lookup_int({}, {}, ("a",), default=42)
        self.assertEqual(value, 42)
        self.assertFalse(found)

    def test_ignores_unparseable_value_and_tries_next_key(self) -> None:
        value, found = stage._lookup_int({"a": "not-an-int", "b": "7"}, {}, ("a", "b"), default=0)
        self.assertEqual(value, 7)
        self.assertTrue(found)


class ResolveConstantsTests(unittest.TestCase):
    def test_defaults_when_manifest_missing(self) -> None:
        header_size, entry_num, sign_offset, warnings = stage.resolve_constants(None)
        self.assertEqual(header_size, stage.CERT_HEADER_SIZE)
        self.assertEqual(entry_num, stage.DEFAULT_CERT_ENTRY_NUM)
        self.assertEqual(sign_offset, stage.DEFAULT_SIGN_OFFSET)
        self.assertTrue(any("not found" in w for w in warnings))

    def test_defaults_and_warns_when_status_not_ok(self) -> None:
        manifest = {"status": "ERROR", "parsed_fields": {"cert_entry_num": 99}}
        _, entry_num, _, warnings = stage.resolve_constants(manifest)
        self.assertEqual(entry_num, stage.DEFAULT_CERT_ENTRY_NUM)
        self.assertTrue(any("not OK" in w for w in warnings))

    def test_reads_values_from_parsed_fields_when_status_ok(self) -> None:
        manifest = {
            "status": "OK",
            "parsed_fields": {
                "cert_header_size": "0x20",
                "cert_entry_num": 3,
                "sign_offset": "0x250",
            },
        }
        header_size, entry_num, sign_offset, warnings = stage.resolve_constants(manifest)
        self.assertEqual(header_size, 0x20)
        self.assertEqual(entry_num, 3)
        self.assertEqual(sign_offset, 0x250)
        self.assertEqual(warnings, [])

    def test_warns_when_no_expected_keys_present(self) -> None:
        manifest = {"status": "OK", "something_else": 1}
        _, _, _, warnings = stage.resolve_constants(manifest)
        self.assertTrue(any("none of the expected keys" in w for w in warnings))

    def test_warns_on_deviation_only_when_value_found(self) -> None:
        manifest = {"status": "OK", "parsed_fields": {"sign_offset": "0x300"}}
        _, _, sign_offset, warnings = stage.resolve_constants(manifest)
        self.assertEqual(sign_offset, 0x300)
        self.assertTrue(any("sign_offset=0x300" in w for w in warnings))
        # cert_entry_num was not present, so no deviation warning should be
        # emitted for it even though it still equals the default.
        self.assertFalse(any("cert_entry_num" in w and "differing" in w for w in warnings))


class MainEndToEndTests(unittest.TestCase):
    def setUp(self) -> None:
        self._tmpdir = tempfile.TemporaryDirectory()
        self.tmp = Path(self._tmpdir.name)

    def tearDown(self) -> None:
        self._tmpdir.cleanup()

    def _run(self, input_path: Path, **extra_args: str) -> tuple[int, Path]:
        output_dir = self.tmp / "out"
        manifest_path = self.tmp / "manifest.json"
        argv = [
            "--input",
            str(input_path),
            "--prior-manifest",
            str(self.tmp / "does_not_exist.json"),
            "--output-dir",
            str(output_dir),
            "--manifest-output",
            str(manifest_path),
        ]
        for key, value in extra_args.items():
            argv.extend([f"--{key.replace('_', '-')}", value])
        try:
            exit_code = stage.main(argv)
        except SystemExit as exc:
            exit_code = exc.code if isinstance(exc.code, int) else 1
        return exit_code, manifest_path

    def test_success_locates_and_extracts_three_entries(self) -> None:
        input_path = self.tmp / "decrypted.bin"
        input_path.write_bytes(make_synthetic_blob())

        exit_code, manifest_path = self._run(input_path)

        self.assertEqual(exit_code, 0)
        manifest = json.loads(manifest_path.read_text())
        self.assertEqual(manifest["status"], "OK")
        self.assertEqual(manifest["layout"]["start_offset"], "0x20")
        self.assertEqual(manifest["layout"]["total_size"], "0x90")
        self.assertEqual(len(manifest["entries"]), 3)
        for index, entry in enumerate(manifest["entries"]):
            self.assertEqual(entry["index"], index)
            self.assertEqual(entry["size"], "0x30")
            self.assertFalse(entry["parsed"])
            self.assertEqual(len(bytes.fromhex(entry["hex"])), 0x30)

        # Entry bytes/hashes must match the synthetic pattern used to build the blob.
        entry0_bytes = bytes.fromhex(manifest["entries"][0]["hex"])
        self.assertEqual(entry0_bytes, bytes([1]) * 0x30)
        self.assertNotIn("_manifest_output_path", manifest)

    def test_fails_closed_when_input_missing(self) -> None:
        exit_code, manifest_path = self._run(self.tmp / "nope.bin")
        self.assertNotEqual(exit_code, 0)
        manifest = json.loads(manifest_path.read_text())
        self.assertEqual(manifest["status"], "ERROR")
        self.assertIn("not found", manifest["error"])

    def test_fails_closed_when_input_truncated(self) -> None:
        input_path = self.tmp / "truncated.bin"
        input_path.write_bytes(bytes(0x30))  # header + trailing data only, no entries

        exit_code, manifest_path = self._run(input_path)

        self.assertNotEqual(exit_code, 0)
        manifest = json.loads(manifest_path.read_text())
        self.assertEqual(manifest["status"], "ERROR")
        self.assertIn("too short", manifest["error"])

    def test_fails_closed_when_sign_offset_exceeds_buffer(self) -> None:
        # A blob that is otherwise large enough for the 0x90-byte region, but a
        # (simulated, malformed) prior manifest reporting a sign_offset beyond
        # the buffer must still be rejected rather than trusted blindly.
        input_path = self.tmp / "decrypted.bin"
        input_path.write_bytes(make_synthetic_blob(sign_offset=0x250, trailer=0x0))

        prior_manifest_path = self.tmp / "prior_manifest.json"
        prior_manifest_path.write_text(
            json.dumps({"status": "OK", "parsed_fields": {"sign_offset": "0x9999"}})
        )

        argv = [
            "--input",
            str(input_path),
            "--prior-manifest",
            str(prior_manifest_path),
            "--output-dir",
            str(self.tmp / "out2"),
            "--manifest-output",
            str(self.tmp / "manifest2.json"),
        ]
        try:
            exit_code = stage.main(argv)
        except SystemExit as exc:
            exit_code = exc.code if isinstance(exc.code, int) else 1

        self.assertNotEqual(exit_code, 0)
        manifest = json.loads((self.tmp / "manifest2.json").read_text())
        self.assertEqual(manifest["status"], "ERROR")
        self.assertIn("sign_offset", manifest["error"])


if __name__ == "__main__":
    unittest.main()
