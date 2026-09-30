# Firmware analysis: Stage 10D

Stage 10D extracts and structurally compares the confirmed
`CORE_OS_PACKAGE.pkg.spkg_hdr.1` member with `CORE_OS_PACKAGE.pkg`. It does not
decrypt data or attempt to recover package contents.

## Run

From the repository root, with the extracted firmware artifacts in place:

```sh
python3 tools/firmware/analyze_stage10d.py
```

Defaults are:

- Archive: `firmware/pup_extracted/spkg_hdr.tar`
- Package: `firmware/spkg_analysis/raw/stage10_CORE_OS_PACKAGE.pkg`
- Extracted header: `firmware/spkg_analysis/headers/coreos/CORE_OS_PACKAGE.pkg.spkg_hdr.1`

The archive member is read by its exact name, without extracting other tar
contents. The script requires the header to be exactly `0x280` (640) bytes and
compares only the first `0x280` bytes of the package. `--archive`, `--package`,
and `--header` can override the paths.

## Structural comparison

The script reports the big-endian Certified File fields (`magic`, `version`,
`attribute`, `category`, `ext_size`, `file_off`, and `file_size`) for each file,
then compares:

| Range | Structure |
| --- | --- |
| `0x00–0x1F` | Certified File |
| `0x20–0x5F` | Encryption Root Header |
| `0x60–0x27F` | Certification area |

For each region, the output gives exact equality and the number and first
locations of differing bytes. The Encryption Root Header bytes are also printed
in hex. A matching or differing result is data to record, not a decryption
result; the header is not assumed to be a byte-for-byte copy of the package
prefix.

## Findings and Stage 10E handoff

The analysis context identifies `CORE_OS_PACKAGE.pkg.spkg_hdr.1` as the
corresponding header, and specifies `0x280` bytes as the expected size. The
firmware archive and package are not present in this checkout, so extraction,
size verification, and actual field/region results remain unverified here.
Do not infer comparison results from the earlier `dev_flash_000` and
`dev_flash_001` observations; run the script on these two CoreOS files and
preserve its output as the Stage 10D result.

For Stage 10E, use the verified extracted header and record the Stage 10D
comparison output alongside the already-validated SPKG keyset and cryptographic
modes. No keys or decryption operations are part of this Stage 10D tool.
