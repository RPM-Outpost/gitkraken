![gitkraken logo](gitkraken-wide.png)

# Gitkraken rpm

Unofficial rpm package for gitkraken.

## How to use
Open a terminal and run `./create-package.sh <gitkraken_version>`, where `<gitkraken_version>` is for instance `3.0.0`.

## Features
- Downloads the latest version of Gitkraken from the official website
- Creates a ready-to-use RPM package
- Adds Gitkraken to the applications' list with a nice HD icon
- Supports Fedora (26 & 27), OpenSUSE (Leap), CentOS (7.x) and Mageia (untested on Mageia).

## More informations

### How to update
When a new version of gitkraken is released, simply run the script again to get the updated version.

### Requirements
The `rpmdevtools` package is required to build RPM packages. The script detects if it isn't installed and offers to install it.

### About the version parameter
The script cannot detect the version of gitkraken, that's why you have to specify it. The downloaded version is always the latest one, regardless of what you specified.

### About root privileges
Building an RPM package with root privileges is dangerous, see http://serverfault.com/questions/10027/why-is-it-bad-to-build-rpms-as-root.

## Screenshots
![beautiful screenshot](screenshot1.png)

![screenshot when gitkraken has already been downloaded](screenshot2.png)
