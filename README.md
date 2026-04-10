# Arch Configuration

Ansible playbook for configuring an Arch Linux workstation.

## Prerequisites

- Fresh Arch install with `base`, `linux`, `openssh`, `python`, `sudo`
- User in `wheel` group with passwordless sudo
- `dhcpcd` enabled for networking

## Quick start

```bash
# Install dependencies
ansible-galaxy collection install -r requirements.yml

# Run
sudo ./runit-arch
```

## Usage

| Command | Description |
|---|---|
| `./runit-arch` | Full setup (desktop + gaming) |
| `./runit-gaming` | Gaming packages only |

Use tags to run specific parts:

```bash
ansible-playbook playbook.yml --tags pacman      # mirrors + pacman.conf
ansible-playbook playbook.yml --tags gpu       # GPU drivers
ansible-playbook playbook.yml --tags gaming    # gaming packages
ansible-playbook playbook.yml --skip-tags gaming  # everything except gaming
```

## Configuration

Edit `inventory/group_vars/`:

| File | Description |
|---|---|
| `all/vars.yml` | User, timezone, home dirs, shared packages |
| `archlinux.yml` | Hostname, GPU settings, base packages |

### GPU

Set in `inventory/group_vars/archlinux.yml`:

```yaml
enable_nvidia: true
# or
enable_amd: true
```

## Roles

| Role | Description |
|---|---|
| `pacman-optimization` | Parallel downloads, multilib, reflector |
| `makepkg-optimization` | Build flags, ccache, tmpfs |
| `system-configuration` | Hostname, timezone, shell, SSH, sudo |
| `bootstrap-deps` | Installs yay (AUR helper) |
| `boot-optimization` | Initramfs tuning |
| `common` | Home directories |
| `packages-base` | CLI tools via pacman/AUR |
| `gpu` | NVIDIA or AMD drivers |
| `packages-hyprland` | Hyprland desktop stack |
| `packages-gaming` | Wine, Steam, etc. |
| `dotfiles` | Dotfiles deployment |