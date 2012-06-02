class { 'apt':
    purge_sources_list => true,
}
apt::source {"ubuntu_restricted":          location => 'http://archive.ubuntu.com/ubuntu/', release => 'lucid', repos => 'main restricted', }
apt::source {"ubuntu_universe":            location => 'http://archive.ubuntu.com/ubuntu/', release => 'lucid', repos => 'universe', }
apt::source {"ubuntu_multiverse":          location => 'http://archive.ubuntu.com/ubuntu/', release => 'lucid', repos => 'multiverse', }
apt::source {"ubuntu_update_restricted":   location => 'http://archive.ubuntu.com/ubuntu/', release => 'lucid-updates', repos => 'main restricted', }
apt::source {"ubuntu_update_universe":     location => 'http://archive.ubuntu.com/ubuntu/', release => 'lucid-updates', repos => 'universe', }
apt::source {"ubuntu_update_multiverse":   location => 'http://archive.ubuntu.com/ubuntu/', release => 'lucid-updates', repos => 'multiverse', }
apt::source {"ubuntu_security_restricted": location => 'http://security.ubuntu.com/ubuntu', release => 'lucid-security', repos => 'main restricted', }
apt::source {"ubuntu_security_universe":   location => 'http://security.ubuntu.com/ubuntu', release => 'lucid-security', repos => 'universe', }
apt::source {"ubuntu_security_multiverse": location => 'http://security.ubuntu.com/ubuntu', release => 'lucid-security', repos => 'multiverse', }
class { 'boxes::rubydev':
  # project_name => 'projectX',
  # git_project_url => "git@github.com:foo/vprojectX.git"
}