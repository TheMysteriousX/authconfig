class authconfig::params {
  $smbservers                   = []
  $smbsecurity                  = ''
  $mkhomedir                    = false
  $smbrealm                     = ''
  $winbind                      = false
  $winbindauth                  = false
  $sysnetauth                   = false
  $winbindtemplateshell         = '/bin/bash'
  $smbworkgroup                 = ''
  $winbindusedefaultdomain      = false
  $krb5kdcdns                   = false
  $krb5realmdns                 = false
  $winbindoffline               = false
  $nisdomain                    = ''
  
  # PAM Winbind Options
  $pam_wb_debug                 = false
  $pam_wb_debug_state           = false
  $pam_wb_krb5_auth             = false
  $pam_wb_krb5_ccache_type      = ''
  $pam_wb_require_membership_of = ['domain admins',]

  # Internal Options  
  $pamwinbindtemplate           = $::operatingsystemmajrelease ? { 6 => 'authconfig/el6/pam_winbind.conf.erb',
																															     7 => 'authconfig/el7/pam_winbind.conf.erb',
																															     default => ''
																															    }
}