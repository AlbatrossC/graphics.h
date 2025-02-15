#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status.

# Update and upgrade packages
sudo apt update && sudo apt upgrade -y

# Install essential development tools
sudo apt install -y curl wget vim git nano unzip tar build-essential

# Install required libraries
sudo apt install -y libsdl-image1.2 libsdl-image1.2-dev guile-2.0 guile-2.0-dev \
    libsdl1.2debian libart-2.0-dev libaudiofile-dev libdirectfb-dev \
    libdirectfb-extra libfreetype6-dev libxext-dev x11proto-xext-dev \
    libfreetype6 libaa1 libaa1-dev libslang2-dev libasound2 libasound2-dev

# Extract and install libgraph (from local file)
if [ -f "$PWD/libgraph-1.0.2.tar.gz" ]; then
    tar -xzf libgraph-1.0.2.tar.gz
    cd libgraph-1.0.2

    CPPFLAGS="$(pkg-config --cflags-only-I guile-2.0)" \
    CFLAGS="$(pkg-config --cflags-only-other guile-2.0)" \
    LDFLAGS="$(pkg-config --libs guile-2.0)" \
    ./configure

    sudo make -j$(nproc)
    sudo make install
    sudo cp /usr/local/lib/libgraph.* /usr/lib

    cd ..
else
    echo -e "\e[31m[✖] libgraph-1.0.2.tar.gz not found. Skipping libgraph installation.\e[0m"
fi

# Install conio.h
CONIO_PATH="$PWD/conio.h"
if [ -f "$CONIO_PATH" ]; then
    echo -e "\e[34m[ℹ] Found conio.h at: $CONIO_PATH\e[0m"
    sudo cp "$CONIO_PATH" /usr/include/
    echo -e "\e[32m[✔] conio.h installed successfully!\e[0m"
else
    echo -e "\e[31m[✖] conio.h not found at $PWD. Skipping installation.\e[0m"
fi

# Completion message
echo -e "\e[32m[✔] Installation Completed Successfully!\e[0m"
