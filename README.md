# Android Second Monitor

Use your Android device as a **secondary monitor** for your Linux PC via USB tethering.

Works with **Hyprland** (Wayland compositor) using `wayvnc` and ADB reverse port forwarding.

## How it works

1. Creates a **virtual headless monitor** in Hyprland
2. Starts a **VNC server** (`wayvnc`) on that monitor
3. Forwards the VNC port over **ADB reverse** to your Android device
4. You connect via any **VNC client** (e.g. AVNC) on your phone

## Requirements

- **Hyprland** (Wayland compositor)
- `wayvnc` installed
- `adb` (Android Debug Bridge) installed
- USB debugging **enabled** on your Android device
- A VNC client on your phone (e.g. [AVNC](https://github.com/gujjadal00/AVNC))

## Installation

### 1. Clone the repo

```bash
git clone https://github.com/ferssisi06/android-second-monitor.git
cd android-second-monitor
```

### 2. Run the installer

```bash
chmod +x install.sh
./install.sh
```

The installer will:
- Detect your shell (`bash`, `zsh`, `fish`, or others)
- Copy the scripts to `~/.local/bin/`
- Add the following aliases to your shell config:

| Short  | Long              | Description          |
|--------|-------------------|----------------------|
| `mon-start` | `second-mon-start` | Start secondary monitor |
| `mon-stop`  | `second-mon-stop`  | Stop secondary monitor  |

Reload your shell or run `source ~/.bashrc` (or your shell's config file).

## Usage

### Start the secondary monitor

```bash
mon-start
# or
second-mon-start
```

What happens:
1. Checks for an Android device connected via USB with debugging enabled
2. Sets up ADB reverse port forwarding on port **5900**
3. Creates a headless monitor in Hyprland (1920x1080@60)
4. Moves **workspace 10** to the secondary screen
5. Starts `wayvnc` on the headless monitor (port 5900)

Then on your Android device:
- Open your VNC client (e.g. AVNC)
- Connect to **127.0.0.1:5900**

### Stop the secondary monitor

```bash
mon-stop
# or
second-mon-stop
```

What happens:
1. Terminates `wayvnc`
2. Removes the virtual headless monitor from Hyprland
3. Clears the ADB reverse port mapping

## Uninstall

```bash
rm -f ~/.local/bin/second-mon-start ~/.local/bin/second-mon-stop
```

Then remove the alias lines from your shell config (`~/.bashrc`, `~/.zshrc`, or `~/.config/fish/config.fish`).

## Notes

- The secondary monitor is set to **1920x1080@60** and placed to the **right** of your primary display
- All traffic stays on the USB cable — **no Wi-Fi or internet required**
- The VNC server binds to **0.0.0.0** (all interfaces) with authentication disabled — use only on trusted USB connections
