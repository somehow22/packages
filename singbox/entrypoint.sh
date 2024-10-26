#!/bin/bash

# Attempt to build the kernel module
echo "Attempting to build the kernel module..."
/usr/local/bin/build_kernel_module.sh || echo "Failed to build kernel module. Continuing without it."

# Execute sing-box with the provided arguments
exec sing-box "$@"
