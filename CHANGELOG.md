# Changelog

## Version 1.1.0

* [ANSIBLE] - permanent removal variables from playbook
  * install_zabbix:                false # install Zabbix-agent
  * install_zabbix_as_root:        false # install Zabbix-agent as root
  * install_puppet:                true  # Install Puppet
  * install_kubernetes_workaround: false # add `cgroup.memory=nokmem` to grub

* [ANSIBLE] - introduced new variables
  * `install_kernel_parameters` (default: `true`) - install kernel parameters
    * default content:

    ```yaml
      kernel_parameters:
        - key: "fsck.repair"
        value: "yes"
        state: present
        - key: "systemd.unified_cgroup_hierarchy"
        value: "1"
        state: present
    ```

* [PACKER] - added version 1.10.0 support

## Version 1.0.9

* [KVM] added `Rocky Linux 8.9` KVM template
* [KVM] added `Rocky Linux 9.3` KVM template
* [KVM] added `Alma Linux 8.9` KVM template
* [KVM] added `Alma Linux 9.3` KVM template
* [KVM] added `Oracle Linux 8.9` KVM template
* [KVM] added `Oracle Linux 9.3` KVM template
* [PROXMOX] added `Rocky Linux 8.9`
* [PROXMOX] added `Alma Linux 8.9`
* [PROXMOX] added `Oracle Linux 8.9`

## Version 1.0.8

* [PROXMOX] added `Rocky Linux 9.3`
* [PROXMOX] added `Alma Linux 9.3`
* [PROXMOX] added `Oracle Linux 9.3`

## Version 1.0.7

* fixes and tyding up for `extras` folder structure changes

## Version 1.0.6

* [KVM] added `Alma Linux 8.7` KVM template
* [KVM] added `Alma Linux 8.8` KVM template
* [KVM] added `Alma Linux 9.0` KVM template
* [KVM] added `Alma Linux 9.1` KVM template
* [KVM] added `Alma Linux 9.2` KVM template

## Version 1.0.5

* [KVM] added `Oracle Linux 8.6` KVM template
* [KVM] added `Oracle Linux 8.7` KVM template
* [KVM] added `Oracle Linux 8.8` KVM template
* [KVM] added `Oracle Linux 9.0` KVM template
* [KVM] added `Oracle Linux 9.1` KVM template
* [KVM] added `Oracle Linux 9.2` KVM template
* [KVM] added `Rocky Linux 9.0` KVM template
* [KVM] added `Rocky Linux 9.1` KVM template

## Version 1.0.4

* KVM build are GA. Supported cloud-init configs are:
  * `generic` for on-premises or no cloud-specific environment
  * `oci` for Oracle Cloud Infrastructure
  * `alicloud` for Alibaba Cloud
* added `Rocky Linux 8.7` KVM template
* added `Rocky Linux 8.8` KVM template
* added `Rocky Linux 9.2` KVM template

## Version 1.0.3

* added `Microsoft Windows 2019 Standard` Proxmox template
* added `Microsoft Windows 2019 Datacenter` Proxmox template
* [BREAKING_CHANGE] - reorganize folders under `extra` sections

## Version 1.0.2

* [BREAKING_CHANGE] - reorganize folders under `extra` sections
  Instead of separating by hypervisors, the primary folder structure is being built by OS as a primary key. Second-level folders are hypervisors. This will allow for easier maintenance and better readability.
* added `OpenSuse Leap 15.5` Proxmox template
  The template is very basic and needs more work with customization.

## Version  1.0.1

* added `Ubuntu 22.04 HWE kernel` Proxmox template

## Version 1.0.0 - Initial commit
