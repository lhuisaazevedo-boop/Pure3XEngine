# Firmware Stage 10E-3: Certification Header

## Status: blocked; not implemented

The repository currently has no firmware parsing or decryption pipeline to
extend. `CoreEmulator/firmware/FirmwareManager.cpp` only stores and clears a
firmware path; it does not load firmware bytes or implement Stage 10E-1 ERH
decryption or Stage 10E-2 ERH validation. There are also no ERH key/IV types,
firmware manifest/report structures, or firmware-stage logging abstraction.

Stage 10E-3 must remain unimplemented until the earlier stages and the
cryptographic specification are available. The repository does not define the
AES mode, padding/length handling, or any other AES operation for this header.
The recovered ERH key and IV are not represented in the codebase. Guessing
these details or substituting system ERK/RIV would risk incorrect or unsafe
firmware processing.

## Intended 10E-3 scope

Once those prerequisites are present, this stage is limited to reading the
Certification Header immediately after the validated ERH, decrypting it only
with the key and IV accepted by Stage 10E-2 and according to the repository's
documented AES specification, validating it, and recording a structured
result. It must not modify firmware bytes or log key, IV, or raw firmware
contents. Region arithmetic and all reads must be checked against the firmware
buffer, and invalid input must produce a structured failure rather than
terminating the process.

The specified header size and little-endian field layout are:

| Offset | Size | Field |
| --- | ---: | --- |
| `0x00` | 8 | `sign_offset` (`uint64`) |
| `0x08` | 4 | `sign_algorithm` (`uint32`) |
| `0x0C` | 4 | `cert_entry_num` (`uint32`) |
| `0x10` | 4 | `attr_entry_num` (`uint32`) |
| `0x14` | 4 | `optional_header_size` (`uint32`) |
| `0x18` | 8 | `pad` (`uint64`) |

The total header size is `0x30` bytes. No field semantics or accepted algorithm
values beyond this supplied layout are defined here.

The future result should report the region offset, encrypted and decrypted
sizes, status, parsed fields when valid, the key/IV provenance label without
secret material, and a precise failure reason when invalid. The repository
does not currently have a compatible manifest/report API to extend.

## Follow-up stages

Stage 10E-4 (Segment Certification Headers) remains pending. Stages 10E-5 and
11 are outside the scope of 10E-3 and remain unimplemented.
