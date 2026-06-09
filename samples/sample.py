"""Sample Python module for syntax highlighting."""
from __future__ import annotations

import re
from dataclasses import dataclass, field
from functools import lru_cache
from typing import Iterable

SEMVER = re.compile(r"^(\d+)\.(\d+)\.(\d+)(?:-(?P<pre>[0-9a-z.]+))?$")
DEFAULT_TAGS: tuple[str, ...] = ("stable", "latest")


@dataclass(frozen=True)
class Release:
    name: str
    version: str
    tags: list[str] = field(default_factory=list)

    @property
    def is_prerelease(self) -> bool:
        match = SEMVER.match(self.version)
        return bool(match and match.group("pre"))


@lru_cache(maxsize=128)
def parse_version(value: str) -> tuple[int, int, int]:
    match = SEMVER.match(value)
    if match is None:
        raise ValueError(f"invalid version: {value!r}")
    major, minor, patch = (int(part) for part in match.groups()[:3])
    return major, minor, patch


def latest(releases: Iterable[Release]) -> Release | None:
    ranked = sorted(releases, key=lambda rel: parse_version(rel.version))
    return ranked[-1] if ranked else None


if __name__ == "__main__":
    catalog = [
        Release("core", "1.2.0", list(DEFAULT_TAGS)),
        Release("core", "1.10.3"),
        Release("core", "2.0.0-rc.1"),
    ]
    newest = latest(catalog)
    print(f"newest = {newest!r}, prerelease = {newest.is_prerelease}")
