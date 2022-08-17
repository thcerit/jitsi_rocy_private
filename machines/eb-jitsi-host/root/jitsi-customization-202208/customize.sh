#!/bin/bash
set -e

# ------------------------------------------------------------------------------
# This script customizes the Jitsi installation. Run it on the host machine.
#
# usage:
#     bash customize.sh
# ------------------------------------------------------------------------------
BASEDIR=$(dirname $0)
JITSI_ROOTFS="/var/lib/lxc/eb-jitsi/rootfs"
JITSI_MEET="$JITSI_ROOTFS/usr/share/jitsi-meet"
JITSI_CONFIG="$JITSI_ROOTFS/etc/jitsi/meet/___JITSI_FQDN___-config.js"
JITSI_INTERFACE="$JITSI_ROOTFS/usr/share/jitsi-meet/interface_config.js"
PROSODY_CONFIG="$JITSI_ROOTFS/etc/prosody/conf.avail/___JITSI_FQDN___.cfg.lua"

# ------------------------------------------------------------------------------
# backup
# ------------------------------------------------------------------------------
DATE=$(date +'%Y%m%d%H%M%S')
BACKUP=$BASEDIR/backup/$DATE

mkdir -p $BACKUP
cp $JITSI_CONFIG $BACKUP/
cp $JITSI_INTERFACE $BACKUP/
cp $JITSI_MEET/images/favicon.ico $BACKUP/
cp $JITSI_MEET/images/watermark.svg $BACKUP/
cp $PROSODY_CONFIG $BACKUP/
cp $PROSODY_CONFIG $BACKUP/

# ------------------------------------------------------------------------------
# config.js
# ------------------------------------------------------------------------------
[[ -f "$BASEDIR/files/___JITSI_FQDN___-config.js" ]] && \
    cp $BASEDIR/files/___JITSI_FQDN___-config.js $JITSI_CONFIG

# ------------------------------------------------------------------------------
# interface_config.js
# ------------------------------------------------------------------------------
[[ -f "$BASEDIR/files/interface_config.js" ]] && \
    cp $BASEDIR/files/interface_config.js $JITSI_INTERFACE

# ------------------------------------------------------------------------------
# custom files
# ------------------------------------------------------------------------------
[[ -f "$BASEDIR/files/favicon.ico" ]] && \
    cp $BASEDIR/files/favicon.ico $JITSI_MEET/
[[ -f "$BASEDIR/files/favicon.ico" ]] && \
    cp $BASEDIR/files/favicon.ico $JITSI_MEET/images/
[[ -f "$BASEDIR/files/watermark.svg" ]] && \
    cp $BASEDIR/files/watermark.svg $JITSI_MEET/images/
[[ -f "$BASEDIR/files/watermark.png" ]] && \
    cp $BASEDIR/files/watermark.png $JITSI_MEET/images/
[[ -f "$BASEDIR/files/operator.png" ]] && \
    cp $BASEDIR/files/operator.png $JITSI_MEET/images/
[[ -f "$BASEDIR/files/customer.png" ]] && \
    cp $BASEDIR/files/customer.png $JITSI_MEET/images/
[[ -f "$BASEDIR/files/body.html" ]] && \
    cp $BASEDIR/files/body.html $JITSI_MEET/
[[ -f "$BASEDIR/files/custom.css" ]] && \
    cp $BASEDIR/files/custom.css $JITSI_MEET/css/
[[ -f "$BASEDIR/files/close2.html" ]] && \
    cp $BASEDIR/files/close2.html $JITSI_MEET/static/
