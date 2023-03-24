#!/usr/bin/env sh

# Copyright (c) 2022 SurrealDB Ltd.

# This is a simple script that can be downloaded and run from
# https://install.surrealdb.com in order to install the SurrealDB
# command-line tools and database server. It automatically detects
# the host operating platform, and cpu architecture type, and
# downloads the latest binary for the relevant platform.

# This install script attempts to install the SurrealDB binary
# automatically, or otherwise it will prompt the user to specify 
# the desired install location.

set -u

NIGHTLY=false

INSTALL_DIR="/usr/local/bin"

SURREALDB_ROOT="https://download.surrealdb.com"

SURREALDB_VERS="https://version.surrealdb.com"

expand() {
    case "$1" in
    (\~)        echo "$HOME";;
    (\~/*)      echo "$HOME/${1#\~/}";;
    (\~[^/]*/*) local user=$(eval echo ${1%%/*}) && echo "$user/${1#*/}";;
    (\~[^/]*)   eval echo ${1};;
    (*)         echo "$1";;
    esac
}

install() {

    echo ""
    echo " .d8888b.                                             888 8888888b.  888888b."
    echo "d88P  Y88b                                            888 888  'Y88b 888  '88b"
    echo "Y88b.                                                 888 888    888 888  .88P"
    echo " 'Y888b.   888  888 888d888 888d888  .d88b.   8888b.  888 888    888 8888888K."
    echo "    'Y88b. 888  888 888P'   888P'   d8P  Y8b     '88b 888 888    888 888  'Y88b"
    echo "      '888 888  888 888     888     88888888 .d888888 888 888    888 888    888"
    echo "Y88b  d88P Y88b 888 888     888     Y8b.     888  888 888 888  .d88P 888   d88P"
    echo " 'Y8888P'   'Y88888 888     888      'Y8888  'Y888888 888 8888888P'  8888888P'"
    echo ""
    
    # Check for nightly option
    
    for flag in "$@"; do
        case $flag in
            --nightly) NIGHTLY=true;;
        esac
    done

    # Check for install directory

    if [ -v 1 ] && [ "$1" !=  "--nightly" ]; then
        INSTALL_DIR="$1";
    fi
    
    # Check for necessary commands

    command -v uname >/dev/null 2>&1 || {
        err "Error: you need to have 'uname' installed and in your path"
    }

    command -v mkdir >/dev/null 2>&1 || {
        err "Error: you need to have 'mkdir' installed and in your path"
    }

    command -v read >/dev/null 2>&1 || {
        err "Error: you need to have 'read' installed and in your path"
    }

    command -v tar >/dev/null 2>&1 || {
        err "Error: you need to have 'tar' installed and in your path"
    }

    # Check for curl or wget commands

    local _cmd

    if command -v curl >/dev/null 2>&1; then
        _cmd=curl
    elif command -v wget >/dev/null 2>&1; then
        _cmd=wget
    else
        err "Error: you need to have 'curl' or 'wget' installed and in your path"
    fi

    # Fetch the latest SurrealDB version

    echo "Fetching the latest database version..."

    local _ver
    
    if [ "$NIGHTLY" = true ]; then
        
        _ver="nightly"
    
    else

        if [ "$_cmd" = curl ]; then
            _ver=$(curl --silent --fail --location "$SURREALDB_VERS") || {
                err "Error: could not fetch the latest SurrealDB version number"
            }
        elif [ "$_cmd" = wget ]; then
            _ver=$(wget --quiet "$SURREALDB_VERS") || {
                err "Error: could not fetch the latest SurrealDB version number"
            }
        fi
        
    fi

    # Compute the current system architecture

    echo "Fetching the host system architecture..."

    local _oss
    local _cpu
    local _arc

    _oss="$(uname -s)"
    _cpu="$(uname -m)"

    case "$_oss" in
        Linux) _oss=linux;;
        Darwin) _oss=darwin;;
        MINGW* | MSYS* | CYGWIN*) _oss=windows;;
        *) err "Error: unsupported operating system: $_oss";;
    esac

    case "$_cpu" in
        arm64 | aarch64) _cpu=arm64;;
        x86_64 | x86-64 | x64 | amd64) _cpu=amd64;;
        *) err "Error: unsupported CPU architecture: $_cpu";;
    esac

    _arc="${_oss}-${_cpu}"

    # Compute the download file extension type

    local _ext

    case "$_oss" in
        linux) _ext="tgz";;
        darwin) _ext="tgz";;
        windows) _ext="exe";;
    esac

    # Define the latest SurrealDB download url

    local _url

    _url="${SURREALDB_ROOT}/${_ver}/surreal-${_ver}.${_arc}.${_ext}"
    
    # Download and unarchive the latest SurrealDB binary

    cd /tmp

    echo "Installing surreal-${_ver} for ${_arc}..."

    if [ "$_cmd" = curl ]; then
        curl --silent --fail --location "$_url" --output "surreal-${_ver}.${_arc}.${_ext}" || {
            err "Error: could not fetch the latest SurrealDB file"
        }
    elif [ "$_cmd" = wget ]; then
        wget --quiet "$_url" -O "surreal-${_ver}.${_arc}.${_ext}" || {
            err "Error: could not fetch the latest SurrealDB file"
        }
    fi

    tar -zxf "surreal-${_ver}.${_arc}.${_ext}" || {
        err "Error: unable to extract the downloaded archive file"
    }

    # Install the SurrealDB binary into the specified directory

    local _loc="$INSTALL_DIR"
        
    mkdir -p "$_loc" 2>/dev/null
    
    if [ ! -d "$_loc" ] || ! touch "$_loc/surreal" 2>/dev/null; then
        echo ""
        read -p "Where would you like to install the 'surreal' binary [~/.surrealdb]? " _loc
        _loc=${_loc:-~/.surrealdb} && _loc=$(expand "$_loc")
        mkdir -p "$_loc"
    fi
        
    mv "surreal" "$_loc" 2>/dev/null || {
        err "Error: we couldn't install the 'surreal' binary into $_loc"
    }
    
    # Show some simple instructions

    echo ""    
    echo "SurrealDB successfully installed in:"
    echo "  ${_loc}/surreal"
    echo ""

    if [ "${_loc}" != "${INSTALL_DIR}" ]; then
        echo "To ensure that surreal is in your \$PATH run:"
        echo "  PATH=${_loc}:\$PATH"
        echo "Or to move the binary to ${INSTALL_DIR} run:"
        echo "  sudo mv ${_loc}/surreal ${INSTALL_DIR}"
        echo ""
    fi

    echo "To see the command-line options run:"
    echo "  surreal help"
    echo "To start an in-memory database server run:"
    echo "  surreal start --log debug --user root --pass root memory"
    echo "For help with getting started visit:"
    echo "  https://surrealdb.com/docs"
    echo ""

    # Exit cleanly

    exit 0

}

err() {
    echo "$1" >&2 && exit 1
}

install "$@" || exit 1
