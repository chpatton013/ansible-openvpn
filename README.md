# OpenVPN - Debian 8 - Ansible Playbook

Configure a hardened OpenVPN server on Debian 8.

## Assumptions

Your network interfaces have been configured correctly. You have a loopback
device and an ethernet device with a static IP:
```
/etc/network/interfaces
---

auto {{lo_interface}}
iface {{lo_interface}} inet loopback

auto {{eth_interface}}
allow-hotplug {{eth_interface}}
iface {{eth_interface}} inet static
  address 192.168.1.XXX
  netmask 255.255.255.0
  gateway 192.168.1.1
```

Your network interface configuration has been applied:
```
#!/bin/bash
---

ip link set eth0 down
ip link set eth0 up
```
