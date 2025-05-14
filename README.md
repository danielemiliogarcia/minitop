# MINITOP
lightweight real-time system monitor in Bash

minitop is a simple system monitoring tool written in Bash. It displays:

- Top CPU-consuming processes
- Process and thread counts
- Load averages and system uptime
- Memory usage summary
- Network traffic (RX/TX)
- Disk usage per mount point

![image](https://github.com/user-attachments/assets/7ad97b0c-a766-415a-9411-ca2ca885fabf)


## One liner install from release files
```bash
curl -L -o /tmp/minitop.deb https://github.com/danielemiliogarcia/minitop/releases/download/v1.0/minitop_1.0.deb && sudo apt install -y /tmp/minitop.deb && rm /tmp/minitop.deb
```

## Install from sources

### Clone this repo

### Build
```bash
./build-deb.sh
```

### Install
``` bash
sudo apt install ./minitop_1.0.deb
```

## Customizations
Customize editing minitop-core.sh

