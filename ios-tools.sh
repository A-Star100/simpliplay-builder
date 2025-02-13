#!/bin/bash

# Exit script on error
set -e

# Detect OS
OS=$(uname)
INSTALL_XCODE=false
CLONE_REPO=false
GIT_REPO="https://github.com/A-Star100/simpliplay-ios.git"

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
    confirm_install "Xcode" && INSTALL_XCODE=true
    confirm_install "Clone repository" && CLONE_REPO=true
else
    for arg in "$@"; do
        case "$arg" in
            --xcode) INSTALL_XCODE=true ;;
            --repo) CLONE_REPO=true ;;
            --all) INSTALL_XCODE=true; CLONE_REPO=true ;;
            *) echo "Unknown option: $arg"; exit 1 ;;
        esac
    done
fi

# Ensure script is running on macOS
if [[ "$OS" != "Darwin" ]]; then
    echo "❌ The IDE required to compile/properly edit iOS apps (XCode) isn't compatible with this OS. Installation failed."
    exit 1
fi

# Function to install Homebrew if not installed
install_homebrew() {
    if ! command -v brew &> /dev/null; then
        echo "🍺 Homebrew not found. Installing..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        echo "✅ Homebrew is already installed."
    fi
}

# Function to install Git if not installed
install_git() {
    if ! command -v git &> /dev/null; then
        echo "🔧 Git not found. Installing..."
        brew install git
    else
        echo "✅ Git is already installed."
    fi
}

# Function to install Xcode
install_xcode() {
    echo "📥 Installing Xcode..."
    
    # Check if Xcode is already installed
    if xcode-select -p &> /dev/null; then
        echo "✅ Xcode is already installed."
    else
        echo "📲 Opening the Mac App Store to download Xcode..."
        open "macappstore://apps.apple.com/app/xcode/id497799835"
        echo "⚠️ Please install Xcode manually from the Mac App Store."
        exit 1
    fi
    
    # Accept the Xcode license agreement
    sudo xcodebuild -license accept
    
    # Install additional tools
    sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
    sudo xcodebuild -runFirstLaunch

    echo "✅ Xcode installed successfully!"
}

# Function to clone repository
clone_repo() {
    if [[ -d "simpliplay-ios" ]]; then
        echo "📁 Repository already exists. Skipping cloning."
    else
        git clone "$GIT_REPO"
        echo "✅ Repository cloned successfully!"
    fi
}

# Run installations
install_homebrew
install_git

if $INSTALL_XCODE; then
    install_xcode
fi

if $CLONE_REPO; then
    clone_repo
fi

echo "🎉 Installation process complete!"
