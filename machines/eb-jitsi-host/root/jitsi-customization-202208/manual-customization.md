## Manual Customizations

#### /etc/jitsi/videobridge/sip-communicator.properties (eb-jitsi)

If there is no access to remote STUN, apply followings:

```bash
# disable STUN in sip-communicator.properties and jvb.conf
hocon -f /etc/jitsi/videobridge/jvb.conf set \
  ice4j.harvest.mapping.stun.enabled false

# local pair
hocon -f /etc/jitsi/videobridge/jvb.conf set \
  ice4j.harvest.mapping.static-mappings.0.local-address 172.22.22.14
hocon -f /etc/jitsi/videobridge/jvb.conf set \
  ice4j.harvest.mapping.static-mappings.0.public-address <LOCAL-HOST-IP>

# public pair
hocon -f /etc/jitsi/videobridge/jvb.conf set \
  ice4j.harvest.mapping.static-mappings.1.local-address 172.22.22.14
hocon -f /etc/jitsi/videobridge/jvb.conf set \
  ice4j.harvest.mapping.static-mappings.1.public-address <EXTERNAL-IP>

systemctl restart jitsi-videobridge2.service
```

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
