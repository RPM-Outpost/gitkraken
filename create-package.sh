#!/bin/bash
# Author: TheElectronWill
# This script downloads the latest version of gitkraken for linux, and creates a package with rpmbuild.
source terminal-colors.sh

rpm_dir="$PWD/RPMs"
work_dir="$PWD/work"

arch='x86_64'
version_number="$1"
archive_name='gitkraken-linux.tar.gz'
download_url='https://release.gitkraken.com/linux/gitkraken-amd64.tar.gz'

desktop_model="$PWD/gitkraken.desktop"
icon_name="gitkraken.png"
icon_file="$PWD/$icon_name"
spec_file="$PWD/gitkraken.spec"

desktop_file="$work_dir/gitkraken.desktop"
archive_file="$work_dir/$archive_name"

downloaded_dir="$work_dir/gitkraken"
exec_name='gitkraken'
exec_file="$downloaded_dir/$exec_name"


# It's a bad idea to run rpmbuild as root!
if [ "$(id -u)" = "0" ]; then
	disp "$red_bg------------------------ WARNING ------------------------\n\
	      This script should NOT be executed with root privileges!\n\
	      Building rpm packages as root is dangerous and may harm the system!\n\
	      Actually, badly written RPM spec files may execute dangerous command in the system directories.\n\
	      So it is REALLY safer not to run this script as root.\n\
	      If you still want to continue, type \"do it!\" within 5 seconds (type anything else to exit)."
	disp "------------------------ WARNING ------------------------$reset$bold"
	read -t 5 -p '> Do you really want to do it (not recommended)? ' answer
	if [ "$answer" != "do it!" ]; then
		exit
	fi
	style $reset
fi

# Checks that the rpmbuild package is installed.
if ! type 'rpmbuild' > /dev/null; then
	echo 'You need the rpm development tools to create rpm packages.'
	style $bold
	read -n 1 -p '> Install the rpmdevtools package now? [y/N]: ' answer
	echo
	case "$answer" in
		y|Y)
			sudo -p 'Enter your password to install rpmdevtools: ' dnf install rpmdevtools
			;;
		*) 
			echo "${reset}Ok, I won't install rpmdevtools."
			exit
	esac
	style $reset
else
	disp "${green}rpmbuild detected.$reset"
fi

# Checks that the version is given as a parameter.
if [ $# -ne 1 ]; then
	disp "${red}Wrong number of parameters!$reset"
	echo 'Usage: create-package.sh gitkraken_version'
	echo ' - gitkraken_version: for instance 2.1 or 3.0.0'
	exit
fi

# Downloads the gitkraken zip archive.
download_gitkraken() {
	echo 'Downloading the latest gitkraken for linux...'
	wget -q --show-progress "$download_url" -O "$archive_file"
}

# Asks the user if they want to remove the specified directory, and removes it if they want to.
ask_remove_dir() {
	style $reset$bold
	read -n 1 -p "> Remove the directory \"$1\"? [y/N]: " answer
	echo
	style $reset
	case "$answer" in
		y|Y)
			rm -r "$1"
			echo "Directory removed."		
			;;
		*)
			echo "Directory not removed."
	esac
	echo
}

# If the specified directory exists, asks the user if they want to remove it.
# If it doesn't exist, creates it.
manage_dir() {
	if [ -d "$1" ]; then
		echo "The $2 directory already exist and may contain outdated data."
		ask_remove_dir "$1"
	fi
	mkdir -p "$1"
}

manage_dir "$work_dir" 'work'
manage_dir "$rpm_dir" 'RPMs'
cd "$work_dir"

# Downloads gitkraken if needed.
if [ -e "$archive_name" ]; then
	echo "Found the archive \"$archive_name\"."
	style $reset$bold
	read -n 1 -p '> Use this archive instead of downloading a new one? [y/N]: ' answer
	echo
	style $reset
	case "$answer" in
		y|Y)
			echo 'Existing archive selected.'
			;;
		*)
			rm "$archive_name"
			echo 'Existing archive removed.'
			download_gitkraken
	esac
else
	download_gitkraken
fi


echo
echo 'Extracting the files...'
if [ ! -d "$downloaded_dir" ]; then
	mkdir "$downloaded_dir"
fi
tar -xzf "$archive_name" -C "$downloaded_dir" --strip 1 # --strip 1 gets rid of the top archive's directory


echo 'Creating the .desktop file...'
cp "$icon_file" "$downloaded_dir"
cp "$desktop_model" "$desktop_file"
sed "s/@version/$version_number/; s/@icon/$icon_name/; s/@exe/$exec_name/" "$desktop_model" > "$desktop_file"


disp "${yellow}Creating the RPM package (this may take a while)..."
rpmbuild -bb --quiet --nocheck "$spec_file" --define "_topdir $work_dir" --define "_rpmdir $rpm_dir"\
	--define "arch $arch" --define "downloaded_dir $downloaded_dir" --define "desktop_file $desktop_file"\
	--define "version_number $version_number" --define "exec_name $exec_name"

disp "${bgreen}Done!${reset_font}"
disp "The RPM package is located in the \"RPMs/$arch\" folder."
disp '----------------'

ask_remove_dir "$work_dir"
