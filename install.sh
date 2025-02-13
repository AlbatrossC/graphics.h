#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status.

TOTAL_STEPS=9
CURRENT_STEP=0

# Function to print steps in green with a checkmark
increment_step() {
    ((CURRENT_STEP++))
    echo -e "\e[32m[✔] Step $CURRENT_STEP/$TOTAL_STEPS Completed\e[0m"
}

# Error handling function
error_exit() {
    echo -e "\e[31m[✖] Error at Step $CURRENT_STEP. Exiting.\e[0m"
    exit 1
}
trap error_exit ERR

# Step 1: Update and upgrade packages
sudo apt update && sudo apt upgrade -y
increment_step

# Step 2: Install essential development tools
sudo apt install -y curl wget vim git nano unzip tar build-essential
increment_step

# Step 3: Install required libraries
sudo apt install -y libsdl-image1.2 libsdl-image1.2-dev guile-2.0 guile-2.0-dev \
    libsdl1.2debian libart-2.0-dev libaudiofile-dev libdirectfb-dev \
    libdirectfb-extra libfreetype6-dev libxext-dev x11proto-xext-dev \
    libfreetype6 libaa1 libaa1-dev libslang2-dev libasound2 libasound2-dev
increment_step

# Step 4: Add repositories for libesd0-dev (if not already present)
if ! grep -q "xenial main universe" /etc/apt/sources.list; then
    echo "deb http://us.archive.ubuntu.com/ubuntu/ xenial main universe" | sudo tee -a /etc/apt/sources.list
    echo "deb-src http://us.archive.ubuntu.com/ubuntu/ xenial main universe" | sudo tee -a /etc/apt/sources.list
    sudo apt update
fi
increment_step

# Step 5: Extract and install libgraph (using local file)
tar -xzf libgraph-1.0.2.tar.gz && cd libgraph-1.0.2
increment_step

# Step 6: Configure and compile libgraph
CPPFLAGS="$CPPFLAGS $(pkg-config --cflags-only-I guile-2.0)" \
    CFLAGS="$CFLAGS $(pkg-config --cflags-only-other guile-2.0)" \
    LDFLAGS="$LDFLAGS $(pkg-config --libs guile-2.0)" \
    ./configure
sudo make -j$(nproc)
sudo make install
sudo cp /usr/local/lib/libgraph.* /usr/lib
cd ..
increment_step

# Step 7: Clean up libgraph source files
rm -rf libgraph-1.0.2
increment_step

# Step 8: Install conio.h from local repo
cd conio.h
sudo make install
cd ..
increment_step

# Step 9: Clean up conio.h source files
rm -rf conio.h
increment_step

# Completion message
echo -e "\e[32m[✔] Installation Completed Successfully!\e[0m"
