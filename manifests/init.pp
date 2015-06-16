# Class: authconfig
#
# This module manages authconfig
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class authconfig (
#authconfig --smbservers= --smbsecurity=ads --enablemkhomedir --smbrealm=dev.ja.net --enablewinbind --enablewinbindauth --enablesysnetauth 
# --winbindtemplateshell=/bin/bash --smbworkgroup=DEV --enablewinbindusedefaultdomain --enablekrb5kdcdns --enablekrb5realmdns --enablewinbindoffline --updateall

  # Authconfig Options
  $mkhomedir                = $authconfig::params::mkhomedir,
  $sysnetauth               = $authconfig::params::sysnetauth,

  $winbind                  = $authconfig::params::winbind,
  $winbindauth              = $authconfig::params::winbindauth,
  $winbindusedefaultdomain  = $authconfig::params::winbindusedefaultdomain,
  $winbindoffline           = $authconfig::params::winbindoffline,
  $winbindtemplateshell     = $authconfig::params::winbindtemplateshell,

  $smbservers               = $authconfig::params::smbservers,
  $smbsecurity              = $authconfig::params::smbsecurity,
  $smbrealm                 = $authconfig::params::smbrealm,
  $smbworkgroup             = $authconfig::params::smbworkgroup,

  $krb5kdcdns               = $authconfig::params::krb5kdcdns,
  $krb5realmdns             = $authconfig::params::krb5realmdns,
  
	$nisdomain                = $authconfig::params::nisdomain,
 
  
  $pam_wb_debug                 = $authconfig::params::pam_wb_debug,
  $pam_wb_debug_state           = $authconfig::params::pam_wb_debug_state,
  $pam_wb_krb5_auth             = $authconfig::params::pam_wb_krb5_auth,
  $pam_wb_krb5_ccache_type      = $authconfig::params::pam_wb_krb5_ccache_type,
  $pam_wb_require_membership_of = $authconfig::params::pam_wb_require_membership_of,
  
  # Internal Options
  $pamwinbindtemplate       = $authconfig::params::pamwinbindtemplate,
) inherits authconfig::params {
  
  # Valdiations
  validate_bool($krb5kdcdns)
  validate_bool($krb5realmdns)
  validate_bool($winbindoffline)
  validate_bool($winbind)
  validate_bool($winbindauth)
  validate_bool($sysnetauth)
  validate_bool($mkhomedir)
  validate_bool($winbindusedefaultdomain)
    
  validate_string($smbsecurity)
  validate_string($smbrealm)
  validate_string($smbworkgroup)
  validate_string($nisdomain)

  validate_array($smbservers)
 
  validate_absolute_path($winbindtemplateshell)

  class { 'authconfig::install': } ->
  class { 'authconfig::config': } ~>
  class { 'authconfig::service': } ->
  Class['authconfig']
}
