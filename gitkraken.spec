%define install_dir /opt/gitkraken
%define apps_dir /usr/share/applications
%define _build_id_links none

Name:		gitkraken
Version:	%{pkg_version}
Release:	1%{?dist}
Summary:	Modern GUI for git

Group:		Applications/Internet
License:	Proprietary
URL:		https://gitkraken.com/
BuildArch:	x86_64
Requires:   %{pkg_req}

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
ln -s -f /usr/lib64/libcurl.so.4 /opt/gitkraken/libcurl-gnutls.so.4

