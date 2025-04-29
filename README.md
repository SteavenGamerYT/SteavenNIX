# SteavenNIX

My personal NixOS configuration for my desktop PC. This configuration will eventually be used across my laptops once fully tested and stabilized.

## 🚀 Current Status

### Working Features ✅
- **System Configuration**:
  - SSH with key-based authentication
  - Samba file sharing
  - Flatpak integration
  - PipeWire audio system
  - XDG Portal configuration
  - Qt theming (Nordic theme)
  - Font configuration (Nerd Fonts, Noto, etc.)
  - KVM/QEMU virtualization with libvirt
  - Looking Glass support (kvmfr)
  - GPU passthrough configuration
  - Custom kernel (CachyOS) with patches
  - Hardware monitoring (lm_sensors, zenpower)
  - CoolerControl for hardware control
  - Bluetooth support
  - Audio configuration (including gaming headset)

- **Desktop Environment**:
  - i3 window manager with Polybar
  - Rofi configuration
  - Power menu
  - Device synchronization

- **Applications**:
  - Librewolf
  - VS Code
  - OBS Studio
  - Steam
  - Default applications set
  - Proton GE
  - Emulators

### Partially Working Features 🟨
- **Applications**:
  - LibreOffice (needs fonts)
  - OnlyOffice (needs fonts)
  - GitHub Desktop
  - Element Desktop

### Needs Configuration 🔧
- **Hardware Support**:
  - Printer support

### Integration Services
- KDE Connect (device pairing)
- Syncthing (configuration and device sync)
- SSH (device configuration)

## 🛠️ Technical Details

### System Configuration
- **Kernel**: CachyOS with custom patches
  - Disabled IT87 driver
  - Disabled unused GPU drivers
  - Nvidia GPU passthrough support
  - Looking Glass support
- **Display Manager**: LightDM
- **Theme**: Nordic
- **Icons**: Papirus-Dark
- **Cursors**: WhiteSur
- **Font**: RobotoMono Nerd Font

### Hardware Configuration
- **CPU**: AMD with microcode updates
- **GPU**: Nvidia with passthrough support
- **Storage**: Multiple partitions (/, /home, /boot, /mnt/nvme)
- **Monitors**: Dual monitor setup (1920x1080 + 1366x768)
- **Cooling**: CoolerControl for hardware control

### Package Management
- Nix packages
- Flatpak
- AppImages
- Chaotic-Nyx overlay

## 📝 TODO
- [ ] Configure printer support
- [ ] Complete remaining application configurations

## 🔒 Security
- SSH key-based authentication
- Samba with user authentication
- Secure boot configuration
- KVM/QEMU security settings

## 🎮 Gaming
- Steam integration
- Proton GE setup
- Emulator configuration
- Game mode and performance optimizations
- GPU passthrough for gaming VMs

## 📱 Device Integration
- KDE Connect setup
- Syncthing configuration
- SSH device management

## 🎨 Customization
- Qt theming
- Font configuration
- Application theming
- Desktop environment customization

## 🔄 Updates
This configuration is actively maintained and updated. Check back regularly for improvements and new features.

