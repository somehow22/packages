#!/bin/bash

# Check if we need to build and load the kernel module
if [ "$BUILD_KERNEL_MODULE" = "true" ] && [ ! -f "/lib/modules/$(uname -r)/brutal.ko" ]; then
    echo "Attempting to build and load the kernel module..."
    if /usr/local/bin/build_kernel_module.sh; then
        echo "Successfully built and loaded brutal kernel module"
    else
        echo "Failed to build and load brutal kernel module. Continuing without it."
    fi
else
    echo "Skipping kernel module build and load."
fi

# Execute sing-box with the provided arguments
exec sing-box "$@"
