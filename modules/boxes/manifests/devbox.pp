class boxes::devbox {
	Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/home/vagrant/.rvm/bin" ] }

	include sysconfig
  include sysconfig::misc
  include sysconfig::sudoers
  if !defined(Apt) {
    include apt
  }
	include puppet
	include rvm
	include rubies::dependencies::mri
	include ssh::server
  class {'nfs::server':
    exports => {
      '/home/vagrant' => '0.0.0.0/0.0.0.0(anonuid=1000,anongid=1000,no_subtree_check,rw,insecure,all_squash)'
    }
  }

	include git::client

  user {"vagrant":
    ensure => present,
    home => "/home/vagrant"
  } -> file {"/home/vagrant":
    ensure => directory,
    owner => vagrant
  }

  user {"root":
    ensure => present,
    home => "/root"
  } -> file {"/root":
    ensure => directory,
    owner => root
  }

  ssh::user {"vagrant":
  }

  ssh::user { "root":
    home => "/root"
  }

}