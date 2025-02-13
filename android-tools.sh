#!/bin/bash

# Exit script on error
set -e

# Detect OS
OS=$(uname)
INSTALL_FLUTTER=false
INSTALL_ANDROID_STUDIO=false
CLONE_REPO=false
GIT_REPO="https://github.com/A-Star100/simpliplay-android.git"

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
    confirm_install "Android Studio" && INSTALL_ANDROID_STUDIO=true
    confirm_install "Flutter" && INSTALL_FLUTTER=true
    confirm_install "Clone repository" && CLONE_REPO=true
else
    for arg in "$@"; do
        case "$arg" in
            --flutter) INSTALL_FLUTTER=true ;;
            --androidstudio) INSTALL_ANDROID_STUDIO=true ;;
            --repo) CLONE_REPO=true ;;
            --all) INSTALL_FLUTTER=true; INSTALL_ANDROID_STUDIO=true; CLONE_REPO=true ;;
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

# Function to install Homebrew if not installed (only for macOS)
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

# Function to install Android Studio
install_android_studio() {
    echo "📥 Installing Android Studio..."
    if [[ "$OS" == "Linux" ]]; then
        sudo apt update && sudo apt install -y wget unzip curl
        AS_URL=$(curl -s https://developer.android.com/studio | grep -oE 'https://redirector.gvt1.com/edgedl/android/studio/ide-zips/[^"]+linux.tar.gz' | head -1)
        wget -O android-studio.tar.gz "$AS_URL"
        sudo tar -xvf android-studio.tar.gz -C /opt/
        rm android-studio.tar.gz
        sudo ln -s /opt/android-studio/bin/studio.sh /usr/local/bin/android-studio
    elif [[ "$OS" == "Darwin" ]]; then
        brew install --cask android-studio
    else
        echo "Unsupported OS: $OS"
        exit 1
    fi
    echo "✅ Android Studio installed successfully!"
}

# Function to install Flutter
install_flutter() {
    echo "📥 Installing Flutter..."
    if [[ "$OS" == "Linux" ]]; then
        FLUTTER_URL=$(curl -s https://docs.flutter.dev/release/archives | grep -oE 'https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_[^"]+tar.xz' | head -1)
        wget -O flutter.tar.xz "$FLUTTER_URL"
        sudo tar -xvf flutter.tar.xz -C /opt/
        rm flutter.tar.xz
        echo 'export PATH="$PATH:/opt/flutter/bin"' >> ~/.bashrc
        source ~/.bashrc
    elif [[ "$OS" == "Darwin" ]]; then
        brew install --cask flutter
    else
        echo "Unsupported OS: $OS"
        exit 1
    fi
    echo "✅ Flutter installed successfully!"
}

# Clone repository
clone_repo() {
    if [[ -d "simpliplay-android" ]]; then
        echo "📁 Repository already exists. Skipping cloning."
    else
        git clone "$GIT_REPO"
        echo "✅ Repository cloned successfully!"
    fi
}

# Run installations
install_homebrew
install_git

if $CLONE_REPO; then
    clone_repo
fi

if $INSTALL_ANDROID_STUDIO; then
    install_android_studio
fi

if $INSTALL_FLUTTER; then
    install_flutter
fi

# Final verification
echo "🔍 Verifying installations..."
if $INSTALL_ANDROID_STUDIO; then android-studio --version || echo "✅ Android Studio installed"; fi
if $INSTALL_FLUTTER; then flutter --version; fi

echo "🎉 Installation process complete!"
