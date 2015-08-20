class authconfig::service inherits authconfig {

  # General
  
  $generalflags = [ pick($preset_config[mkhomedir], $mkhomedir) ? { true => '--enablemkhomedir',
                                                                    false => '--disablemkhomedir',
                                                                    default => '--disablemkhomedir'
                                                                   },

                    pick($preset_config[sysnetauth], $sysnetauth) ? { true => '--enablesysnetauth',
                                                                      false => '--disablesysnetauth',
                                                                      default => '--disablsysnetauth'
                                                                     },
                   ]

  # Winbind

  $winbindflags = [ pick($preset_config[winbind], $winbind) ? { true => '--enablewinbind',
                                                                false => '--disablewinbind',
                                                                default => '--disablewinbind'
                                                               },

                    pick($preset_config[winbindauth], $winbindauth) ? { true => '--enablewinbindauth',
                                                                        false => '--disablewinbindauth',
                                                                        default => '--disablewinbindauth'
                                                                       },

                    pick($preset_config[winbindusedefaultdomain], $winbindusedefaultdomain) ? { true => '--enablewinbindusedefaultdomain',
                                                                                                false => '--disablewinbindusedefaultdomain',
                                                                                                default => '--disablewinbindusedefaultdomain'
                                                                                               },

                    pick($preset_config[winbindoffline], $winbindoffline) ? { true => '--enablewinbindoffline',
                                                                              false => '--disablewinbindoffline',
                                                                              default => '--disablewinbindoffline'
                                                                             },

                    join(["--winbindtemplateshell=", pick($preset_config[winbindtemplateshell], $winbindtemplateshell)], ""),

                    $::operatingsystemmajrelease ? { '7' => '--enablewinbindkrb5',
                                                     default => ''
                                                    },
                   ]

  # Samba
  
  $sambaflags = [ join([ "--smbservers=\"", join(pick($preset_config[smbservers], $smbservers), ' '), "\"" ], ""),
                  join(["--smbsecurity=", pick($preset_config[smbsecurity], $smbsecurity)], ""),
                  join(["--smbrealm=", pick($preset_config[smbrealm], $smbrealm)], ""),
                  join(["--smbworkgroup=", pick($preset_config[smbworkgroup], $smbworkgroup)], ""),
                 ]
  
  # Kerberos
  
  $kerberosflags = [ pick($preset_config[krb5kdcdns], $krb5kdcdns) ? { true => '--enablekrb5kdcdns',
                                                                       false => '--disablekrb5kdcdns',
                                                                       default => '--disablekrb5kdcdns'
                                                                      },
                                        
                     pick($preset_config[krb5realmdns], $krb5realmdns) ? { true => '--enablekrb5realmdns',
                                                                           false => '--disablekrb5realmdns',
                                                                           default => '--disablekrb5realmdns'
                                                                          },
                    ]

  # https://bugzilla.redhat.com/show_bug.cgi?id=1006191

  # NIS
  $nisflags = [ join(["--nisdomain=", pick($preset_config[nisdomain], $nisdomain)], ""), ]

  # Build the config into a single array to pass as parameters.
  
  $flags = concat($generalflags, $winbindflags, $sambaflags, $kerberosflags, $nisflags)
  $args = join($flags, " ")

  # Log what we're going to apply.

  notify { "Building authentication configuration...": withpath => true}
  notify { "Going to apply generalflags: ${generalflags}": }
  notify { "Going to apply winbindflags ${winbindflags}": }
  notify { "Going to apply sambaflags ${sambaflags}": }
  notify { "Going to apply kerberosflags ${kerberosflags}": }
  notify { "Going to apply nisflags ${nisflags}": }
      
  # Hash the arguments so that the command is only run on the first puppet run after boot, and when the configuration is actually changed.
  # Authconfig is idempotent, but it's a heavy piece of code, and could end up restarting services every run.
  $argshash = pw_hash($args, 'sha-256', 'NSA')

  exec {'authconfig':
    path    => ['/usr/bin', '/usr/sbin'],
    command =>  "authconfig ${args} --updateall",
    refreshonly => true,
  }

  # Add some nice things to smb.conf if they're not there already.
  augeas { "smb_config_el_all":
    changes => [
      "set /files/etc/samba/smb.conf/target[1]/winbind\\ refresh\\ tickets yes",
    ],
  }
  
  if {$::operatingsystemmajrelease == 6) {
    augeas { "smb_config_el_6":
      changes => [
          "set /files/etc/samba/smb.conf/target[1]/kerberos\\ method secrets\\ and\\ keytab",
    }
  }
}
