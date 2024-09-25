# ------------------------------------------------------------------------------
# JIBRI.SH
# ------------------------------------------------------------------------------
set -e
source $INSTALLER/000-source

# ------------------------------------------------------------------------------
# ENVIRONMENT
# ------------------------------------------------------------------------------
MACH="eb-jibri-template"
cd $MACHINES/$MACH

ROOTFS="/var/lib/lxc/$MACH/rootfs"

# ------------------------------------------------------------------------------
# INIT
# ------------------------------------------------------------------------------
[[ "$DONT_RUN_JIBRI" = true ]] && exit

echo
echo "-------------------------- $MACH --------------------------"

# ------------------------------------------------------------------------------
# CONTAINER SETUP
# ------------------------------------------------------------------------------
# stop the template container if it's running
set +e
lxc-stop -n eb-bullseye
lxc-wait -n eb-bullseye -s STOPPED
set -e

# remove the old container if exists
set +e
systemctl stop jibri-ephemeral-container.service

lxc-stop -n $MACH
lxc-wait -n $MACH -s STOPPED
lxc-destroy -n $MACH
rm -rf /var/lib/lxc/$MACH
sleep 1
set -e

# create the new one
lxc-copy -n eb-bullseye -N $MACH -p /var/lib/lxc/

# the shared directories
mkdir -p $SHARED/cache
mkdir -p $SHARED/recordings

# the container config
rm -rf $ROOTFS/var/cache/apt/archives
mkdir -p $ROOTFS/var/cache/apt/archives
rm -rf $ROOTFS/usr/local/eb/recordings
mkdir -p $ROOTFS/usr/local/eb/recordings

cat >> /var/lib/lxc/$MACH/config <<EOF
lxc.mount.entry = $SHARED/recordings usr/local/eb/recordings none bind 0 0

# Devices
lxc.cgroup2.devices.allow = c 116:* rwm
lxc.mount.entry = /dev/snd dev/snd none bind,optional,create=dir

# Start options
lxc.start.auto = 1
lxc.start.order = 301
lxc.start.delay = 2
lxc.group = eb-group
lxc.group = eb-jibri
EOF

# start the container
lxc-start -n $MACH -d
lxc-wait -n $MACH -s RUNNING

# wait for the network to be up
for i in $(seq 0 29); do
    lxc-attach -n $MACH -- ping -c1 host.loc && break || true
    sleep 2
done

# ------------------------------------------------------------------------------
# HOSTNAME
# ------------------------------------------------------------------------------
lxc-attach -n $MACH -- zsh <<EOS
set -e
echo "nameserver 8.8.8.8" > /etc/resolv.conf
echo $MACH > /etc/hostname
sed -i 's/\(127.0.1.1\s*\).*$/\1$MACH/' /etc/hosts
hostname $MACH
EOS

# ------------------------------------------------------------------------------
# HOST PACKAGES
# ------------------------------------------------------------------------------
zsh <<EOS
set -e
echo "nameserver 8.8.8.8" > /etc/resolv.conf
export DEBIAN_FRONTEND=noninteractive
dnf -y install kmod alsa-utils
EOS

# ------------------------------------------------------------------------------
# PACKAGES
# ------------------------------------------------------------------------------
# fake install
lxc-attach -n $MACH -- zsh <<EOS
set -e
echo "nameserver 8.8.8.8" > /etc/resolv.conf
echo "151.101.38.132 deb.debian.org" > /etc/hosts
echo "151.101.38.132 security.debian.org" > /etc/hosts
export DEBIAN_FRONTEND=noninteractive
#apt-get -dy reinstall hostname
apt-get -y install hostname
EOS

# update
lxc-attach -n $MACH -- zsh <<EOS
set -e
echo "nameserver 8.8.8.8" > /etc/resolv.conf
export DEBIAN_FRONTEND=noninteractive
apt-get -y update
apt-get -y dist-upgrade
EOS

# packages
lxc-attach -n $MACH -- zsh <<EOS
set -e
echo "nameserver 8.8.8.8" > /etc/resolv.conf
#echo "151.101.38.132 deb.debian.org" > /etc/hosts
#echo "151.101.38.132 security.debian.org" > /etc/hosts
export DEBIAN_FRONTEND=noninteractive
apt-get -y update
apt-get -y install gnupg unzip jq
apt-get -y install libnss3-tools
apt-get -y install va-driver-all vdpau-driver-all
apt-get -y --install-recommends install ffmpeg
apt-get -y install x11vnc
EOS

# google chrome
cp etc/apt/sources.list.d/google-chrome.list $ROOTFS/etc/apt/sources.list.d/
lxc-attach -n $MACH -- zsh <<EOS
set -e
echo "nameserver 8.8.8.8" > /etc/resolv.conf
wget -T 30 -qO /tmp/google-chrome.gpg.key \
    https://dl.google.com/linux/linux_signing_key.pub
apt-key add /tmp/google-chrome.gpg.key
apt-get update
EOS

lxc-attach -n $MACH -- zsh <<EOS
set -e
echo "nameserver 8.8.8.8" > /etc/resolv.conf
export DEBIAN_FRONTEND=noninteractive
apt-get -y --install-recommends install google-chrome-stable
EOS

# chromedriver
lxc-attach -n $MACH -- zsh <<EOS
set -e
echo "nameserver 8.8.8.8" > /etc/resolv.conf
CHROME_VER=\$(dpkg -s google-chrome-stable | egrep "^Version" | \
    cut -d " " -f2 | cut -d. -f1-3)
CHROMELAB_LINK="https://googlechromelabs.github.io/chrome-for-testing"
CHROMEDRIVER_LINK=\$(curl -s \
    \$CHROMELAB_LINK/known-good-versions-with-downloads.json | \
    jq -r ".versions[].downloads.chromedriver | select(. != null) | .[].url" | \
    grep linux64 | grep "\$CHROME_VER" | tail -1)
wget -T 30 -qO /tmp/chromedriver-linux64.zip \$CHROMEDRIVER_LINK
unzip -o /tmp/chromedriver-linux64.zip -d /tmp
mv /tmp/chromedriver-linux64/chromedriver /usr/local/bin/
chmod 755 /usr/local/bin/chromedriver
EOS

# jibri
cp etc/apt/sources.list.d/jitsi-stable.list $ROOTFS/etc/apt/sources.list.d/
lxc-attach -n $MACH -- zsh <<EOS
set -e
echo "nameserver 8.8.8.8" > /etc/resolv.conf
wget -T 30 -qO /tmp/jitsi.gpg.key https://download.jitsi.org/jitsi-key.gpg.key
cat /tmp/jitsi.gpg.key | gpg --dearmor >/usr/share/keyrings/jitsi.gpg
apt-get update
EOS

lxc-attach -n $MACH -- zsh <<EOS
set -e
echo "nameserver 8.8.8.8" > /etc/resolv.conf
export DEBIAN_FRONTEND=noninteractive
apt-get -y install openjdk-11-jre-headless
apt-get -y install \
    jibri=8.0-121-g27323fe-1
EOS

# removed packages
lxc-attach -n $MACH -- zsh <<EOS
set -e
echo "nameserver 8.8.8.8" > /etc/resolv.conf
export DEBIAN_FRONTEND=noninteractive
apt-get -y purge upower
EOS

# hold
lxc-attach -n $MACH -- zsh <<EOS
set -e
echo "nameserver 8.8.8.8" > /etc/resolv.conf
export DEBIAN_FRONTEND=noninteractive
apt-mark hold jibri
EOS

# ------------------------------------------------------------------------------
# SYSTEM CONFIGURATION
# ------------------------------------------------------------------------------
# disable ssh service
lxc-attach -n $MACH -- zsh <<EOS
set -e
echo "nameserver 8.8.8.8" > /etc/resolv.conf
systemctl stop ssh.service
systemctl disable ssh.service
EOS

# snd_aloop module
#[ -z "$(egrep '^snd_aloop' /etc/modprobe.d/alsa-loopback.conf)" ] && echo snd_aloop >>/etc/modules
cp $MACHINES/eb-jibri-host/etc/modprobe.d/alsa-loopback.conf /etc/modprobe.d/
modprobe -r snd_aloop || true
modprobe snd_aloop || true
[[ "$DONT_CHECK_SND_ALOOP" = true ]] || [[ -n "$(lsmod | ack snd_aloop)" ]]

# google chrome managed policies
mkdir -p $ROOTFS/etc/opt/chrome/policies/managed
cp etc/opt/chrome/policies/managed/eb-policies.json \
    $ROOTFS/etc/opt/chrome/policies/managed/

# ------------------------------------------------------------------------------
# JIBRI
# ------------------------------------------------------------------------------
cp $ROOTFS/etc/jitsi/jibri/xorg-video-dummy.conf \
    $ROOTFS/etc/jitsi/jibri/xorg-video-dummy.conf.org

# meta
lxc-attach -n $MACH -- zsh <<EOS
set -e
echo "nameserver 8.8.8.8" > /etc/resolv.conf
mkdir -p /root/meta
VERSION=\$(apt-cache policy jibri | grep Installed | rev | cut -d' ' -f1 | rev)
echo \$VERSION > /root/meta/jibri-version
EOS

# jibri groups
lxc-attach -n $MACH -- zsh <<EOS
set -e
usermod -aG adm,audio,video,plugdev jibri
EOS

# jibri ssh
mkdir -p $ROOTFS/home/jibri/.ssh
chmod 700 $ROOTFS/home/jibri/.ssh
cp home/jibri/.ssh/jibri-config $ROOTFS/home/jibri/.ssh/
[[ -f /root/.ssh/jibri ]] && \
    cp /root/.ssh/jibri $ROOTFS/home/jibri/.ssh/ || \
    true

lxc-attach -n $MACH -- zsh <<EOS
set -e
chown jibri:jibri /home/jibri/.ssh -R
EOS

# jibri xorg
sed -i "s/Virtual 1920 1080/#Virtual 1920 1080/" \
    $ROOTFS/etc/jitsi/jibri/xorg-video-dummy.conf
sed -i "s/#Virtual 1280 720/Virtual 1280 720/" \
    $ROOTFS/etc/jitsi/jibri/xorg-video-dummy.conf

# jibri icewm startup
mkdir -p $ROOTFS/home/jibri/.icewm
cp home/jibri/.icewm/startup $ROOTFS/home/jibri/.icewm/
chmod 755 $ROOTFS/home/jibri/.icewm/startup

# recordings directory
lxc-attach -n $MACH -- zsh <<EOS
set -e
chown jibri:jibri /usr/local/eb/recordings -R
EOS

# pki
lxc-attach -n $MACH -- zsh <<EOS
set -e
mkdir -p /home/jibri/.pki/nssdb
chmod 700 /home/jibri/.pki
chmod 700 /home/jibri/.pki/nssdb
chown jibri:jibri /home/jibri/.pki -R
EOS

# jibri config
cp etc/jitsi/jibri/jibri.conf $ROOTFS/etc/jitsi/jibri/

# the customized scripts
cp usr/local/bin/finalize-recording.sh $ROOTFS/usr/local/bin/
chmod 755 $ROOTFS/usr/local/bin/finalize-recording.sh
cp usr/local/bin/ffmpeg $ROOTFS/usr/local/bin/
chmod 755 $ROOTFS/usr/local/bin/ffmpeg

# jibri ephemeral config service
cp usr/local/sbin/jibri-ephemeral-config $ROOTFS/usr/local/sbin/
chmod 744 $ROOTFS/usr/local/sbin/jibri-ephemeral-config
cp etc/systemd/system/jibri-ephemeral-config.service \
    $ROOTFS/etc/systemd/system/

lxc-attach -n $MACH -- zsh <<EOS
set -e
systemctl daemon-reload
systemctl enable jibri-ephemeral-config.service
EOS

# jibri service
lxc-attach -n $MACH -- zsh <<EOS
set -e
systemctl enable jibri.service
systemctl start jibri.service
EOS

# jibri vnc
lxc-attach -n $MACH -- zsh <<EOS
set -e
mkdir -p /home/jibri/.vnc
x11vnc -storepasswd jibri /home/jibri/.vnc/passwd
chown jibri:jibri /home/jibri/.vnc -R
EOS

# ------------------------------------------------------------------------------
# CONTAINER SERVICES
# ------------------------------------------------------------------------------
lxc-attach -n $MACH -- systemctl stop jibri-xorg.service
lxc-stop -n $MACH
lxc-wait -n $MACH -s STOPPED

# ------------------------------------------------------------------------------
# CLEAN UP
# ------------------------------------------------------------------------------
find $ROOTFS/var/log/jitsi/jibri -type f -delete

# ------------------------------------------------------------------------------
# EPHEMERAL JIBRI CONTAINERS
# ------------------------------------------------------------------------------
# jibri-ephemeral-container service
cp $MACHINES/eb-jibri-host/usr/local/sbin/jibri-ephemeral-start /usr/local/sbin/
cp $MACHINES/eb-jibri-host/usr/local/sbin/jibri-ephemeral-stop /usr/local/sbin/
chmod 744 /usr/local/sbin/jibri-ephemeral-start
chmod 744 /usr/local/sbin/jibri-ephemeral-stop

cp $MACHINES/eb-jibri-host/etc/systemd/system/jibri-ephemeral-container.service \
    /etc/systemd/system/

#systemctl daemon-reload
#systemctl enable jibri-ephemeral-container.service
#systemctl start jibri-ephemeral-container.service
#/usr/local/sbin/jibri-ephemeral-start

lxc-copy -n eb-jibri-template -N eb-jibri-1 -e
lxc-copy -n eb-jibri-template -N eb-jibri-2 -e
lxc-copy -n eb-jibri-template -N eb-jibri-3 -e
echo "-----------------------------------------"
lxc-ls -f
echo "-----------------------------------------"
echo "Starting containers.."
lxc-start --name eb-jibri-1
sleep 5
lxc-start --name eb-jibri-2
sleep 5
lxc-start --name eb-jibri-3
echo "-----------------------------------------"
lxc-ls -f
echo "-----------------------------------------"
