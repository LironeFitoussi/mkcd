# mkcd — create a directory (parents included) and cd into it.
#
# This file must be sourced, not executed: a child process cannot change
# the parent shell's working directory.
#
#   source /path/to/mkcd.sh
#
# POSIX sh compatible; works in bash, zsh, dash, ksh.

mkcd() {
    case "${1-}" in
        -h|--help)
            printf 'usage: mkcd <directory>\n'
            printf 'Create <directory> (with parents) and cd into it.\n'
            return 0
            ;;
        -V|--version)
            printf 'mkcd %s\n' "0.1.0"
            return 0
            ;;
    esac

    if [ "$#" -ne 1 ] || [ -z "$1" ]; then
        printf 'usage: mkcd <directory>\n' >&2
        return 2
    fi

    # shellcheck disable=SC2164  # cd's status is the function's return value
    mkdir -p -- "$1" && cd -P -- "$1"
}

# Directory completion, per shell.
if [ -n "${ZSH_VERSION-}" ]; then
    # No-op if compinit hasn't run yet.
    compdef _directories mkcd 2>/dev/null || true
elif [ -n "${BASH_VERSION-}" ]; then
    # shellcheck disable=SC3044  # only reached in bash
    complete -o dirnames -o nospace mkcd 2>/dev/null || true
fi
