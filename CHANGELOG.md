# Changelog

## Version 1.1.5

* [BREAKING_CHANGE] - Removed indivudial `.sh` files in favor of `proxmox_generic.sh` script. This script is now used for all Proxmox templates. Detailed usage with all options can be found in the `README.md` file.
* [FEATURE] - added EFI boot support for Proxmox. Every variable pack now has a new variable `use_efi` that can be set to `true` or `false`. If set to `true`, the template will be created with EFI boot support. If set to `false`, the template will be created with BIOS boot support. The default value is `false`.
  * [PROXMOX] - added support for EFI boot for `RockyLinux`
  * [PROXMOX] - added support for EFI boot for `AlmaLinux`
  * [PROXMOX] - added support for EFI boot for `OracleLinux`
  * [PROXMOX] - added support for EFI boot for `OpenSuse Leap`
  * [PROXMOX] - added support for EFI boot for `Ubuntu`
  * [PROXMOX] - added support for EFI boot for `Windows 2019`
  * [PROXMOX] - added support for EFI boot for `Windows 2022`
* [ANSIBLE] - added added section `gpgkey` to playbook, for easy GPG key installation before any repository operations are initiated. This is useful for systems that changed their GPG keys. The format is as follows:

  ```yaml
  gpgkey:
    - url: "https://example.com/key.gpg"
      state: present|absent
  ```

* [ANSIBLE] - changed playbook version to 20240612
* [ORACLE] - fixed `ks.cfg` for version 8 using LVM instead of plain disks.
* [PROXMOX] - added support for `OpenSuse Leap 15.6`

## Version 1.1.4

* [PROXMOX] - added support `Oracle Linux 8.10`
* [PROXMOX] - added support `Rocky Linux 8.10`
* [PROXMOX] - added support `Alma Linux 8.10`
* [KVM]     - added support `Oracle Linux 8.10`
* [KVM]     - added support `Rocky Linux 8.10`
* [KVM]     - added support `Alma Linux 8.10`

## Version 1.1.3

* [PROXMOX] - added support for Ubuntu 24.04

## Version 1.1.2

* [ANSIBLE] - change playbook version to 202400404
* [ANSIBLE] - removed `systemd.unified_cgroup_hierarchy` for RHEL anc clones above 8 as this is set by default in OS
* [EXTRA]   - fixed wrong version in unnatended file for Windows 219
* [PROXMOX] - fixed versions in template files for Windows 2022
* [PROXMOX] - added support for `AlmaLinux 9.4`
* [PROXMOX] - added support for `Oracle Linux 9.4`\
* [PROXMOX] - added support for `Rocky Linux 9.4`
* [KVM]     - added support for `AlmaLinux 9.4`
* [KVM]     - added support for `Oracle Linux 9.4`
* [KVM]     - added support for `Rocky Linux 9.4`
* [README]  - added information about default credentials used

## Version 1.1.1

* [ANSIBLE] small changes for oracle 9 epel package name
* [PACKER] added `"--scp-extra-args", "'-O'"` option to /proxmoxm/variables_*.pkvars.hcl` files
  * [EXAMPLE] `ansible_extra_args        = ["-e", "@extra/playbooks/provision_rocky9_variables.yml", "-e", "@variables/rockylinux9.yml","--scp-extra-args", "'-O'"]`

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
