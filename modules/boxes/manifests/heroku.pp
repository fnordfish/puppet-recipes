# puppet manifests for a heroku-like box

class boxes::heroku {
  include puppet
  include rvm
  include rubies::dependencies::mri

  apt::ppa { "ppa:pitti/postgresql" : } -> class {'postgresql::server':
    version => '9.1'
  }

  rvm::define::version { "ruby-1.9.2":
    ensure => 'present',
    default_ruby => 'true',
    require => Class["rubies::dependencies::mri"]
  }

  rvm::define::gem { ['bundler', 'pry', 'yard', 'foreman']:
    ensure       => 'present',
    ruby_version => 'ruby-1.9.2',
  }

}
