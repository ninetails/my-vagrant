
node 'default' {
  group { 'puppet': ensure => present }
  Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }
  File { owner => 0, group => 0, mode => 0644 }

  class { 'apt':
    always_apt_update => true
  }

  # basic
  $basic_packages = hiera('basic_package', [
    'aptitude',
    'curl',
    'git',
    'vim'
  ])
  package { $basic_packages:
    ensure => present,
  }

  # php
  class { 'php::fpm': }

  class { 'php::apache2proxy': }

  class { 'php::composer': }

  php::module {'apc':
    module_prefix => 'php-',
    notify => [
      Class['php::apache2::service'],
      Class['php::fpm::service']
    ],
  }

  $php_modules = hiera('php_modules', [
    'cli',
    'curl',
    'dev',
    'gd',
    'intl',
    'mcrypt',
    'mysqlnd',
    'tidy'
  ])
  php::module {$php_modules:
    notify => [
      Class['php::apache2::service'],
      Class['php::fpm::service']
    ],
  }

  php::pear { 'phpqatools':
    command => "pear install --alldeps --force pear.phpqatools.org/phpqatools",
    timeout => 0,
  }

  # mysql
  $mysql_root_password = hiera('mysql_root_pass', '123456')
  class { 'mysql::server':
    root_password => $mysql_root_password,
  }

  $mysql_db = hiera('mysql_db', {
    'db' => {
      user     => 'dev',
      password => '123456',
      host     => 'localhost',
      grant    => ['all'],
      charset  => 'utf8'
    }
  })

  create_resources(mysql::db, $mysql_db, {require => File['/root/.my.cnf']})

  # sass
  package { 'sass':
    ensure => present,
    provider => 'gem',
  }

  # node.js
  class { 'nodejs':
    version => 'stable',
    make_install => false,
  }

  # coffeescript + yeoman
  $npm_packages = hiera('npm_packages', [
    'coffee-script',
    'yo'
  ])
  package { $npm_packages:
    ensure => present,
    provider => 'npm',
    require => Class['nodejs'],
  }

}
