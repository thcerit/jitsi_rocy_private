# ------------------------------------------------------------------------------
# JITSI-CUSTOMIZATION.SH
# ------------------------------------------------------------------------------
set -e
source $INSTALLER/000-source

# ------------------------------------------------------------------------------
# ENVIRONMENT
# ------------------------------------------------------------------------------
MACH="eb-jitsi-host"
cd $MACHINES/$MACH

# ------------------------------------------------------------------------------
# INIT
# ------------------------------------------------------------------------------
[ "$DONT_RUN_JITSI_CUSTOMIZATION" = true ] && exit

echo
echo "------------------- JITSI CUSTOMIZATION -------------------"

# ------------------------------------------------------------------------------
# CUSTOMIZATION
# ------------------------------------------------------------------------------
JITSI_ROOTFS="/var/lib/lxc/eb-jitsi/rootfs"
JITSI_MEET="$JITSI_ROOTFS/usr/share/jitsi-meet"

if [[ ! -d "/root/jitsi-customization" ]]; then
    cp -arp root/jitsi-customization-202208 /root/jitsi-customization

    sed -i "s/___TURN_FQDN___/$TURN_FQDN/g" \
        /root/jitsi-customization/README.md
    sed -i "s/___JITSI_FQDN___/$JITSI_FQDN/g" \
        /root/jitsi-customization/README.md
    sed -i "s/___TURN_FQDN___/$TURN_FQDN/g" \
        /root/jitsi-customization/customize.sh
    sed -i "s/___JITSI_FQDN___/$JITSI_FQDN/g" \
        /root/jitsi-customization/customize.sh

    cp $JITSI_ROOTFS/etc/jitsi/meet/$JITSI_FQDN-config.js \
        /root/jitsi-customization/files/
    cp $JITSI_ROOTFS//usr/share/jitsi-meet/interface_config.js \
        /root/jitsi-customization/files/
else
    echo "There is already an old customization folder."
    echo "Automatic customization skipped."
    echo "Run your own customization script manually."
fi
