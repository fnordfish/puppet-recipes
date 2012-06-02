class boxes::rubydev ($git_project_url = '', $project_name = '') {
  Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/home/vagrant/.rvm/bin" ] }
  include boxes::devbox
  include boxes::heroku

  define bundler::install_bundles_in() {
    exec { "install_bundles_${name}":
      user => vagrant,
      environment => "HOME=/home/vagrant",
      cwd => "/home/vagrant/${name}",
      command => "rvm-shell 1.9.2 -c 'bundle install --binstubs'",
      # FixMe: We might not find all Bundles which need installation
      logoutput => true,
    }
  }

  if $git_project_url != "" {
    Ssh::User['vagrant']
    -> git::clone { "$project_name":
      localtree => "/home/vagrant",
      source => "$git_project_url",
      require => Class["ssh::server"]
    }
    -> bundler::install_bundles_in { "$project_name":
      require => [Rvm::Define::Version["ruby-1.9.2"], Rvm::Define::Gem["bundler"], Package["libpq-dev"]]
    }
  }
}