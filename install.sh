#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
VENV_DIR="$SCRIPT_DIR/venv"

print_status() {
    echo -e "\e[1;34m----------$1----------\e[0m"
}

write_to_file() {
    local file="$1"
    local content="$2"
    echo "$content" | sudo tee "$file" > /dev/null
}

print_status "Starting OpenFreezeCenter Installation"
print_status "Made by PranavVerma-droid"
echo "Dependencies required:"
echo "1. python3-virtualenv and python3-venv"
echo "2. PyGObject"
echo "3. PyCairo"

print_status "Installing Dependencies"
sudo apt update && sudo apt upgrade -y
sudo apt install -y python3-virtualenv python3-venv libgirepository1.0-dev libcairo2-dev

if [ ! -d "$VENV_DIR" ]; then
    print_status "Creating Virtual Environment"
    python3 -m venv "$VENV_DIR"
    
    print_status "Installing Python Packages"
    "$VENV_DIR/bin/pip3" install --upgrade pip
    "$VENV_DIR/bin/pip3" install PyGObject pycairo
fi

# Setup EC sys configuration
print_status "Setting up EC read/write access"

# Mount debugfs if not already mounted
if ! mountpoint -q /sys/kernel/debug; then
    print_status "Mounting debugfs"
    sudo mount -t debugfs none /sys/kernel/debug
fi

# Load EC module with write support
sudo modprobe ec_sys write_support=1

# Create and write to ec_sys.conf files
if [ ! -f "/etc/modprobe.d/ec_sys.conf" ] || ! grep -q "options ec_sys write_support=1" "/etc/modprobe.d/ec_sys.conf"; then
    print_status "Configuring EC system write support"
    write_to_file "/etc/modprobe.d/ec_sys.conf" "options ec_sys write_support=1"
fi

if [ ! -f "/etc/modules-load.d/ec_sys.conf" ] || ! grep -q "ec_sys" "/etc/modules-load.d/ec_sys.conf"; then
    print_status "Configuring EC system module"
    write_to_file "/etc/modules-load.d/ec_sys.conf" "ec_sys"
fi

# Create config.py if it doesn't exist
if [ ! -f "$SCRIPT_DIR/config.py" ]; then
    print_status "Creating configuration file"
    cat > "$SCRIPT_DIR/config.py" << EOF
PROFILE = 1
AUTO_SPEED = [[0, 40, 48, 56, 64, 72, 80], [0, 48, 56, 64, 72, 79, 86]]
ADV_SPEED = [[0, 40, 48, 56, 64, 72, 80], [0, 48, 56, 64, 72, 79, 86]]
BASIC_OFFSET = 0
CPU = 1
AUTO_ADV_VALUES = [0xd4, 13, 141]
COOLER_BOOSTER_OFF_ON_VALUES = [0x98, 2, 130]
CPU_GPU_FAN_SPEED_ADDRESS = [[0x72, 0x73, 0x74, 0x75, 0x76, 0x77, 0x78], [0x8a, 0x8b, 0x8c, 0x8d, 0x8e, 0x8f, 0x90]]
CPU_GPU_TEMP_ADDRESS = [0x68, 0x80]
CPU_GPU_RPM_ADDRESS = [0xc8, 0xca]
BATTERY_THRESHOLD_VALUE = 100
EOF
fi

print_status "EC read/write setup completed"
print_status "A system reboot is recommended for changes to take effect"

# Make the main script executable
chmod +x "$SCRIPT_DIR/OFC.py"

# Run the application
if [ -f "$SCRIPT_DIR/OFC.py" ]; then
    print_status "Starting OpenFreezeCenter"
    sudo "$VENV_DIR/bin/python3" "$SCRIPT_DIR/OFC.py"
else
    print_status "Error: OFC.py not found"
    exit 1
fi
