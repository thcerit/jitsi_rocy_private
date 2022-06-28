### UDP/10000 routing

#### Jibri nodes

If `jibri` is in the same network with `JVBs` and if there is an issue to
redirect incoming `UDP/10000` requests from the local networks, add the
following `nftables` rule to Jibri hosts.

**/etc/nftables.conf**

```
table ip eb-nat {
  ...
  ...
  chain prerouting {
    ...
    ...
    ip saddr 172.22.22.0/24 ip daddr JVB_PUBLIC_IP udp dport 10000 dnat to JVB_0_LOCAL_IP
    ip saddr 172.22.22.0/24 ip daddr JVB_PUBLIC_IP udp dport 10001 dnat to JVB_1_LOCAL_IP
  }
}
```

#### Jitsi host

If `coturn` and `JVBs` are on the same network and if there is an issue to
redirect incoming `UDP/10000` requests from `coturn` through the public IP, add
the following `nftables` rule to `Jitsi` host.

**/etc/nftables.conf**

```
table ip eb-nat {
  ...
  ...
  chain prerouting {
    ...
    ...
    ip saddr 172.22.22.0/24 ip daddr JVB_PUBLIC_IP udp dport 10000 dnat to JVB_0_LOCAL_IP
    ip saddr 172.22.22.0/24 ip daddr JVB_PUBLIC_IP udp dport 10001 dnat to JVB_1_LOCAL_IP
  }
}
```

No need to allow `172.22.22.14` in `turnserver.conf` in this case.
