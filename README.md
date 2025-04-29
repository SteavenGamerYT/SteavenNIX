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

### Partially Working Features 🟨
- **Desktop Environment**:
  - i3 window manager (basic setup)
  - Polybar (installed but needs configuration)
  - Rofi (needs proper configuration)
  - Power menu (needs relocation)

- **Applications**:
  - Firefox (basic configuration done, addons pending)
  - VS Code (needs proper configuration)
  - OBS Studio (needs udev rules and plugins)
  - Steam (some games working, runtime issues)
  - Default applications set (needs refinement)

### Needs Configuration 🔧
- **Hardware Support**:
  - Bluetooth
  - Audio (gaming headset udev rules)
  - Printer support

- **Applications**:
  - Proton GE
  - Emulators
  - LibreOffice (needs fonts)
  - OnlyOffice (needs fonts)
  - GitHub Desktop
  - Element Desktop
  - Konsole (needs proper configuration)

### Integration Services
- KDE Connect (device pairing)
- Syncthing (configuration and device sync)
- SSH (device configuration)

## 🛠️ Technical Details

### System Configuration
- **Kernel**: CachyOS with custom patches
  - Disabled IT87 driver
  - Disabled unused GPU drivers
  - AMD GPU passthrough support
  - Looking Glass support
- **Display Manager**: LightDM
- **Theme**: Nordic
- **Icons**: Papirus-Dark
- **Cursors**: WhiteSur
- **Font**: RobotoMono Nerd Font

### Hardware Configuration
- **CPU**: AMD with microcode updates
- **GPU**: AMD with passthrough support
- **Storage**: Multiple partitions (/, /home, /boot, /mnt/nvme)
- **Monitors**: Dual monitor setup (1920x1080 + 1366x768)
- **Cooling**: CoolerControl for hardware control

### Package Management
- Nix packages
- Flatpak
- AppImages
- Chaotic-Nyx overlay

## 📝 TODO
- [ ] Complete i3 and Polybar configuration
- [ ] Set up proper Rofi configuration
- [ ] Fix Bluetooth support
- [ ] Set up proper audio configuration
- [ ] Configure printer support
- [ ] Complete application configurations
- [ ] Set up proper device synchronization

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

