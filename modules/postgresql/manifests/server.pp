
class postgresql::server ($version = '8.3') {

    package {"postgresql-${version}":
      ensure => present,
      alias  => "postgresql-server" 
    }

    exec { "postgres-fix-utf8_drop_cluster":
      require => Package["postgresql-server"],
      command => "sudo -u postgres pg_dropcluster --stop ${version} main",
      logoutput => true,
      unless => "psql -U postgres -l | grep -e 'template1.*UTF8'"
    }
    exec { "postgres-fix-utf8_recreate_cluster":
      require => Exec["postgres-fix-utf8_drop_cluster"],
      command => "sudo -u postgres pg_createcluster --start -e UTF-8 ${version} main",
      logoutput => true,
      unless => "psql -U postgres -l | grep -e 'template1.*UTF8'"
    }
    
    file { "/etc/postgresql/${version}/main/pg_hba.conf":
      content => template("postgresql/server/pg_hba.conf.erb"),
      ensure => present,
      owner => "postgres",
      mode => 0640,
      notify => Service["postgresql-server"],
      require => [Package["postgresql-server"], Exec["postgres-fix-utf8_recreate_cluster"]],
    }

    service {"postgresql":
      ensure => running,
      enable => true,
      require => [Package["postgresql-server"], Exec["postgres-fix-utf8_recreate_cluster"]],
      alias => "postgresql-server"
    }

    package {"libpq-dev":
      ensure => present
    }

}