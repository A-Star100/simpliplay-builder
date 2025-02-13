#!/bin/bash

# Exit script on error
set -e

# Flags to control installations
INSTALL_ANDROID=false
INSTALL_IOS=false
INSTALL_DESKTOP=false

# Check for flags
if [[ "$#" -eq 0 ]]; then
    echo "No flags provided. Asking for confirmation..."
    read -p "Do you want to install Android components? (y/n): " choice
    [[ "$choice" =~ ^[Yy]$ ]] && INSTALL_ANDROID=true

    read -p "Do you want to install iOS components? (y/n): " choice
    [[ "$choice" =~ ^[Yy]$ ]] && INSTALL_IOS=true

    read -p "Do you want to install Desktop components? (y/n): " choice
    [[ "$choice" =~ ^[Yy]$ ]] && INSTALL_DESKTOP=true
else
    for arg in "$@"; do
        case "$arg" in
            --android) INSTALL_ANDROID=true ;;
            --ios) INSTALL_IOS=true ;;
            --desktop) INSTALL_DESKTOP=true ;;
            --all) INSTALL_ANDROID=true; INSTALL_IOS=true; INSTALL_DESKTOP=true ;;
            *) echo "Unknown option: $arg"; exit 1 ;;
        esac
    done
fi

# Function to run a script if it exists
run_script() {
    if [[ -f "$1" ]]; then
        echo "🔹 Running $1..."
        chmod +x "$1"  # Ensure it's executable
        ./"$1" --all
    else
        echo "⚠️  Script $1 not found. Skipping."
    fi
}

# Execute selected installations
if $INSTALL_ANDROID; then run_script "android-tools.sh"; fi
if $INSTALL_IOS; then run_script "ios-tools.sh"; fi
if $INSTALL_DESKTOP; then run_script "desktop-tools.sh"; fi

echo "🎉 All installations complete!"
