# firmware/spkg_analysis — CORE OS Certification Pipeline (Stage 10E-3)

This directory holds the forensic/audit scripts and derived artifacts for the
Stage 10E-3 analysis of the CORE OS certification blob inside the SPKG
firmware container. Each stage script is self-contained, performs only the
narrow analysis step it is named for, and fails closed (clear error, nonzero
exit) rather than guessing when a required input or layout assumption cannot
be established.

## Layout

- `stageNNN_description.py` — one script per analysis stage.
- `derived/stage10e3/` — binary artifacts produced by Stage 10E-3 scripts
  (decrypted blobs, validated headers, raw extracted entries).
- `manifests/` — deterministic JSON manifests documenting inputs, computed
  offsets, validation checks, hashes, and status for each stage run.

## Tests

`tests/test_stage10e3_4.py` contains lightweight stdlib-only `unittest` tests
covering the constant-resolution/warning logic and the end-to-end success and
fail-closed paths (missing input, truncated input, out-of-bounds
`sign_offset`). Run with:

```sh
python3 -m unittest firmware/spkg_analysis/tests/test_stage10e3_4.py -v
```

## Stage 10E-3-4: Segment Certification Headers — Structural Location

`stage10e3_4_coreos_segment_cert_headers_locate.py` locates and raw-extracts
the 3 Segment Certification Header entries documented for the CORE OS
certification blob, **without** interpreting any of their fields.

Expected input: the complete decrypted CORE OS certification blob produced by
Stage 10E-3-2, by default at
`derived/stage10e3/coreos_certification_header_decrypted.bin` (override with
`--input`).

Documented layout:

- Fixed Certification Header: `0x20` bytes (validated by Stage 10E-3-3).
- Segment Certification Header entry size: `0x30` bytes (documented).
- `cert_entry_num = 3` (validated by Stage 10E-3-3) ⇒ total entries region
  size `3 * 0x30 = 0x90` bytes.
- **Start offset assumption**: the entries region is assumed to begin
  immediately after the fixed Certification Header, i.e. at offset `0x20`.
  This is the only anchor documented/recoverable from the Stage 10E-3-3
  manifest (the "trailing data" bytes it preserved begin at that same
  offset). The script treats this as a declared, auditable assumption — it
  is validated against the actual input buffer size and against
  `sign_offset` before any bytes are sliced, and the script fails closed
  (nonzero exit, explicit error, no output) if the input is missing, too
  short to contain the full `0x90`-byte region, or the region would overlap
  the signature boundary. It never silently invents an offset.

Entries are emitted strictly as raw, unparsed `0x30`-byte blocks (per-entry
`.bin` files plus a consolidated `.bin`), together with SHA-256 hashes and
hex dumps in the manifest for traceability. Field parsing (big-endian or
otherwise) of these entries is deferred to a later stage.
