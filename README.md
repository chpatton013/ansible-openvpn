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

## Playbooks

Configuring OpenVPN can be broken up into many parts, so we have several
playbooks that each take on part of the job:

### `server_dependencies.yaml`

Make system changes that do not directly impact the OpenVPN configuration.

* Install packages
* Setup unattended upgrades
* Disable IPv6
* Setup iptables rules

### `server_configuration.yaml`

Make system changes that do directly impact the OpenVPN configuration.

* Create an openvpn user account
* Create openvpn config files
* Generate server keys
* Start and enable openvpn service

### `client.yaml`

Create credentials for a new client.

* Generate client keys
* Package client keys and config into a tarball

### `all_in_one.yaml`

Setup server dependencies, server configuration, and a defined set of clients.

## Usage

```
ansible-playbook all_in_one.yaml \
  --inventory=hosts.ini \
  --ask-sudo-pass \
  -e openvpn_key_org=MyOrg \
  -e openvpn_key_email=me@me.com \
  -e openvpn_key_name=test_name \
  -e openvpn_server_address=me.com \
  -e '{"openvpn_routes":[{"subnet":"192.168.1.0","netmask":"255.255.255.0"}]}' \
  -e '{"openvpn_client_names":["client_1","client_2"]}'

ansible-playbook server_dependencies.yaml --inventory=hosts.ini --ask-sudo-pass

ansible-playbook server_configuration.yaml \
  --inventory=hosts.ini \
  --ask-sudo-pass \
  -e openvpn_key_org=MyOrg \
  -e openvpn_key_email=me@me.com \
  -e openvpn_key_name=server_name \
  -e openvpn_server_address=me.com \
  -e '{"openvpn_routes":[{"subnet":"192.168.1.0","netmask":"255.255.255.0"}]}'

ansible-playbook client.yaml \
  --inventory=hosts.ini \
  --ask-sudo-pass \
  -e openvpn_client_name=client1
```

### No IPv6 support

Certain environments do not have IPv6 support at all, which causes several tasks
to fail. Pass this flag to the `server_dependencies` and `all_in_one` playbooks
to skip any tasks that relate to IPv6:

```
-e disable_ipv6=no
```

### Testing

You may want to decrease your key size while testing to help with iteration
times. Pass this flag to the `server_configuration` and `all_in_one` playbooks
to generate a weaker key:

```
-e openvpn_key_size=1024
```
