#!/bin/bash

# Attempt to load the kernel module if it exists
if [ -f "/lib/modules/$(uname -r)/brutal.ko" ]; then
    echo "Loading brutal kernel module..."
    if modprobe brutal; then
        echo "Successfully loaded brutal kernel module"
    else
        echo "Failed to load brutal kernel module. Continuing without it."
    fi
else
    echo "Brutal kernel module not found. Continuing without it."
fi

# Execute sing-box with the provided arguments
exec sing-box "$@"
