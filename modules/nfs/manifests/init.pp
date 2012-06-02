
class nfs {
  
  # writes a new /etc/exports file
  # takes an object like: {
  #   '/path/exported/directory' => 'export_to_and_nfs_export_options',
  #   '/home/jon' => '0.0.0.0/0.0.0.0(rw,insecure,sync)'
  # }
  define export( $exports ) {
    file { "/etc/exports":
      content => template("nfs/server/exports.erb"),
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '644',
      notify  => Service['nfs-kernel-server']
    }
  }

  class server( $exports = {} ) {

    nfs::export {"/etc/exports":
      exports => $exports
    }

    service { "nfs-kernel-server":
      require => Package['nfs-kernel-server'],
      ensure => running,
      enable => true
    }

    package { 'nfs-kernel-server':
      ensure => installed
    }
  }
}