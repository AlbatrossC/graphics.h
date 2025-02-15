#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status.

echo -e "\e[34m[ℹ] Starting installation process...\e[0m"

# Update and upgrade packages
echo -e "\e[34m[ℹ] Updating and upgrading packages...\e[0m"
sudo apt update && sudo apt upgrade -y
echo -e "\e[32m[✔] Packages updated and upgraded successfully!\e[0m"

# Install essential development tools
echo -e "\e[34m[ℹ] Installing essential development tools...\e[0m"
sudo apt install -y tar build-essential nano wget
echo -e "\e[32m[✔] Development tools installed successfully!\e[0m"

# Install required libraries
echo -e "\e[34m[ℹ] Installing required libraries...\e[0m"
sudo apt install -y libsdl-image1.2 libsdl-image1.2-dev guile-2.0 guile-2.0-dev \
    libsdl1.2debian libart-2.0-dev libaudiofile-dev libdirectfb-dev \
    libdirectfb-extra libfreetype6-dev libxext-dev x11proto-xext-dev \
    libfreetype6 libaa1 libaa1-dev libslang2-dev libasound2 libasound2-dev
echo -e "\e[32m[✔] Required libraries installed successfully!\e[0m"

# Extract and install libgraph
echo -e "\e[34m[ℹ] Checking for libgraph-1.0.2.tar.gz...\e[0m"
if [ -f "$PWD/libgraph-1.0.2.tar.gz" ]; then
    echo -e "\e[34m[ℹ] Extracting libgraph-1.0.2...\e[0m"
    tar -xzf libgraph-1.0.2.tar.gz
    cd libgraph-1.0.2

    echo -e "\e[34m[ℹ] Configuring libgraph...\e[0m"
    CPPFLAGS="$(pkg-config --cflags-only-I guile-2.0)" \
    CFLAGS="$(pkg-config --cflags-only-other guile-2.0)" \
    LDFLAGS="$(pkg-config --libs guile-2.0)" \
    ./configure

    echo -e "\e[34m[ℹ] Compiling libgraph...\e[0m"
    sudo make -j$(nproc)

    echo -e "\e[34m[ℹ] Installing libgraph...\e[0m"
    sudo make install
    sudo cp /usr/local/lib/libgraph.* /usr/lib
    cd ..

    echo -e "\e[32m[✔] libgraph installed successfully!\e[0m"
else
    echo -e "\e[31m[✖] libgraph-1.0.2.tar.gz not found. Skipping libgraph installation.\e[0m"
fi

# Install conio.h from for_conio directory
echo -e "\e[34m[ℹ] Checking for for_conio directory...\e[0m"
if [ -d "$PWD/for_conio" ]; then
    echo -e "\e[34m[ℹ] Moving to for_conio directory...\e[0m"
    cd for_conio

    echo -e "\e[34m[ℹ] Installing conio.h...\e[0m"
    if sudo make install; then
        echo -e "\e[32m[✔] conio.h installed successfully!\e[0m"
    else
        echo -e "\e[31m[✖] Error installing conio.h. Please check the make output above.\e[0m"
    fi

    echo -e "\e[34m[ℹ] Returning to home directory...\e[0m"
    cd ..
else
    echo -e "\e[31m[✖] for_conio directory not found. Skipping conio.h installation.\e[0m"
fi

# Cleanup process
echo -e "\e[34m[ℹ] Cleaning up unnecessary files...\e[0m"
rm -rf .github Readme.md index.html 2>/dev/null
echo -e "\e[32m[✔] Removed unnecessary files.\e[0m"

# Completion message
echo -e "\e[32m[✔] Installation completed successfully!\e[0m"