class bind::config(
  $bind_user = $bind::bind_user,
  $local_domain = $bind::local_domain,
  $ns_hostanme = $bind::ns_hostname) inherits bind {

  include storage
  if $storage::bind {
    contain bind::mounts
  }

  File[
    "/etc/bind", "/var/lib/bind", "/var/log/bind", "/var/cache/bind"] {
    ensure => directory,
    group  => "${bind_user}",
    require => Group["${bind_user}"],
  }

  File["/var/log/bind"] {
    mode   => 755,
    owner  => "${bind_user}",    
  }
  User["${bind_user}"] -> File["/var/log/bind"]  
  
  File[
   "/var/lib/bind", "/var/cache/bind"] {
    mode   => "g+w",
  }

  File["/etc/bind"] {
    mode => 2755,
  }


  contain bind::user::definition

  package { "dnsutils":
  }

  Package["bind9", "dnsutils"] {
    ensure => latest,
    require => File["/etc/apt/sources.list"], 
  }
    
  File["/etc/bind/named.conf.options", "/etc/bind/named.conf.local", "/etc/bind/named.conf.default-zones" ] {
    group   => $bind_user,
    notify  => Service["bind9"],
    require => [ Package["bind9"], Group["$bind_user"] ],
  }
  
  contain bind::resolv
  Service["bind9"] -> File["/etc/resolv.conf"]

  if ($::blockdevice_sda_vendor == "QEMU") or ($::blockdevice_sdb_vendor == "QEMU") {
    $ns_ip = join( concat( delete_at( split($::ipaddress_eth0, '\.'), 3), '1'), '.')
    validate_ip_address($ns_ip)
    class { 'bind::conf::options':
      forwarders => [$ns_ip],
    }
    class { 'bind::conf::global':
      bind_ip => $::ipaddress_eth0,
    }
    class { 'bind::conf::local':
      bind_ip => $::ipaddress_eth0,
    }
  } else {
    contain bind::conf::global
    contain bind::conf::options
    contain bind::conf::local
  }

  File["/etc/default/bind9"] {
    ensure => file,
    source => "puppet:///modules/bind/bind9-default",
  }
}