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

Edit the ```DeviceProperties``` section of your ```config.plist``` so that the value for ```AAPL,ig-platform-id``` matches your configuration.

```xml
...
<key>DeviceProperties</key>
<dict>
    <key>Add</key>
    <dict>
        ...
        <key>PciRoot(0x0)/Pci(0x2,0x0)</key>
        <dict>
            <key>AAPL,ig-platform-id</key>
            <data>BAASBA==</data>
        </dict>
        ...
    </dict>
</dict>
...
```

| AAPL,ig-platform-id | Base64   | IGPU Configuration                         |
|:--------------------|:---------|:-------------------------------------------|
| 0300220D            | AwAiDQ== | Haswell attached display                   |
| 04001204            | BAASBA== | Haswell connectorless (using PCIe AMD GPU) |
| 07002216            | BwAiFg== | Broadwell                                  |

See also [README-Intel-Graphics.md](https://github.com/vulgo/ga-h97n-wifi-hackintosh/blob/main/README-Intel-Graphics.md).

Source: [dortania.github.io/OpenCore-Install-Guide/config.plist/haswell.html#deviceproperties](https://dortania.github.io/OpenCore-Install-Guide/config.plist/haswell.html#deviceproperties)

## Model Identifier

Edit the ```PlatformInfo``` section of your ```config.plist``` so that the ```SystemProductName``` matches your graphics configuration.

```xml
...
<key>PlatformInfo</key>
<dict>
    ...
    <key>Generic</key>
    <dict>
        ...
        <key>SystemProductName</key>
        <string>iMac18,2</string>
        ...
    </dict>
    ...
</dict>
...
````

| SystemProductName | Graphics Configuration |
|:------------------|:-----------------------|
| iMac18,1          | Intel Graphics         |
| iMac18,2          | PCI Express Graphics   |

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

\* *GenSMBIOS output, iMac18,1 or iMac18,2*

Source: [dortania.github.io/OpenCore-Install-Guide/config.plist/haswell.html#platforminfo](https://dortania.github.io/OpenCore-Install-Guide/config.plist/haswell.html#platforminfo)

GenSMBIOS: [github.com/corpnewt/GenSMBIOS](https://github.com/corpnewt/GenSMBIOS)

## USB

Generate a valid ```USBPorts.kext```. See [README-usbtool.command.md](https://github.com/vulgo/ga-h97n-wifi-hackintosh/blob/main/README-usbtool.command.md)

## Reset NVRAM

At the picker, **press space**, choose ```Reset NVRAM```.

Reset NVRAM at first boot and **whenever the bootloader files have changed**.

## Post-Install

[dortania.github.io/OpenCore-Post-Install/](https://dortania.github.io/OpenCore-Post-Install/)
