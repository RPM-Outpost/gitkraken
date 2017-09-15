%define install_dir /opt/gitkraken
%define apps_dir /usr/share/applications

Name:		gitkraken
Version:	%{version_number}
Release:	0%{?dist}
Summary:	Free Voice and Text Chat for Gamers.

Group:		Applications/Internet
License:	Proprietary
URL:		https://gitkraken.com/
BuildArch:	x86_64
Requires:   glibc, git

%description
All-in-one voice and text chat for gamers that’s free, secure, and works on both your desktop and phone. 
It’s time to ditch Skype and TeamSpeak.

%prep

%build

%install
mkdir -p "%{buildroot}%{install_dir}"
mkdir -p "%{buildroot}%{apps_dir}"
mv "%{downloaded_dir}"/* "%{buildroot}%{install_dir}"
cp "%{desktop_file}" "%{buildroot}%{apps_dir}"
chmod +x "%{buildroot}%{install_dir}"/*.so
chmod +x "%{buildroot}%{install_dir}/%{exec_name}"

%files
%{install_dir}
%{apps_dir}/*

