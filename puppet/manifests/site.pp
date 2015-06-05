Package {
  allow_virtual => true
}

node default {
  package { 'elixir':
    ensure => installed
  }
}
