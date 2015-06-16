class authconfig::config inherits authconfig {

  if $authconfig::winbind {
    file { '/etc/security/pam_winbind.conf':
      ensure => file,
      owner  => 0,
      group  => 0,
      mode   => '0644',
      content => template($pamwinbindtemplate),
    }
  }
}
