#!/usr/bin/env bash

set -euo pipefail

usage() {
    cat <<EOF
Usage: $0 [options]

Build qalculate-qt on macOS.

Output artifact: ./qalculate-qt.app

Options:
  -h, --help
    Print this message and exit.
EOF
}

parse_args() {
    while (( $# > 0)); do
        case $1 in
            -h|--help)
                usage
                exit 0
                ;;
            -*)
                echo "Error: unrecognized option '$1'" >&2
                return 1
                ;;
            *)
                echo "Error: unexpected positional argument '$1'" >&2
                return 1
                ;;
        esac
        shift
    done
}

prepare_env() {
    PATH=$(brew --prefix qtbase)/bin:$(brew --prefix qttools)/bin:$PATH
    PKG_CONFIG_PATH=$(brew --prefix libqalculate)/lib/pkgconfig:$(brew --prefix gmp)/lib/pkgconfig:$(brew --prefix mpfr)/lib/pkgconfig${PKG_CONFIG_PATH:+:$PKG_CONFIG_PATH}
    export PATH PKG_CONFIG_PATH
}

build() {
    qmake qalculate-qt.pro
    make -j"$(sysctl -n hw.ncpu)"
}

parse_args "$@"
prepare_env
build
