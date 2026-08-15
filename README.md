# DEPRECATED

# Unraid UGREEN LED Driver Plugin

This is the repository for the Unraid UGREEN LED Driver plugin based on: https://github.com/miskcoo/ugreen_dx4600_leds_controller

**Support Thread:** https://forums.unraid.net/topic/92865-support-ich777-amd-vendor-reset-coraltpu-hpsahba/

## What This Plugin Does

This Unraid plugin adds comprehensive LED control functionality to UGREEN NAS devices, transforming your NAS into a visual monitoring system. It provides:

- **Disk Activity Monitoring**: Individual hard drive activity indicators with LED flashing
- **Network Status Monitoring**: Real-time network connectivity and speed visualization
- **System Health Monitoring**: Disk health and availability status indicators
- **Hardware Compatibility**: Support for multiple UGREEN NAS models

## Supported UGREEN Models

The driver supports these UGREEN NAS models:
- **DXP6800** series (tested on DXP6800 Pro)
- **DX4600** series (tested on DX4600 Pro)
- **DX4700** series
- **DXP2800** series
- **DXP4800** series
- **DXP8800** series (tested on DXP8800 Plus)
- **DXP480T** series (tested on DXP480T Plus) - uses static white LED only

## LED Color Meanings

### Disk LED Colors

| Color | RGB Values | Meaning |
|-------|------------|---------|
| **White** | `255 255 255` | **Healthy disk** - Normal operation (solid) |
| **White** | `255 255 255` | **Disk activity** - Brief flash when I/O detected |
| **Red** | `255 0 0` | **Disk unavailable/offline** - Disk has gone offline or is not accessible (solid) |

### Network LED Colors

| Color | RGB Values | Meaning |
|-------|------------|---------|
| **Orange** | `255 165 0` | **Normal network** - Default state when speed is unknown (solid) |
| **Green** | `0 255 0` | **100 Mbps connection** (solid) |
| **Blue** | `0 0 255` | **1 Gbps connection** (solid) |
| **Yellow** | `255 255 0` | **2.5 Gbps connection** (solid) |
| **White** | `255 255 255` | **10 Gbps connection** (solid) |
| **Red** | `255 0 0` | **Gateway unreachable** - Network connectivity issues (solid) |
| **Any Color** | Various | **Network activity** - Flashes on TX/RX activity |

## Monitoring Features

### Disk Monitoring
- **Activity Detection**: LEDs flash briefly (100ms on/off) when disk I/O activity is detected
- **Health Monitoring**: Continuously checks if disks are online every 5 seconds (configurable)
- **Status Indicators**: Solid white = healthy disk, solid red = disk offline/unavailable
- **Slot Mapping**: Maps physical disk slots to LED indicators using ATA, HCTL, or serial number mapping
- **Empty Slot Handling**: LEDs are turned off for disk slots that don't have drives installed

### Network Monitoring
- **Speed Detection**: Automatically detects network interface speed and changes LED color accordingly (solid color)
- **Activity Indicators**: LED flashes on network transmit/receive activity (500ms interval)
- **Gateway Connectivity**: Pings the default gateway every 30 seconds (configurable) to verify connectivity
- **Interface Detection**: Automatically detects the primary network interface from Unraid configuration

### Special Cases
- **DXP480T Model**: Uses a special static white LED configuration instead of dynamic monitoring
- **Model-Specific Mapping**: Different models may use different disk-to-LED mappings (e.g., DXP6800 has custom mapping)

## Configuration Options

The plugin creates a `settings.cfg` file with these configurable parameters. The settings file is stored at: **`/boot/config/plugins/ugreenleds-driver/settings.cfg`**

| Parameter | Default | Description |
|-----------|---------|-------------|
| `MAPPING_METHOD` | `"ata"` | How to map disks to LEDs (ata, hctl, or serial) |
| `DISK_SERIAL` | `"SN1 SN2 SN3 SN4"` | Serial numbers for disk mapping |
| `COLOR_DISK_HEALTH` | `"255 255 255"` | Color for healthy disks (white) |
| `BRIGHTNESS_DISK_LEDS` | `"255"` | LED brightness level |
| `COLOR_DISK_UNAVAIL` | `"255 0 0"` | Color for unavailable disks (red) |
| `LED_REFRESH_INTERVAL` | `"0.5"` | How often to check for disk activity (seconds) |
| `CHECK_DISK_ONLINE_INTERVAL` | `"5"` | How often to check disk online status (seconds) |
| `CHECK_GATEWAY_CONNECTIVITY` | `"true"` | Whether to monitor network connectivity |
| `COLOR_NETDEV_NORMAL` | `"255 165 0"` | Color for normal network (orange) |
| `COLOR_NETDEV_LINK_100` | `"0 255 0"` | Color for 100 Mbps (green) |
| `COLOR_NETDEV_LINK_1000` | `"0 0 255"` | Color for 1 Gbps (blue) |
| `COLOR_NETDEV_LINK_2500` | `"255 255 0"` | Color for 2.5 Gbps (yellow) |
| `COLOR_NETDEV_LINK_10000` | `"255 255 255"` | Color for 10 Gbps (white) |
| `COLOR_NETDEV_GATEWAY_UNREACHABLE` | `"255 0 0"` | Color for gateway issues (red) |
| `CHECK_NETDEV_INTERVAL` | `"30"` | How often to check network status (seconds) |

## Installation

1. Install the plugin through the Unraid Community Applications or manually
2. The plugin will automatically detect your UGREEN NAS model
3. Configuration file will be created at `/boot/config/plugins/ugreenleds-driver/settings.cfg`
4. LEDs will start working immediately after installation

## Troubleshooting

- **LEDs not working**: Check if your model is supported and ensure the kernel module loaded correctly
- **Wrong disk mapping**: Adjust the `MAPPING_METHOD` in settings.cfg
- **Network LED issues**: Verify network interface detection and gateway connectivity
- **Performance issues**: Adjust refresh intervals in the configuration file

## Credits

Based on the excellent work by [miskcoo](https://github.com/miskcoo/ugreen_dx4600_leds_controller) for the original UGREEN LED controller implementation.