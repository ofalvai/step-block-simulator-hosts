#!/usr/bin/env bash

set -eo pipefail

STEP_ENTRYPOINT="${BITRISE_STEP_SOURCE_DIR}"/step/main.ts
STEP_DENO_CONFIG="${BITRISE_STEP_SOURCE_DIR}"/deno.json
DENO_VERSION="2.0.4"

DENO_INSTALL_DIR=${TMPDIR}/deno-${DENO_VERSION}
OS_TYPE=$(uname -s)
ARCH_TYPE=$(uname -m)

echo "Setting up Deno for executing the step..."

if [[ "$OS_TYPE" == "Darwin" ]]; then
    if [[ "$ARCH_TYPE" == "arm64" ]]; then
        TARGET_TUPLE="aarch64-apple-darwin"
    else
        echo "Unsupported architecture for macOS: $ARCH_TYPE"
        exit 1
    fi
elif [[ "$OS_TYPE" == "Linux" ]]; then
    if [[ "$ARCH_TYPE" == "x86_64" ]]; then
        TARGET_TUPLE="x86_64-unknown-linux-gnu"
    else
        echo "Unsupported architecture for Linux: $ARCH_TYPE"
        exit 1
    fi
else
    echo "Unsupported OS type: $OS_TYPE"
    exit 1
fi



if [[ ! -d "${DENO_INSTALL_DIR}" ]]; then
    DENO_URL="https://dl.deno.land/release/v${DENO_VERSION}/deno-${TARGET_TUPLE}.zip"
    echo "Downloading $DENO_URL..."

    start_time="$(date -u +%s.%2N)"
    mkdir -p "${DENO_INSTALL_DIR}"
    curl --retry 5 -fsSL "$DENO_URL" -o "${DENO_INSTALL_DIR}"/deno.zip
    unzip "${DENO_INSTALL_DIR}"/deno.zip -d "${DENO_INSTALL_DIR}"
    rm "${DENO_INSTALL_DIR}"/deno.zip
    chmod +x "${DENO_INSTALL_DIR}"/deno
    end_time="$(date -u +%s.%2N)"

    echo "☑️ Deno installed in $(bc <<<"$end_time-$start_time") seconds"
else
    echo "☑️ Using existing Deno binary at ${DENO_INSTALL_DIR}"
fi



start_time="$(date -u +%s.%2N)"
"${DENO_INSTALL_DIR}"/deno install --config "$STEP_DENO_CONFIG"
end_time="$(date -u +%s.%2N)"
echo "☑️ Dependencies installed in $(bc <<<"$end_time-$start_time") seconds"

printf "\n---------\n\n"
export DENO_NO_UPDATE_CHECK=1
# sudo is only required for this specific step because it edits /etc/hosts
sudo --preserve-env \
    "${DENO_INSTALL_DIR}"/deno run \
    --allow-read --allow-write --allow-env --allow-net --allow-run \
    "$STEP_ENTRYPOINT"
