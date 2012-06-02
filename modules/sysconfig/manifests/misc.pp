class sysconfig::misc {

  # move the "old" .profile file to the new ".bash_login"
  # this avoinds conflicts with rvm and other installations
  # messing around with old bash startup files
  exec { "move_profile_to_bashlogin" :
    command => '/bin/mv /home/vagrant/.profile /home/vagrant/.bash_login',
    creates => '/home/vagrant/.bash_login'
  }

  package { "vim":
    ensure => present,
  }

  package { "htop":
    ensure => present,
  }

  package {"ack-grep":
    ensure => present
  }

  file { "/usr/bin/ack":
    ensure => link,
    owner => "root",
    target => "/usr/bin/ack-grep",
    require => Package["ack-grep"],
  }
}