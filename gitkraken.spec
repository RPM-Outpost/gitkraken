%define install_dir /opt/gitkraken
%define apps_dir /usr/share/applications

Name:		gitkraken
Version:	%{version_number}
Release:	0%{?dist}
Summary:	Modern GUI for git

Group:		Applications/Internet
License:	Proprietary
URL:		https://gitkraken.com/
BuildArch:	x86_64
Requires:   glibc, git, libcurl

%description
Unleash your repo!

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

%post
# Fix gitkraken error caused by missing library libcurl-gnutls.so.4
cd /usr/lib64
ln -s -f libcurl.so.4 libcurl-gnutls.so.4
