class authconfig::service inherits authconfig {
  # General
  
  $generalflags = [ $mkhomedir ? { true => '--enablemkhomedir',
                                   false => '--disablemkhomedir',
                                   default => '--disablemkhomedir'
                                  },

                    $sysnetauth ? { true => '--enablesysnetauth',
                                    false => '--disablesysnetauth',
                                    default => '--disablsysnetauth'
                                   }
                   ]

  # Winbind

  $winbindflags = [ $winbind ? { true => '--enablewinbind',
                                 false => '--disablewinbind',
                                 default => '--disablewinbind'
                                },

                    $winbindauth ? { true => '--enablewinbindauth',
                                     false => '--disablewinbindauth',
                                     default => '--disablewinbindauth'
                                    },

                    $winbindusedefaultdomain ? { true => '--enablewinbindusedefaultdomain',
                                                 false => '--disablewinbindusedefaultdomain',
                                                 default => '--disablewinbindusedefaultdomain'
                                                },

                    $winbindoffline ? { true => '--enablewinbindoffline',
                                        false => '--disablewinbindoffline',
                                        default => '--disablewinbindoffline'
                                       },

                    "--winbindtemplateshell=${winbindtemplateshell}",
                   ]


  # Samba
  
  $sambaflags = [ join([ "--smbservers=\"", join($smbservers, ' '), "\"" ]),
                  "--smbsecurity=${smbsecurity}",
                  "--smbrealm=${smbrealm}",
                  "--smbworkgroup=${smbworkgroup}",
                 ]
  
  # Kerberos
  
  $kerberosflags = [ $krb5kdcdns ? { true => '--enablekrb5kdcdns',
                                     false => '--disablekrb5kdcdns',
                                     default => '--disablekrb5kdcdns'
                                    },
                                        
                     $krb5realmdns ? { true => '--enablekrb5realmdns',
                                       false => '--disablekrb5realmdns',
                                       default => '--disablekrb5realmdns'
                                      },
                    ]

  # NIS
  $nisflags = [ "--nisdomain=${nisdomain}", ]

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
  }

  # Add some nice things to smb.conf if they're not there already.
  augeas { "smb_config":
    changes => [
      "set /files/etc/samba/smb.conf/target[1]/winbind\ refresh\ tickets yes",
      "set /files/etc/samba/smb.conf/target[1]/kerberos\ method secrets\ and\ keytab",
    ],
  } 
}