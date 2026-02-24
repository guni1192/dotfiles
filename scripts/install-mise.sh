#!/usr/bin/env bash
set -euo pipefail

MISE_VERSION="v2026.2.19" # renovate: datasource=github-releases depName=jdx/mise

INSTALL_DIR="${HOME}/.local/bin"
INSTALL_PATH="${INSTALL_DIR}/mise"

detect_os() {
    local os
    os="$(uname -s)"
    case "${os}" in
        Linux)  echo "linux" ;;
        Darwin) echo "macos" ;;
        *)
            echo "Error: Unsupported OS: ${os}" >&2
            exit 1
            ;;
    esac
}

detect_arch() {
    local arch
    arch="$(uname -m)"
    case "${arch}" in
        x86_64)  echo "x64" ;;
        aarch64 | arm64) echo "arm64" ;;
        *)
            echo "Error: Unsupported architecture: ${arch}" >&2
            exit 1
            ;;
    esac
}

main() {
    local os arch base_url tarball checksum_file tmpdir

    os="$(detect_os)"
    arch="$(detect_arch)"

    echo "Installing mise ${MISE_VERSION} (${os}-${arch})..."

    base_url="https://github.com/jdx/mise/releases/download/${MISE_VERSION}"
    tarball="mise-${MISE_VERSION}-${os}-${arch}.tar.gz"
    checksum_file="SHASUMS256.txt"

    tmpdir="$(mktemp -d)"
    trap 'rm -rf "${tmpdir}"' EXIT

    echo "Downloading ${tarball}..."
    curl -fsSL "${base_url}/${tarball}" -o "${tmpdir}/${tarball}"
    curl -fsSL "${base_url}/${checksum_file}" -o "${tmpdir}/${checksum_file}"

    echo "Verifying checksum..."
    (
        cd "${tmpdir}"
        if command -v sha256sum &>/dev/null; then
            grep "${tarball}" "${checksum_file}" | sha256sum -c --quiet
        elif command -v shasum &>/dev/null; then
            grep "${tarball}" "${checksum_file}" | shasum -a 256 -c --quiet
        else
            echo "Error: No SHA256 tool found (need sha256sum or shasum)" >&2
            exit 1
        fi
    )
    echo "Checksum verified."

    echo "Extracting..."
    tar -xzf "${tmpdir}/${tarball}" -C "${tmpdir}"

    mkdir -p "${INSTALL_DIR}"
    install -m 755 "${tmpdir}/mise/bin/mise" "${INSTALL_PATH}"

    echo "mise ${MISE_VERSION} installed to ${INSTALL_PATH}"
    "${INSTALL_PATH}" --version
}

main
