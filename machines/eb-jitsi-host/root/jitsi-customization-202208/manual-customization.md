## Manual Customizations

#### /etc/jitsi/videobridge/sip-communicator.properties (eb-jitsi)

If there is no access to remote STUN, apply followings:

- Disable `org.ice4j.ice.harvest.STUN_MAPPING_HARVESTER_ADDRESSES`
- Set `org.ice4j.ice.harvest.NAT_HARVESTER_LOCAL_ADDRESS` as `172.22.22.14`
- Set `org.ice4j.ice.harvest.NAT_HARVESTER_PUBLIC_ADDRESS`

```bash
systemctl restart jitsi-videobridge2.service
```

#### /root/jitsi-customization/files/interface_config.js (jms-host)

- `APP_NAME`
- `DEFAULT_BACKGROUND: '#040404'`
- `DISABLE_DOMINANT_SPEAKER_INDICATOR: true`
- `GENERATE_ROOMNAMES_ON_WELCOME_PAGE: false`
- `HIDE_INVITE_MORE_HEADER: true`
- `JITSI_WATERMARK_LINK`
- `MOBILE_APP_PROMO: false`

#### get JMS key (jibri-host)

Run this command if `jms.pub` doesn't exist in `/root/.ssh/authorized_keys`.

```bash
curl -k https://<JMS_IP_ADDRESS>/static/jms.pub >> /root/.ssh/authorized_keys
```

#### add Jibri (jms-host)

```bash
add-jibri-node <JIBRI_NODE_IP> <STREAM_SERVER_IP>
```

#### /var/lib/lxc/eb-jibri-template/rootfs/etc/hosts (jibri-host)

Add the followings if the Jibri nodes are in the same local network with JMS:

```
JMS_LOCAL_IP    JITSI_FQDN
JMS_LOCAL_IP    TURNS_FQDN
```

#### /var/lib/lxc/eb-jibri-template/rootfs/etc/jitsi/jibri/xorg-video-dummy.conf (jibri-host)

Update `Virtual`

```
Section "Screen"
  SubSection "Display"
    Virtual 1280 720
    #Virtual 1920 1080
  EndSubSection
EndSection
```

#### restart Jibri (jibri-host)

```bash
systemctl stop jibri-ephemeral-container.service
systemctl start jibri-ephemeral-container.service
```
