## Intel Graphics

### Device Properties

#### Haswell

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
