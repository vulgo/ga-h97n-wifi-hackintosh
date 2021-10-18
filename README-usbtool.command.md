## usbtool.command

This needs to be written

### Port Physical Locations

#### USB 2

| Port | Location                   |
|:-----|:---------------------------|
| HS01 | USB 3 Header               |
| HS02 | USB 3 Header               |
| HS03 | Rear Panel USB 3 Connector |
| HS04 | Rear Panel USB 3 Connector |
| HS05 | USB 2 Header               |
| HS06 | USB 2 Header               |
| HS07 | Rear Panel USB 2 Connector |
| HS08 | Rear Panel USB 2 Connector |
| HS09 | Rear Panel USB 3 Connector |
| HS10 | Rear Panel USB 3 Connector |
| HS11 | Mini PCI Express           |

#### USB 3

| Port | Location                   |
|:-----|:---------------------------|
| SS01 | USB 3 Header               |
| SS02 | USB 3 Header               |
| SS03 | Rear Panel USB 3 Connector |
| SS04 | Rear Panel USB 3 Connector |
| SS05 | Rear Panel USB 3 Connector |
| SS06 | Rear Panel USB 3 Connector |

### Back Panel USB Layout

by [grumat](https://github.com/grumat)

```
 -------------------------------------------------------------------------
|  ------                                 __--__    __--__     ..     ..  |
| | HS07 |    .-.     .-.                | LAN2 |  | LAN1 |   (Or)   (LI) |
| |======|   (SMA)   (SMA)               | .... |  | .... |    ˜˜     ˜˜  |
| | HS08 |    ˜-˜     ˜-˜     ________    ======    ======     ..     ..  |
|  ------                     \=HDMI=/    ------    ------    (Bk)   (LO) |
|    --     ---------------     ˜˜˜˜     | SS04 |  | SS06 |    ˜˜     ˜˜  |
|  / PS \  | ######### ### |  ________   |======|  |======|  |˜˜˜˜|   ..  |
|  \ /2 /  | ######### ### |  \=HDMI=/   | SS03 |  | SS05 |  |TosL|  (Mi) |
|    --     \-------------/     ˜˜˜˜      ------    ------    ----    ˜˜  |
 -------------------------------------------------------------------------
 ```
