# SteavenNIX

My personal NixOS configuration for my desktop PC. This configuration will eventually be used across my laptops once fully tested and stabilized.

## 🚀 Current Status

### Working Features ✅
- **Window Manager**: Hyprland
- **System Configuration**:
  - SSH with key-based authentication
  - Samba file sharing
  - Flatpak integration
  - PipeWire audio system
  - XDG Portal configuration
  - Qt theming (Nordic theme)
  - Font configuration (Nerd Fonts, Noto, etc.)

### Partially Working Features 🟨
- **Desktop Environment**:
  - Waybar (needs font configuration)
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
  - GPU passthrough
  - Bluetooth
  - Audio (gaming headset udev rules)
  - Printer support

- **Virtualization**:
  - Virt Manager (network configuration)
  - GPU passthrough

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
- **Window Manager**: Hyprland
- **Display Manager**: LightDM
- **Theme**: Nordic
- **Icons**: Papirus-Dark
- **Cursors**: WhiteSur
- **Font**: RobotoMono Nerd Font

### Package Management
- Nix packages
- Flatpak
- AppImages

## 📝 TODO
- [ ] Complete Waybar configuration
- [ ] Set up proper Rofi configuration
- [ ] Configure GPU passthrough
- [ ] Fix Bluetooth support
- [ ] Set up proper audio configuration
- [ ] Configure printer support
- [ ] Complete application configurations
- [ ] Set up proper device synchronization

## 🔒 Security
- SSH key-based authentication
- Samba with user authentication
- Secure boot configuration

## 🎮 Gaming
- Steam integration
- Proton GE setup
- Emulator configuration
- Game mode and performance optimizations

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

