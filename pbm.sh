#!/bin/zsh

# Fetch installed PHP versions dynamically
INSTALLED_VERSIONS=($(brew list | grep '^php@' | grep -oE '[0-9]+\.[0-9]+' | sort -V))

# Ensure Homebrew is available
if ! command -v brew &>/dev/null; then
    echo "❌ Homebrew is not installed. Please install Homebrew first."
    exit 1
fi

# Function to list installed versions
list_php_versions() {
    if [[ ${#INSTALLED_VERSIONS[@]} -eq 0 ]]; then
        echo "No PHP versions are installed via Homebrew."
    else
        echo "Installed PHP versions: ${INSTALLED_VERSIONS[*]}"
    fi
}

# Function to install a PHP version
install_php_version() {
    local VERSION=$1
    local PHP_FORMULA="php@$VERSION"

    if brew list "$PHP_FORMULA" &>/dev/null; then
        echo "✅ PHP $VERSION is already installed."
    else
        echo "Installing PHP $VERSION..."
        brew install "$PHP_FORMULA" || { echo "❌ Installation failed."; exit 1; }
        INSTALLED_VERSIONS+=("$VERSION")  # Update list dynamically
    fi
}

# Function to uninstall a PHP version
uninstall_php_version() {
    local VERSION=$1
    local PHP_FORMULA="php@$VERSION"

    if brew list "$PHP_FORMULA" &>/dev/null; then
        echo "Uninstalling PHP $VERSION..."
        brew uninstall "$PHP_FORMULA" || { echo "❌ Uninstallation failed."; exit 1; }
        INSTALLED_VERSIONS=($(brew list | grep '^php@' | grep -oE '[0-9]+\.[0-9]+' | sort -V))
    else
        echo "❌ PHP $VERSION is not installed."
    fi
}

# Function to switch PHP version
switch_php_version() {
    local VERSION=$1
    local PHP_FORMULA="php@$VERSION"

    if ! brew list "$PHP_FORMULA" &>/dev/null; then
        echo "❌ PHP $VERSION is not installed. Use 'pbm --install $VERSION' first."
        exit 1
    fi

    echo "Switching to PHP $VERSION..."
    brew unlink php &>/dev/null
    brew link --force --overwrite "$PHP_FORMULA"

    echo "✅ Switched to PHP $(php -r 'echo PHP_VERSION;')"
}

# Function to temporarily switch PHP version (session-only)
temporary_php_version() {
    local VERSION=$1
    local PHP_PATH="/home/linuxbrew/.linuxbrew/opt/php@$VERSION/bin/php"

    if [[ -x "$PHP_PATH" ]]; then
        export PATH="/home/linuxbrew/.linuxbrew/opt/php@$VERSION/bin:$PATH"
        echo "✅ Using PHP $VERSION temporarily (session-only)."
    else
        echo "❌ PHP $VERSION is not installed."
        exit 1
    fi
}

# Function to permanently switch PHP version
permanent_php_version() {
    local VERSION=$1
    local PHP_FORMULA="php@$VERSION"

    if ! brew list "$PHP_FORMULA" &>/dev/null; then
        echo "❌ PHP $VERSION is not installed."
        exit 1
    fi

    echo "Switching to PHP $VERSION permanently..."
    brew unlink php &>/dev/null
    brew link --force --overwrite "$PHP_FORMULA"

    # Update shell config for permanent change
    SHELL_CONFIG="$HOME/.zshrc"  # Change to .bashrc if using Bash
    echo "export PATH=\"/home/linuxbrew/.linuxbrew/opt/php@$VERSION/bin:\$PATH\"" >> "$SHELL_CONFIG"
    echo "✅ PHP $VERSION set as the default (restart your shell to apply)."
}

# Function to display help
display_help() {
    echo "PHP Brew Manager (pbm) - Manage PHP versions with Homebrew"
    echo ""
    echo "Usage:"
    echo "  pbm --list                 List installed PHP versions"
    echo "  pbm --install <version>    Install a PHP version"
    echo "  pbm --uninstall <version>  Uninstall a PHP version"
    echo "  pbm use <version>          Switch to a PHP version"
    echo "  pbm use <version> --temporary  Use PHP for this session only"
    echo "  pbm use <version> --permanent  Set PHP as default across reboots"
    echo "  pbm --help                 Show this help menu"
}

# Handle arguments
case "$1" in
    --list)
        list_php_versions
        ;;
    --install)
        [[ -z "$2" ]] && { echo "Usage: pbm --install <version>"; exit 1; }
        install_php_version "$2"
        ;;
    --uninstall)
        [[ -z "$2" ]] && { echo "Usage: pbm --uninstall <version>"; exit 1; }
        uninstall_php_version "$2"
        ;;
    use)
        [[ -z "$2" ]] && { echo "Usage: pbm use <version> [--temporary|--permanent]"; exit 1; }
        if [[ "$3" == "--temporary" ]]; then
            temporary_php_version "$2"
        elif [[ "$3" == "--permanent" ]]; then
            permanent_php_version "$2"
        else
            switch_php_version "$2"
        fi
        ;;
    --help)
        display_help
        ;;
    *)
        echo "Invalid command. Use 'pbm --help' for a list of commands."
        exit 1
        ;;
esac
