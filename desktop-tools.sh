#!/bin/bash

# Exit script on error
set -e

# Detect OS
OS=$(uname)
INSTALL_ELECTRON=false
CLONE_REPO=false
GIT_REPO="https://github.com/A-Star100/simpliplay-desktop.git"

# Function to confirm installation
confirm_install() {
    read -p "Do you want to install $1? (y/n): " choice
    case "$choice" in 
      y|Y ) return 0 ;;
      * ) return 1 ;;
    esac
}

# Parse command-line arguments
if [[ "$#" -eq 0 ]]; then
    echo "No flags provided. Asking for confirmation..."
    confirm_install "Electron" && INSTALL_ELECTRON=true
    confirm_install "Clone repository" && CLONE_REPO=true
else
    for arg in "$@"; do
        case "$arg" in
            --electron) INSTALL_ELECTRON=true ;;
            --repo) CLONE_REPO=true ;;
            --all) INSTALL_ELECTRON=true; CLONE_REPO=true ;;
            *) echo "Unknown option: $arg"; exit 1 ;;
        esac
    done
fi

# Install Git if not installed
install_git() {
    if ! command -v git &> /dev/null; then
        echo "Git not found. Installing..."
        if [[ "$OS" == "Linux" ]]; then
            sudo apt update && sudo apt install -y git
        elif [[ "$OS" == "Darwin" ]]; then
            brew install git
        else
            echo "Unsupported OS: $OS"
            exit 1
        fi
    else
        echo "✅ Git is already installed."
    fi
}

# Install Homebrew if not installed (only for macOS)
install_homebrew() {
    if [[ "$OS" == "Darwin" ]]; then
        if ! command -v brew &> /dev/null; then
            echo "🍺 Homebrew not found. Installing..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        else
            echo "✅ Homebrew is already installed."
        fi
    fi
}

# Install Node.js & npm if not installed
install_node() {
    if ! command -v node &> /dev/null || ! command -v npm &> /dev/null; then
        echo "📦 Node.js & npm not found. Installing..."
        if [[ "$OS" == "Linux" ]]; then
            sudo apt update && sudo apt install -y nodejs npm
        elif [[ "$OS" == "Darwin" ]]; then
            brew install node
        else
            echo "Unsupported OS: $OS"
            exit 1
        fi
    else
        echo "✅ Node.js & npm are already installed."
    fi
}

# Install Electron globally
install_electron() {
    echo "📥 Installing Electron globally..."
    npm install -g electron
    echo "✅ Electron installed successfully!"
}

# Clone repository
clone_repo() {
    if [[ -d "simpliplay-desktop" ]]; then
        echo "📁 Repository already exists. Skipping cloning."
    else
        git clone "$GIT_REPO"
        echo "✅ Repository cloned successfully!"
    fi
}

# Run installations
install_homebrew
install_git
install_node

if $CLONE_REPO; then
    clone_repo
fi

if $INSTALL_ELECTRON; then
    install_electron
fi

# Final verification
echo "🔍 Verifying installations..."
if $INSTALL_ELECTRON; then electron -v; fi

echo "🎉 Installation process complete!"
