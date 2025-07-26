#!/bin/bash
# clean.sh - Reset Buildroot environment by running 'make distclean'
# This removes all build output, configuration files, and downloaded sources.

set -e  # Exit immediately if a command exits with a non-zero status.

# Navigate to the buildroot directory
cd buildroot

# Run Buildroot's distclean target
echo "Running 'make distclean' in $(pwd)..."
make distclean

echo "Buildroot environment cleaned successfully."
