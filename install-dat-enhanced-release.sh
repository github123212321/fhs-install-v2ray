#!/bin/bash

# This Bash script to install the latest release of geoip.dat and geosite.dat:

# https://github.com/Loyalsoldier/v2ray-rules-dat

# Depends on cURL, please solve it yourself

# You may plan to execute this Bash script regularly:

# install -m 755 install-dat-release.sh /usr/local/bin/install-dat-release

# 0 0 * * * /usr/local/bin/install-dat-release > /dev/null 2>&1

V2RAY="/usr/local/share/v2ray"
DOWNLOAD_LINK_GEOIP="https://github.com/Loyalsoldier/v2ray-rules-dat/raw/release/geoip.dat"
DOWNLOAD_LINK_GEOSITE="https://github.com/Loyalsoldier/v2ray-rules-dat/raw/release/geosite.dat"

download_geoip() {
    if ! curl -L -H 'Cache-Control: no-cache' -o "${V2RAY}geoip.dat.new" "$DOWNLOAD_LINK_GEOIP"; then
        echo 'error: Download failed! Please check your network or try again.'
        exit 1
    fi
    if ! curl -L -H 'Cache-Control: no-cache' -o "${V2RAY}geoip.dat.sha256sum.new" "$DOWNLOAD_LINK_GEOIP.sha256sum"; then
        echo 'error: Download failed! Please check your network or try again.'
        exit 1
    fi
    SUM="$(sha256sum ${V2RAY}geoip.dat.new | sed 's/ .*//')"
    CHECKSUM="$(sed 's/ .*//' ${V2RAY}geoip.dat.sha256sum.new)"
    if [[ "$SUM" != "$CHECKSUM" ]]; then
        echo 'error: Check failed! Please check your network or try again.'
        exit 1
    fi
}

download_geosite() {
    if ! curl -L -H 'Cache-Control: no-cache' -o "${V2RAY}geosite.dat.new" "$DOWNLOAD_LINK_GEOSITE"; then
        echo 'error: Download failed! Please check your network or try again.'
        exit 1
    fi
    if ! curl -L -H 'Cache-Control: no-cache' -o "${V2RAY}geosite.dat.sha256sum.new" "$DOWNLOAD_LINK_GEOSITE.sha256sum"; then
        echo 'error: Download failed! Please check your network or try again.'
        exit 1
    fi
    SUM="$(sha256sum ${V2RAY}geosite.dat.new | sed 's/ .*//')"
    CHECKSUM="$(sed 's/ .*//' ${V2RAY}geosite.dat.sha256sum.new)"
    if [[ "$SUM" != "$CHECKSUM" ]]; then
        echo 'error: Check failed! Please check your network or try again.'
        exit 1
    fi
}

rename_new() {
    for DAT in 'geoip' 'geosite'; do
        install -m 755 "${V2RAY}$DAT.dat.new" "${V2RAY}$DAT.dat"
        rm "${V2RAY}$DAT.dat.new"
        rm "${V2RAY}$DAT.dat.sha256sum.new"
    done
}

main() {
    download_geoip
    download_geosite
    rename_new
}

main
