## Intel Graphics

### Device Properties

#### Haswell

```AAPL,ig-platform-id``` for Haswell systems not using a discrete PCIe graphics card

```xml
...
<key>DeviceProperties</key>
<dict>
    <key>Add</key>
    <dict>
        ...
        <key>PciRoot(0x0)/Pci(0x2,0x0)</key>
        <dict>
            ...
            <key>AAPL,ig-platform-id</key>
            <data>AwAiDQ==</data>
            ...
        </dict>
        ...
    </dict>
</dict>
...
```

#### Broadwell

```AAPL,ig-platform-id``` for Broadwell Iris Pro graphics

```xml
...
<key>DeviceProperties</key>
<dict>
    <key>Add</key>
    <dict>
        ...
        <key>PciRoot(0x0)/Pci(0x2,0x0)</key>
        <dict>
            ...
            <key>AAPL,ig-platform-id</key>
            <data>BwAiFg==</data>
            ...
        </dict>
        ...
    </dict>
</dict>
...
```

#### Common

Connector patches for H97N-WIFI Haswell or Broadwell systems not using a discrete PCIe graphics card

```xml
...
<key>DeviceProperties</key>
<dict>
    <key>Add</key>
    <dict>
        ...
        <key>PciRoot(0x0)/Pci(0x2,0x0)</key>
        <dict>
            ...
            <key>framebuffer-con0-enable</key>
            <data>AQAAAA==</data>
            <key>framebuffer-con0-type</key>
            <data>AAgAAA==</data>
            <key>framebuffer-con1-enable</key>
            <data>AQAAAA==</data>
            <key>framebuffer-con1-type</key>
            <data>AAgAAA==</data>
            <key>framebuffer-con2-enable</key>
            <data>AQAAAA==</data>
            <key>framebuffer-con2-type</key>
            <data>AAgAAA==</data>
            ...
        </dict>
        ...
    </dict>
</dict>
...
```
