#!/usr/bin/env python3
"""Extract and compare the CORE_OS_PACKAGE SPKG header."""

import argparse
import struct
import tarfile
from pathlib import Path


HEADER_SIZE = 0x280
MEMBER_NAME = "CORE_OS_PACKAGE.pkg.spkg_hdr.1"
REGIONS = (
    ("Certified File", 0x00, 0x20),
    ("Encryption Root Header", 0x20, 0x60),
    ("Certification area", 0x60, 0x280),
)


def extract_header(archive_path: Path, header_path: Path) -> bytes:
    try:
        with tarfile.open(archive_path, "r:*") as archive:
            member = archive.getmember(MEMBER_NAME)
            if not member.isfile():
                raise ValueError(f"{MEMBER_NAME} is not a regular file")
            if member.size != HEADER_SIZE:
                raise ValueError(
                    f"{MEMBER_NAME} has size 0x{member.size:X}; "
                    f"expected 0x{HEADER_SIZE:X} (640 bytes)"
                )
            stream = archive.extractfile(member)
            if stream is None:
                raise ValueError(f"{MEMBER_NAME} is not a regular file")
            header = stream.read(HEADER_SIZE + 1)
    except (OSError, KeyError, tarfile.TarError) as exc:
        raise ValueError(f"could not read {MEMBER_NAME} from {archive_path}: {exc}") from exc

    if len(header) != HEADER_SIZE:
        raise ValueError(
            f"{MEMBER_NAME} has size 0x{len(header):X}; expected 0x{HEADER_SIZE:X} (640 bytes)"
        )

    header_path.parent.mkdir(parents=True, exist_ok=True)
    header_path.write_bytes(header)
    return header


def describe_file(label: str, data: bytes, file_size: int) -> None:
    print(label)
    print(f"  size       = 0x{file_size:X}")
    print(f"  magic      = {data[0:4].hex()}")
    print(f"  version    = {struct.unpack_from('>I', data, 0x04)[0]}")
    print(f"  attribute  = 0x{struct.unpack_from('>H', data, 0x08)[0]:04X}")
    print(f"  category   = {struct.unpack_from('>H', data, 0x0A)[0]}")
    print(f"  ext_size   = 0x{struct.unpack_from('>I', data, 0x0C)[0]:X}")
    print(f"  file_off   = 0x{struct.unpack_from('>Q', data, 0x10)[0]:X}")
    print(f"  file_size  = 0x{struct.unpack_from('>Q', data, 0x18)[0]:X}")


def compare_region(name: str, start: int, end: int, core: bytes, header: bytes) -> None:
    core_region = core[start:end]
    header_region = header[start:end]
    differing = [
        start + offset
        for offset, (left, right) in enumerate(zip(core_region, header_region))
        if left != right
    ]
    print(f"{name} 0x{start:02X}-0x{end - 1:02X}:")
    print(f"  MATCH            = {core_region == header_region}")
    print(f"  differing bytes  = {len(differing)}")
    if differing:
        print("  first differences= " + ", ".join(f"0x{offset:X}" for offset in differing[:8]))
    if name == "Encryption Root Header":
        print(f"  COREOS           = {core_region.hex()}")
        print(f"  SPKGHDR          = {header_region.hex()}")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--archive",
        type=Path,
        default=Path("firmware/pup_extracted/spkg_hdr.tar"),
        help="SPKG header tar archive",
    )
    parser.add_argument(
        "--package",
        type=Path,
        default=Path("firmware/spkg_analysis/raw/stage10_CORE_OS_PACKAGE.pkg"),
        help="CORE_OS_PACKAGE.pkg file",
    )
    parser.add_argument(
        "--header",
        type=Path,
        default=Path("firmware/spkg_analysis/headers/coreos") / MEMBER_NAME,
        help="destination for the extracted header",
    )
    args = parser.parse_args()

    try:
        header = extract_header(args.archive, args.header)
        with args.package.open("rb") as package_file:
            core = package_file.read(HEADER_SIZE)
        package_size = args.package.stat().st_size
        if len(core) != HEADER_SIZE:
            raise ValueError(
                f"{args.package} has fewer than 0x{HEADER_SIZE:X} bytes; "
                "cannot compare the requested structural regions"
            )
    except (OSError, ValueError) as exc:
        parser.exit(2, f"error: {exc}\n")

    print(f"Extracted {MEMBER_NAME} to {args.header} ({len(header)} bytes, 0x{len(header):X})")
    describe_file("CORE_OS_PACKAGE.pkg", core, package_size)
    print()
    describe_file(MEMBER_NAME, header, len(header))
    print()
    for region in REGIONS:
        compare_region(*region, core, header)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
