# Intel Graphics

Source: [github.com/acidanthera/WhateverGreen](https://github.com/acidanthera/WhateverGreen)

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
        <string>iMac18,1</string>
        ...
    </dict>
    ...
</dict>
...
````

| SystemProductName | Graphics Configuration | Intel Framebuffer |
|:------------------|:-----------------------|:------------------|
| iMac18,1          | Haswell HD Graphics    | Attached display  |
| iMac16,2          | Broadwell Iris Pro     | Attached display  |
| iMac18,2          | PCIe graphics card     | Connectorless     |

## Haswell HD Graphics Device Properties

Edit the `DeviceProperties` section of your `config.plist` according to your configuration.

### Attached Display

> Haswell attached display configurations use the `iMac18,1` model identifier.

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
            <data>AwAiDQ==</data>
            <key>framebuffer-patch-enable</key>
            <data>AQAAAA==</data>
            <key>framebuffer-con1-enable</key>
            <data>AQAAAA==</data>
            <key>framebuffer-con1-type</key>
            <data>AAgAAA==</data>
            <key>framebuffer-con2-enable</key>
            <data>AQAAAA==</data>
            <key>framebuffer-con2-type</key>
            <data>AAgAAA==</data>
            <key>framebuffer-con2-flags</key>
            <data>hwAAAA==</data>
        </dict>
        ...
    </dict>
</dict>
...
```

### Connectorless

> When a supported PCIe graphics card is installed it is recommended to configure the Haswell iGPU with the connectorless framebuffer.

> Haswell connectorless configurations use the `iMac18,2` model identifier.

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

## Broadwell Iris Pro Device Properties

Edit the `DeviceProperties` section of your `config.plist`.

> Broadwell configurations use the `iMac16,2` model identifier.

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
            <data>BwAiFg==</data>
            <key>framebuffer-patch-enable</key>
            <data>AQAAAA==</data>
            <key>framebuffer-con1-enable</key>
            <data>AQAAAA==</data>
            <key>framebuffer-con1-type</key>
            <data>AAgAAA==</data>
            <key>framebuffer-con2-enable</key>
            <data>AQAAAA==</data>
            <key>framebuffer-con2-type</key>
            <data>AAgAAA==</data>
            <key>framebuffer-con2-flags</key>
            <data>BwUAAA==</data>
        </dict>
        ...
    </dict>
</dict>
...
```
