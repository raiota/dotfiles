# dotfiles

## 1. Description

raiota's dotfiles

## 2. Installation

### 2.1. System Setup

#### 2.1.1. Mac OS

#### 2.1.2. WSL - Debian

1. Check out all the available distros supported by WSL.

   ```
   wsl --list --online
   ```

2. Install Debian

   ```
   wsl --install -d Debian
   ```

3. Start Debian

4. Update APT cache and upgrade all the packages.

   ```
   sudo apt update && sudo apt upgrade -y
   ```

5. Check the Debian version, and if it's not the latest version, do the following (5.1 ~ 5.6) process.

   ```
   cat /etc/os-release
   ```

   1. (If not the latest version), Make a backup copy of the `sources.list` file.

      ```
      sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
      ```

   2. (If not the latest version),  Edit the `sources.list` as following.

      ```
      sudo vi /etc/apt/sources.list
      ```

      ```
      deb http://deb.debian.org/debian bullseye main contrib non-free
      deb http://deb.debian.org/debian bullseye-updates main contrib non-free
      deb http://security.debian.org/debian-security bullseye-sequrity main contrib non-free
      ```

   3. (If not the latest version), Run the APT update commands again.

      ```
      sudo apt clean && sudo apt update
      ```

      ```
      sudo apt full-upgrade
      ```

   4. (If not the latest version), Select `Yes` when asked "Restart services during package upgrades without asking?".

   5. (If not the latest version), Safely get rid of the obsolete packages on the system.

      ```
      sudo apt autoremove
      ```

   6. (If not the latest version), Restart the Debian session to take changes and verify the change.

      ```
      cat /etc/os-release
      ```


## Reference

- https://linuxhint.com/start-debian-gui-windows-10-wsl/