#!/bin/bash
# Author: TheElectronWill
# This script downloads the latest version of gitkraken for linux, and creates a package with rpmbuild.

source terminal-colors.sh # Adds color variables
source common-functions.sh # Adds utilities functions
source basic-checks.sh # Checks that rpmbuild is available and that the script isn't started as root

rpm_dir="$PWD/RPMs"
work_dir="$PWD/work"

arch='x86_64'
pkg_version="$1"
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

# Settings according to the distribution
if [[ $distrib == "redhat" ]]; then
	pkg_req='glibc, git, libcurl'
elif [[ $distrib == "mageia" || $distrib == "suse" ]]; then
	pkg_req='glibc, git, libcurl4'
else
	disp "${red}Sorry, your distribution isn't supported (yet).$reset"
	exit
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
	wget $wget_progress "$download_url" -O "$archive_file"
}

manage_dir "$work_dir" 'work'
manage_dir "$rpm_dir" 'RPMs'
cd "$work_dir"

# Downloads gitkraken if needed.
if [ -e "$archive_name" ]; then
	echo "Found the archive \"$archive_name\"."
	ask_yesno 'Use this archive instead of downloading a new one?'
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

# Extracts the archive:
echo
if [ ! -d "$downloaded_dir" ]; then
	mkdir "$downloaded_dir"
fi
extract "$archive_name" "$downloaded_dir" "--strip 1" # --strip 1 gets rid of the top archive's directory


echo 'Creating the .desktop file...'
cp "$icon_file" "$downloaded_dir"
cp "$desktop_model" "$desktop_file"
sed "s/@version/$pkg_version/; s/@icon/$icon_name/; s/@exe/$exec_name/" "$desktop_model" > "$desktop_file"


disp "${yellow}Creating the RPM package (this may take a while)..."
rpmbuild -bb --quiet "$spec_file" --define "_topdir $work_dir" --define "_rpmdir $rpm_dir"\
	--define "arch $arch" --define "downloaded_dir $downloaded_dir" --define "desktop_file $desktop_file"\
	--define "pkg_version $pkg_version" --define "pkg_req $pkg_req" --define "exec_name $exec_name"

disp "${bgreen}Done!${reset_font}"
disp "The RPM package is located in the \"RPMs/$arch\" folder."
disp '----------------'

ask_remove_dir "$work_dir"
ask_installpkg
