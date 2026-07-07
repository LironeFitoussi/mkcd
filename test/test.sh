#!/bin/sh
# Tests for mkcd.sh. Run: sh test/test.sh
set -u

here=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
. "$here/mkcd.sh"

fails=0
assert() {
    if eval "$1"; then
        printf 'ok   %s\n' "$2"
    else
        printf 'FAIL %s\n' "$2"
        fails=$((fails + 1))
    fi
}

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

# creates nested dirs and cds into them
cd "$tmp" || exit 1
mkcd a/b/c
assert '[ "$(pwd -P)" = "$(CDPATH= cd -P -- "$tmp/a/b/c" && pwd -P)" ]' "cd into created nested dir"
assert '[ -d "$tmp/a/b/c" ]' "nested dirs exist"

# idempotent on existing dir
cd "$tmp" || exit 1
mkcd a/b/c
assert '[ $? -eq 0 ]' "existing dir succeeds"

# handles names with spaces and leading dash
cd "$tmp" || exit 1
mkcd "with space"
assert '[ "$(basename -- "$(pwd)")" = "with space" ]' "dir name with space"
cd "$tmp" || exit 1
mkcd -dashdir
assert '[ -d "$tmp/-dashdir" ]' "dir name starting with dash"

# no args -> usage, exit 2
cd "$tmp" || exit 1
out=$(mkcd 2>&1)
rc=$?
assert '[ "$rc" -eq 2 ]' "no args returns 2"
assert '[ -n "$out" ]' "no args prints usage"

# too many args -> exit 2
rc=0; mkcd one two 2>/dev/null || rc=$?
assert '[ "$rc" -eq 2 ]' "two args returns 2"

# --help -> exit 0, prints usage
out=$(mkcd --help)
rc=$?
assert '[ "$rc" -eq 0 ]' "--help returns 0"
assert 'printf %s "$out" | grep -q usage' "--help prints usage"

# --version -> exit 0
out=$(mkcd --version)
assert 'printf %s "$out" | grep -q mkcd' "--version prints name"

if [ "$fails" -gt 0 ]; then
    printf '%d test(s) failed\n' "$fails" >&2
    exit 1
fi
printf 'all tests passed\n'
