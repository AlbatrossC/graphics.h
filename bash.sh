#!/bin/bash
set -e  # Exit immediately if a command exits with a non-zero status.

# Update the Packages
sudo apt update && sudo apt upgrade -y

# Install necessary packages
sudo apt install -y curl wget vim git nano unzip tar

# Install Essential Library
sudo apt install -y build-essential

# Install Required Packages
sudo apt-get install -y libsdl-image1.2 libsdl-image1.2-dev guile-2.0 \
guile-2.0-dev libsdl1.2debian libart-2.0-dev libaudiofile-dev \
libdirectfb-dev libdirectfb-extra libfreetype6-dev \
libxext-dev x11proto-xext-dev libfreetype6 libaa1 libaa1-dev \
libslang2-dev libasound2 libasound2-dev

# Add repositories for libesd0-dev
echo "deb http://us.archive.ubuntu.com/ubuntu/ xenial main universe" | sudo tee -a /etc/apt/sources.list
echo "deb-src http://us.archive.ubuntu.com/ubuntu/ xenial main universe" | sudo tee -a /etc/apt/sources.list

# Update the package list again
sudo apt update

# Step 1: Download the file
wget http://download.savannah.gnu.org/releases/libgraph/libgraph-1.0.2.tar.gz

# Step 2: Extract the tar.gz file
tar -xzf libgraph-1.0.2.tar.gz

# Step 3: Change into the extracted directory
cd libgraph-1.0.2

# Configure and compile
CPPFLAGS="$CPPFLAGS $(pkg-config --cflags-only-I guile-2.0)" \
  CFLAGS="$CFLAGS $(pkg-config --cflags-only-other guile-2.0)" \
  LDFLAGS="$LDFLAGS $(pkg-config --libs guile-2.0)" \
  ./configure

sudo make
sudo make install
sudo cp /usr/local/lib/libgraph.* /usr/lib

# Change to the original Directory
cd ..

# For conio.h
git clone https://github.com/zoelabbb/conio.h.git

# Change directory to conio.h
cd conio.h

# Install conio.h
sudo make install

# Change to the original directory
cd ..



echo "All commands executed successfully."
