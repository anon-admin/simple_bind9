class bind::mounts (
  $bind_user   = $bind::bind_user,
  $bind_lvname = $bind::bind_lvname,
  $bind_vgname = $bind::bind_vgname,
  $bind_lvfs   = $bind::bind_lvfs,
  $bind_mountpoint   = $bind::bind_mountpoint) inherits bind {
    
  include bind::create_lvm
    
  file { "${bind_mountpoint}": ensure => directory, }

  mount { "${bind_mountpoint}":
    device  => "LABEL=${bind_vgname}-${bind_lvname}",
    fstype  => "${bind_lvfs}",
    options => "defaults",
    pass    => 2,
    atboot  => true,
    ensure  => mounted,
    require => File["${bind_mountpoint}"],
  }

  file { ["${bind_mountpoint}/etc", "${bind_mountpoint}/log", "${bind_mountpoint}/lib", "${bind_mountpoint}/cache"]:
    ensure  => directory,
    require => Mount["${bind_mountpoint}"],
  }



  mount { "/etc/bind":
    device  => "${bind_mountpoint}/etc",
    require => [File["/etc/bind"], Mount["${bind_mountpoint}"]],
  }

  mount { "/var/lib/bind":
    device  => "${bind_mountpoint}/lib",
    require => [File["/var/lib/bind"], Mount["${bind_mountpoint}"]],
  }

  mount { "/var/log/bind":
    device  => "${bind_mountpoint}/log",
    require => [File["/var/log/bind"], Mount["${bind_mountpoint}"]],
  }

  mount { "/var/cache/bind":
    device  => "${bind_mountpoint}/cache",
    require => [File["/var/cache/bind"], Mount["${bind_mountpoint}"]],
  }

  Mount[
    "/etc/bind", "/var/lib/bind", "/var/log/bind", "/var/cache/bind"] {
    fstype  => none,
    options => "bind,rw",
    before  => Package["bind9"],
    atboot  => true,
    ensure  => mounted,
    notify  => Service["bind9"],
  }

  include bind::clean
}
