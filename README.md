# OpenVPN - Debian 8 - Ansible Playbook

Configure a hardened OpenVPN server on Debian 8.

## Assumptions

Your network interfaces have been configured correctly. You have a loopback
device and an LAN device with a static IP:
```
/etc/network/interfaces
---

auto {{lo_interface}}
iface {{lo_interface}} inet loopback

auto {{lan_interface}}
allow-hotplug {{lan_interface}}
iface {{lan_interface}} inet static
  address 192.168.1.XXX
  netmask 255.255.255.0
  gateway 192.168.1.1
```

Your network interface configuration has been applied:
```
#!/bin/bash
---

ip link set {{lan_interface}} down
ip link set {{lan_interface}} up
```
