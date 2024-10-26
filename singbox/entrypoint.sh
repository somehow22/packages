#!/bin/bash

# Attempt to load the kernel module
echo "Attempting to load the kernel module..."
if modprobe brutal; then
    echo "Successfully loaded brutal kernel module"
else
    echo "Failed to load brutal kernel module. Continuing without it."
fi

# Execute sing-box with the provided arguments
exec sing-box "$@"
