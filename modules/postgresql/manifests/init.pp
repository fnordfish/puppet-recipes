### stolen from https://github.com/KrisBuytaert/puppet-postgres/blob/master/manifests/init.pp

# Base SQL exec
define sqlexec($username, $password, $database, $sql, $sqlcheck) {
  if $password == "" {
    exec{ "psql -h localhost --username=${username} $database -c \"${sql}\" >> /var/lib/puppet/log/postgresql.sql.log 2>&1 && /bin/sleep 5":
      path => $path,
      timeout => 600,
      unless => "psql -U $username $database -c $sqlcheck",
      require => [Service[postgresql]],
    }
  } else {
    exec{ "psql -h localhost --username=${username} $database -c \"${sql}\" >> /var/lib/puppet/log/postgresql.sql.log 2>&1 && /bin/sleep 5":
      environment => "PGPASSWORD=${password}",
      path => $path,
      timeout => 600,
      unless => "psql -U $username $database -c $sqlcheck",
      require => [Service[postgresql]],
    }
  }
}

# Create a Postgres user
# attr [SUPERUSER | CREATEDB | CREATEROLE | ]
define postgres::createuser($passwd, $attr="") {
  if !defined('password') {
    $password = ""
  }
  sqlexec{ createuser:
    password => $password,
    username => "postgres",
    database => "postgres",
    sql => "CREATE ROLE ${name} WITH ${$attr} LOGIN PASSWORD '${passwd}';",
    sqlcheck => "\"SELECT usename FROM pg_user WHERE usename = '${name}'\" | grep ${name}",
    require => Service[postgresql],
  }
}

# Create a Postgres db
define postgres::createdb($owner) {
  if !defined('password') {
    $password = ""
  }
  sqlexec{ $name:
    password => $password,
    username => "postgres",
    database => "postgres",
    sql => "CREATE DATABASE $name WITH OWNER = $owner ENCODING = 'UTF8';",
    sqlcheck => "\"SELECT datname FROM pg_database WHERE datname ='$name'\" | grep $name",
    require => Service[postgresql],
  }
}

define postgresql::createlang($lang) {
  sqlexec{ $name:
    password => $password,
    username => "postgres",
    database => "postgres",
    sql => "CREATE LANGUAGE $lang $name;",
    sqlcheck => "\"SELECT lanname FROM pg_language WHERE lanname ='$name'\" | grep $name",
    require => Service[postgresql],
  }
}

