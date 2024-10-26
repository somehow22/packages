#!/bin/bash

# Function to load the kernel module
load_module() {
    if insmod /usr/lib/modules/brutal.ko; then
        echo "Successfully loaded brutal kernel module"
    else
        echo "Failed to load brutal kernel module. Continuing without it."
    fi
}

# Check if we need to load the kernel module
if [ "$LOAD_KERNEL_MODULE" = "true" ]; then
    load_module
fi

# Execute sing-box with the provided arguments
exec sing-box "$@"
