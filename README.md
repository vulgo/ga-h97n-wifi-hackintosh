# H97N-WIFI Hackintosh

OpenCore configuration for running macOS on the Gigabyte GA-H97N-WIFI motherboard.

## Firmware Settings

#### BIOS Features

| Field              | Value             |
|:-------------------|------------------:|
| Fast Boot          | Disabled          |
| VT-d               | Enabled           |
| Windows 8 Features | Windows 8 WHQL    |
| CSM Support        | Never             |
| Secure Boot        | Disabled          |

#### Peripherals

| Field                                        | Value    |
|:---------------------------------------------|---------:|
| XHCI Mode                                    | Enabled  |
| Intel Processor Graphics                     | Enabled  |
| Intel Processor Graphics Memory Allocation   | 64M      |
| DVMT Total Memory Size                       | MAX      |
| Legacy USB Support                           | Disabled |
| XHCI Handoff                                 | Enabled  |
| Super IO Configuration &#8594; Serial Port A | Disabled |

Source: [dortania.github.io/OpenCore-Install-Guide/config.plist/haswell.html#intel-bios-settings](https://dortania.github.io/OpenCore-Install-Guide/config.plist/haswell.html#intel-bios-settings)

## Graphics

The default configuration targets discrete AMD graphics + Haswell iGPU using a connectorless framebuffer.

> If your system is AMD + Haswell connectorless then graphics-related changes to the default ```config.plist``` may not be required

In all other cases, refer to [README-Intel-Graphics.md](/README-Intel-Graphics.md)

## SMBIOS

Edit the ```PlatformInfo``` section of your ```config.plist``` so that the ```MLB```, ```ROM```, ```SystemSerialNumber``` and ```SystemUUID``` values are unique to your machine.

```xml
...
<key>PlatformInfo</key>
<dict>
    ...
    <key>Generic</key>
    <dict>
        ...
        <key>MLB</key>
        <string>M0000000000000001</string>
        ...
        <key>ROM</key>
        <data>ESIzRFVm</data>
        ...
        <key>SystemSerialNumber</key>
        <string>W00000000001</string>
        <key>SystemUUID</key>
        <string>00000000-0000-0000-0000-000000000000</string>
    </dict>
    ...
</dict>
...
````

| PlatformInfo &#8594; Generic | Source                    |
|:-----------------------------|--------------------------:|
| MLB                          | \**Board Serial*          |
| ROM                          | \**Apple ROM*             |
| SystemSerialNumber           | \**Serial*                |
| SystemUUID                   | \**SmUUID*                |

\* *GenSMBIOS output, iMac18,2 (or iMac18,1 using iGPU)*

Source: [dortania.github.io/OpenCore-Install-Guide/config.plist/haswell.html#platforminfo](https://dortania.github.io/OpenCore-Install-Guide/config.plist/haswell.html#platforminfo)

GenSMBIOS: [github.com/corpnewt/GenSMBIOS](https://github.com/corpnewt/GenSMBIOS)

## Reset NVRAM

At the picker, **press space**, choose ```Reset NVRAM```.

Reset NVRAM at first boot and **whenever the bootloader files have changed**.

## USB

Generate a valid ```USBPorts.kext```. See [README-usbtool.command.md](/README-usbtool.command.md)

## Post-Install

[dortania.github.io/OpenCore-Post-Install/](https://dortania.github.io/OpenCore-Post-Install/)
