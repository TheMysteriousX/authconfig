# == Class module::install
#

class authconfig::install inherits authconfig {

  package { 'authconfig':
    ensure => 'installed',
  }

  if $authconfig::winbind or $authconfig::winbindauth {
    package { 'samba-winbind':
      ensure => 'installed',
    }
  }
  
  if $authconfig::mkhomedir {
    package { 'oddjob-mkhomedir':
      ensure => 'installed',
    }
  }

}