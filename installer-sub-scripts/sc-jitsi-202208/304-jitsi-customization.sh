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
FOLDER="/root/jitsi-customization"

# is there an old customization folder?
if [[ -d "/root/jitsi-customization" ]]; then
    FOLDER="/root/jitsi-customization-new"
    rm -rf $FOLDER

    echo "There is already an old customization folder."
    echo "A new folder will be created as $FOLDER"
fi

cp -arp root/jitsi-customization-202208 $FOLDER

sed -i "s/___TURN_FQDN___/$TURN_FQDN/g" $FOLDER/README.md
sed -i "s/___JITSI_FQDN___/$JITSI_FQDN/g" $FOLDER/README.md
sed -i "s/___TURN_FQDN___/$TURN_FQDN/g" $FOLDER/customize.sh
sed -i "s/___JITSI_FQDN___/$JITSI_FQDN/g" $FOLDER/customize.sh

cp $JITSI_ROOTFS/etc/jitsi/meet/$JITSI_FQDN-config.js $FOLDER/files/
cp $JITSI_ROOTFS//usr/share/jitsi-meet/interface_config.js $FOLDER/files/
