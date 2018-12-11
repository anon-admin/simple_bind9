class bind::conf::local ($bind_ip = $bind::bind_ip,
  $local_ip = $bind::local_ip,
  $local_domain = $bind::local_domain,
  $rndckey = $bind::rndckey,
  $external_domain = $bind::external_domain
) inherits bind {

  $digits = split($bind_ip, '\.')
  $in_addr_arpa = "${digits[2]}.${digits[1]}.${digits[0]}"

  $serial = strftime("%s")

  contain bind::conf::log

  File["/etc/bind/named.conf.local"] {
    content => template("bind/named.conf.local.erb"), }

  File["/etc/bind/db.${local_domain}"] -> File["/etc/bind/named.conf.local"]
  File["/etc/bind/db.${local_domain}.inv"] -> File["/etc/bind/named.conf.local"]

  file { ["/var/lib/bind/db.${local_domain}"]:
    ensure => link,
    target => "/etc/bind/db.${local_domain}",
  }
  # File["/etc/bind/db.${local_domain}"] -> File["/etc/bind/db.${local_domain}"]

  file { ["/var/lib/bind/db.${local_domain}.inv"]:
    ensure => link,
    target => "/etc/bind/db.${local_domain}.inv",
  }
  # File["/etc/bind/db.${local_domain}.inv"] -> File["/etc/bind/db.${local_domain}.inv"]

  file { ["/etc/bind/db.${local_domain}", "/etc/bind/db.${local_domain}.inv"]:
    group   => $bind_user,
    notify  => Service["bind9"],
    require => [ Package["bind9"], Group["$bind_user"] ],

  }

  File["/etc/bind/db.${local_domain}"] {
    content => template("bind/db.local_domain.erb"),
    backup => false,
  }

  File["/etc/bind/db.${local_domain}.inv"] {
    content => template("bind/db.local_domain.inv.erb"),
    backup => false,
  }

  #jeedom
#192.168.1.31
#omv
#192.168.1.28
#owncloud
#192.168.1.22
#pms
#192.168.1.30
#ovpn
#192.168.1.6


}