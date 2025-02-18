# pbm - PHP Brew Manager

`pbm` is a simple CLI tool to manage multiple PHP versions installed via Homebrew. It allows you to easily install, uninstall, and switch between PHP versions.

## 🚀 Installation

Run the following command to download and install `pbm`:

```sh
wget -qO /usr/local/bin/pbm https://raw.githubusercontent.com/Aybee5/pbm/main/pbm.sh && chmod +x /usr/local/bin/pbm
```

📌 **Requirements:** Ensure Homebrew is installed before using `pbm`.

## 🛠 Usage

### 📋 List Installed PHP Versions
```sh
pbm --list
```

### ⬇ Install a PHP Version
```sh
pbm --install <version>
```
Example:
```sh
pbm --install 8.2
```

### ❌ Uninstall a PHP Version
```sh
pbm --uninstall <version>
```
Example:
```sh
pbm --uninstall 8.1
```

### 🔄 Switch to a PHP Version
```sh
pbm use <version>
```
Example:
```sh
pbm use 8.3
```

### 🔧 Use a PHP Version Temporarily (Session Only)
```sh
pbm use <version> --temporary
```
Example:
```sh
pbm use 8.2 --temporary
```

### 🔥 Set a PHP Version as Default (Permanent)
```sh
pbm use <version> --permanent
```
Example:
```sh
pbm use 8.3 --permanent
```

### 🆘 Show Help
```sh
pbm --help
```

## 🔄 Updating `pbm`
To update `pbm` to the latest version, simply re-run the installation command:
```sh
wget -qO /usr/local/bin/pbm https://raw.githubusercontent.com/Aybee5/pbm/main/pbm.sh && chmod +x /usr/local/bin/pbm
```

## 🚀 Contributing
Feel free to contribute by submitting issues and pull requests to [pbm on GitHub](https://github.com/Aybee5/pbm)!

## 📜 License
This project is licensed under the MIT License.

---

Enjoy seamless PHP version switching! 🏆🔥

