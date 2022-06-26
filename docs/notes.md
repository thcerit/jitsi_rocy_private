### UDP/10000 routing

If `jibri` is in the same network with `JVB` and if there is an issue to
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
    ip saddr 172.22.22.0/24 ip daddr JVB_PUBLIC_IP udp dport 10000 dnat to JVB_LOCAL_IP
  }
}
```
