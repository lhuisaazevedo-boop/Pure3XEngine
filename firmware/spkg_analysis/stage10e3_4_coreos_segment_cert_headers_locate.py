#!/usr/bin/env python3
"""
Stage 10E-3-4: CORE OS Segment Certification Headers - Structural Location & Raw Extraction
================================================================================================

Scope (intentionally narrow):
    This stage performs ONLY structural location and raw extraction of the
    3 Segment Certification Header entries documented for the CORE OS
    certification blob. It does NOT interpret/parse any big-endian field
    inside those entries - that is reserved for a later stage (10E-3-5+).

Context from prior stages:
    * Stage 10E-3-2 produced the decrypted CORE OS certification blob at
      ``firmware/spkg_analysis/derived/stage10e3/coreos_certification_header_decrypted.bin``.
    * Stage 10E-3-3 validated the fixed Certification Header as exactly
      0x20 bytes, parsing:
          sign_offset           = 0x250
          sign_algorithm        = 1
          cert_entry_num        = 3
          attr_entry_num        = 20
          optional_header_size  = 0
          pad                   = 0
      and explicitly preserved the following 0x10 bytes as *trailing data*,
      NOT part of the Certification Header, and NOT (by themselves) a
      complete Segment Certification Header entry.

Layout assumption for this stage (explicit, auditable):
    The documented Segment Certification Header entry size is 0x30 bytes.
    With ``cert_entry_num = 3`` the 3 entries occupy a contiguous region of
    exactly ``3 * 0x30 = 0x90`` bytes.

    The only documented/established anchor available from prior stages is
    the end of the fixed Certification Header (offset 0x20). Standard
    self-certification container layouts place the segment/entry table
    immediately after the fixed header, and the Stage 10E-3-3 manifest's
    "trailing data" begins exactly at that same offset (0x20) - consistent
    with it being the first bytes of Entry 0 of this table, NOT a
    separate/unrelated region. This script therefore treats
    ``start_offset = cert_header_size (0x20)`` as the candidate start of the
    3-entry table, derived from the stage 10E-3-3 manifest when available.

    This assumption is NEVER silently trusted: every boundary is validated
    against the actual input buffer and against ``sign_offset`` before any
    bytes are sliced. If the input blob is missing, too short, or the
    region would overlap the signature boundary, the script fails closed
    with a clear, nonzero-exit error instead of guessing.

No field parsing (big-endian or otherwise) of the 0x30-byte entries is
performed in this stage. Entries are emitted strictly as raw, unparsed
bytes, alongside SHA-256 hashes and hex dumps for traceability.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import sys
from pathlib import Path
from typing import Any, Optional

STAGE_ID = "10E-3-4"
STAGE_SLUG = "stage_10e3_4"
STAGE_TITLE = "CORE OS Segment Certification Headers - Structural Location"

SCRIPT_DIR = Path(__file__).resolve().parent
DERIVED_DIR = SCRIPT_DIR / "derived" / "stage10e3"
MANIFEST_DIR = SCRIPT_DIR / "manifests"

DEFAULT_INPUT_PATH = DERIVED_DIR / "coreos_certification_header_decrypted.bin"
PRIOR_MANIFEST_PATH = MANIFEST_DIR / "stage_10e3_3_coreos_certification_header_validation.json"

# Documented constants (see Stage 10E-3-3 parsed values in the module docstring).
CERT_HEADER_SIZE = 0x20
ENTRY_SIZE = 0x30
DEFAULT_CERT_ENTRY_NUM = 3
DEFAULT_SIGN_OFFSET = 0x250

OUTPUT_CONSOLIDATED_BIN = DERIVED_DIR / "coreos_segment_cert_headers_raw.bin"
OUTPUT_ENTRY_BIN_TEMPLATE = "coreos_segment_cert_header_entry{index}_raw.bin"
OUTPUT_MANIFEST_PATH = MANIFEST_DIR / f"{STAGE_SLUG}_coreos_segment_cert_headers_locate.json"


class ValidationError(Exception):
    """Raised when a boundary/consistency check fails. Causes a closed (nonzero-exit) failure."""


def sha256_hex(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def hex_dump(data: bytes) -> str:
    """Return a plain contiguous hex string (no spaces/newlines) for manifest/audit use."""
    return data.hex()


def load_prior_manifest(path: Path) -> Optional[dict]:
    """Best-effort load of the Stage 10E-3-3 manifest to recover documented constants.

    Returns None (with no exception) if the manifest is absent or unreadable;
    callers must fall back to documented defaults and record a warning.
    """
    if not path.is_file():
        return None
    try:
        with path.open("r", encoding="utf-8") as fh:
            return json.load(fh)
    except (OSError, json.JSONDecodeError):
        return None


def resolve_constants(prior_manifest: Optional[dict]) -> tuple[int, int, int, list[str]]:
    """Resolve (cert_header_size, cert_entry_num, sign_offset) from the prior manifest
    when possible, otherwise fall back to the documented defaults.

    Returns the resolved values plus a list of human-readable warnings.
    """
    warnings: list[str] = []

    cert_header_size = CERT_HEADER_SIZE
    cert_entry_num = DEFAULT_CERT_ENTRY_NUM
    sign_offset = DEFAULT_SIGN_OFFSET

    if prior_manifest is None:
        warnings.append(
            "Stage 10E-3-3 manifest not found; falling back to documented defaults "
            f"(cert_header_size=0x{cert_header_size:x}, cert_entry_num={cert_entry_num}, "
            f"sign_offset=0x{sign_offset:x})."
        )
        return cert_header_size, cert_entry_num, sign_offset, warnings

    parsed = prior_manifest.get("parsed_fields") or prior_manifest.get("fields") or prior_manifest

    def _get_int(*keys: str, default: int) -> int:
        for key in keys:
            value = parsed.get(key) if isinstance(parsed, dict) else None
            if value is None and isinstance(prior_manifest, dict):
                value = prior_manifest.get(key)
            if value is not None:
                try:
                    return int(value, 0) if isinstance(value, str) else int(value)
                except (TypeError, ValueError):
                    pass
        return default

    cert_header_size = _get_int("cert_header_size", "certification_header_size", default=CERT_HEADER_SIZE)
    cert_entry_num = _get_int("cert_entry_num", default=DEFAULT_CERT_ENTRY_NUM)
    sign_offset = _get_int("sign_offset", default=DEFAULT_SIGN_OFFSET)

    if cert_header_size != CERT_HEADER_SIZE:
        warnings.append(
            f"Prior manifest reports cert_header_size=0x{cert_header_size:x}, "
            f"differing from the documented 0x{CERT_HEADER_SIZE:x}."
        )
    if cert_entry_num != DEFAULT_CERT_ENTRY_NUM:
        warnings.append(
            f"Prior manifest reports cert_entry_num={cert_entry_num}, "
            f"differing from the documented default {DEFAULT_CERT_ENTRY_NUM}."
        )

    return cert_header_size, cert_entry_num, sign_offset, warnings


def write_manifest(manifest: dict, path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8") as fh:
        json.dump(manifest, fh, indent=2, sort_keys=True)
        fh.write("\n")


def fail_closed(manifest: dict, message: str) -> "NoReturn":  # type: ignore[name-defined]
    manifest["status"] = "ERROR"
    manifest["error"] = message
    write_manifest(manifest, Path(manifest["_manifest_output_path"]))
    print(f"[{STAGE_ID}] STATUS: ERROR")
    print(f"[{STAGE_ID}] ERROR: {message}")
    print(f"[{STAGE_ID}] Manifest (failure record) written to: {manifest['_manifest_output_path']}")
    sys.exit(2)


def main(argv: Optional[list[str]] = None) -> int:
    parser = argparse.ArgumentParser(
        description=(
            f"Stage {STAGE_ID}: {STAGE_TITLE}. "
            "Locates and raw-extracts the 3 Segment Certification Header entries "
            "(0x30 bytes each, 0x90 bytes total) without parsing any fields."
        )
    )
    parser.add_argument(
        "--input",
        type=Path,
        default=DEFAULT_INPUT_PATH,
        help=(
            "Path to the decrypted CORE OS certification blob produced by Stage 10E-3-2 "
            f"(default: {DEFAULT_INPUT_PATH})."
        ),
    )
    parser.add_argument(
        "--prior-manifest",
        type=Path,
        default=PRIOR_MANIFEST_PATH,
        help=(
            "Path to the Stage 10E-3-3 validation manifest used to recover documented "
            f"constants (default: {PRIOR_MANIFEST_PATH})."
        ),
    )
    parser.add_argument(
        "--output-dir",
        type=Path,
        default=DERIVED_DIR,
        help=f"Directory for raw extracted binaries (default: {DERIVED_DIR}).",
    )
    parser.add_argument(
        "--manifest-output",
        type=Path,
        default=OUTPUT_MANIFEST_PATH,
        help=f"Path for the JSON manifest (default: {OUTPUT_MANIFEST_PATH}).",
    )
    args = parser.parse_args(argv)

    print(f"=== Stage {STAGE_ID}: {STAGE_TITLE} ===")

    manifest: dict[str, Any] = {
        "stage": STAGE_ID,
        "title": STAGE_TITLE,
        "description": (
            "Structural location and raw (unparsed) extraction of the 3 Segment "
            "Certification Header entries. No big-endian field parsing is performed "
            "in this stage."
        ),
        "_manifest_output_path": str(args.manifest_output),
        "input": {"path": str(args.input)},
        "warnings": [],
        "validation": {},
        "entries": [],
        "status": "PENDING",
    }

    # ---- Resolve documented constants from the prior stage manifest (best effort) ----
    prior_manifest = load_prior_manifest(args.prior_manifest)
    cert_header_size, cert_entry_num, sign_offset, const_warnings = resolve_constants(prior_manifest)
    manifest["warnings"].extend(const_warnings)
    manifest["prior_manifest"] = {
        "path": str(args.prior_manifest),
        "found": prior_manifest is not None,
    }

    entry_size = ENTRY_SIZE
    total_size = cert_entry_num * entry_size
    start_offset = cert_header_size
    end_offset = start_offset + total_size

    manifest["layout"] = {
        "cert_header_size": f"0x{cert_header_size:x}",
        "entry_size": f"0x{entry_size:x}",
        "cert_entry_num": cert_entry_num,
        "total_size": f"0x{total_size:x}",
        "start_offset": f"0x{start_offset:x}",
        "end_offset": f"0x{end_offset:x}",
        "sign_offset": f"0x{sign_offset:x}",
        "start_offset_basis": (
            "Immediately after the fixed Certification Header (0x20), the only "
            "documented anchor recovered from the Stage 10E-3-3 manifest. This is "
            "a declared assumption, validated against buffer bounds and sign_offset "
            "below -- it is NOT silently trusted."
        ),
    }

    for warning in const_warnings:
        print(f"[{STAGE_ID}] WARNING: {warning}")

    # ---- Sanity check on the documented arithmetic itself ----
    if total_size != 0x90 or entry_size != 0x30 or cert_entry_num != 3:
        print(
            f"[{STAGE_ID}] WARNING: resolved constants deviate from the documented "
            f"cert_entry_num=3 * entry_size=0x30 = 0x90 (got cert_entry_num={cert_entry_num}, "
            f"entry_size=0x{entry_size:x}, total_size=0x{total_size:x})."
        )

    # ---- Load input blob (fail closed if missing/unreadable) ----
    if not args.input.is_file():
        fail_closed(
            manifest,
            (
                f"Input decrypted CORE OS certification blob not found at '{args.input}'. "
                "The complete decrypted blob produced by Stage 10E-3-2 is required before "
                "the Segment Certification Header region can be located; refusing to guess."
            ),
        )

    try:
        data = args.input.read_bytes()
    except OSError as exc:
        fail_closed(manifest, f"Failed to read input '{args.input}': {exc}")
        return 2  # unreachable, keeps type-checkers happy

    input_size = len(data)
    manifest["input"]["size"] = f"0x{input_size:x}"
    manifest["input"]["sha256"] = sha256_hex(data)

    checks: dict[str, Any] = {}

    # 1. start_offset must be within the buffer.
    checks["start_within_buffer"] = 0 <= start_offset <= input_size
    # 2. end_offset must be within the buffer (no truncation of the region).
    checks["end_within_buffer"] = end_offset <= input_size
    # 3. end_offset must not exceed sign_offset (no overlap with the signature region).
    checks["end_within_sign_offset"] = end_offset <= sign_offset
    # 4. extracted size must be exactly 0x90.
    checks["total_size_is_0x90"] = total_size == 0x90
    # 5. start_offset must not be negative / entries must not overlap the header itself.
    checks["start_not_before_header_end"] = start_offset >= cert_header_size

    manifest["validation"] = checks

    failed_checks = [name for name, ok in checks.items() if not ok]
    if failed_checks:
        details = []
        if not checks["start_within_buffer"]:
            details.append(
                f"start_offset 0x{start_offset:x} is outside the input buffer "
                f"(input size 0x{input_size:x})."
            )
        if not checks["end_within_buffer"]:
            details.append(
                f"end_offset 0x{end_offset:x} exceeds the input buffer size "
                f"(0x{input_size:x}); the decrypted blob is too short to contain the "
                "full 0x90-byte Segment Certification Header region. The complete "
                "decrypted blob from Stage 10E-3-2 is required, not a truncated extract."
            )
        if not checks["end_within_sign_offset"]:
            details.append(
                f"end_offset 0x{end_offset:x} exceeds sign_offset 0x{sign_offset:x}; "
                "the computed region would overlap the signature boundary."
            )
        if not checks["total_size_is_0x90"]:
            details.append(f"Computed total_size 0x{total_size:x} is not exactly 0x90.")
        if not checks["start_not_before_header_end"]:
            details.append(
                f"start_offset 0x{start_offset:x} precedes the end of the fixed "
                f"Certification Header (0x{cert_header_size:x})."
            )
        fail_closed(
            manifest,
            "Boundary validation failed; location of the Segment Certification Header "
            "region could not be established unambiguously: " + " ".join(details),
        )

    # ---- All boundary checks passed: slice the region and the 3 entries ----
    region = data[start_offset:end_offset]
    if len(region) != total_size:
        fail_closed(
            manifest,
            f"Internal consistency error: sliced region size 0x{len(region):x} does not "
            f"match expected total_size 0x{total_size:x}.",
        )

    manifest["region"] = {
        "offset": f"0x{start_offset:x}",
        "size": f"0x{total_size:x}",
        "sha256": sha256_hex(region),
        "hex": hex_dump(region),
    }

    args.output_dir.mkdir(parents=True, exist_ok=True)
    consolidated_path = args.output_dir / OUTPUT_CONSOLIDATED_BIN.name
    consolidated_path.write_bytes(region)

    entries_info = []
    for index in range(cert_entry_num):
        entry_bytes = region[index * entry_size:(index + 1) * entry_size]
        entry_path = args.output_dir / OUTPUT_ENTRY_BIN_TEMPLATE.format(index=index)
        entry_path.write_bytes(entry_bytes)
        entry_offset = start_offset + index * entry_size
        entry_info = {
            "index": index,
            "offset": f"0x{entry_offset:x}",
            "size": f"0x{entry_size:x}",
            "sha256": sha256_hex(entry_bytes),
            "hex": hex_dump(entry_bytes),
            "parsed": False,
            "note": "Raw, unparsed bytes. Field interpretation deferred to a later stage.",
            "output_path": str(entry_path),
        }
        entries_info.append(entry_info)

    manifest["entries"] = entries_info
    manifest["outputs"] = {
        "consolidated_bin": str(consolidated_path),
        "entry_bins": [e["output_path"] for e in entries_info],
    }
    manifest["status"] = "OK"
    manifest["unparsed"] = True

    write_manifest(manifest, args.manifest_output)

    # ---- Report ----
    print(f"[{STAGE_ID}] STATUS: OK")
    print(f"[{STAGE_ID}] Input: {args.input} (size=0x{input_size:x}, sha256={manifest['input']['sha256']})")
    print(
        f"[{STAGE_ID}] Region: offset=0x{start_offset:x} size=0x{total_size:x} "
        f"end=0x{end_offset:x} (sign_offset=0x{sign_offset:x})"
    )
    for entry in entries_info:
        print(
            f"[{STAGE_ID}] Entry {entry['index']}: offset={entry['offset']} "
            f"size={entry['size']} sha256={entry['sha256']}"
        )
        print(f"[{STAGE_ID}]   hex: {entry['hex']}")
    print(f"[{STAGE_ID}] Consolidated output: {consolidated_path}")
    for entry in entries_info:
        print(f"[{STAGE_ID}] Entry output: {entry['output_path']}")
    print(f"[{STAGE_ID}] Manifest: {args.manifest_output}")
    print(f"[{STAGE_ID}] NOTE: entries are raw/unparsed. No field interpretation performed.")

    return 0


if __name__ == "__main__":
    sys.exit(main())
