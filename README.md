# OpenFreezeCenter (OFC)
A Linux fan control application for MSI laptops, providing temperature monitoring and fan curve control.

Made by PranavVerma-droid

## Features
- GUI-based fan control
- Temperature and RPM monitoring
- Battery charging threshold control
- Automatic, Basic, Advanced and Cooler Boost profiles
- EC (Embedded Controller) read/write support

## Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/PranavVerma-droid/OFC-Improved.git
   cd OFC-Improved
   ```

2. Make the install script executable:
   ```bash
   chmod +x install.sh
   ```

3. Run the installation script (this will also launch the app):
   ```bash
   ./install.sh
   ```
   The Application will generate an [config.py](default_config.py) file on the first run.

4. Reboot your system after first installation (recommended):
   ```bash
   sudo reboot
   ```

## Running the Application
After installation, simply run:
```bash
./install.sh
```

The application will start in a virtual environment automatically.

## Supported Hardware
Laptop Models (Tested):
- MSI GP76 11UG
- MSI GF73 11UC

Linux Distributions (Tested):
- Ubuntu (and derivatives)
- Linux Mint

## Goals
<input checked="" disabled="" type="checkbox"> Fan Control GUI <br>
<input checked="" disabled="" type="checkbox"> Basic temperature and RPM monitoring <br>
<input disabled="" type="checkbox"> Advanced & Basic GUI control <br>
<input checked="" disabled="" type="checkbox"> Battery Threshold <br>
<input disabled="" type="checkbox"> Webcam control <br>