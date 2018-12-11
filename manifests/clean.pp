class bind::clean($bind_mountpoint = $bind::bind_mountpoint) inherits bind {

  tidy { [ "/usr/tidy${bind_mountpoint}",
           "/usr/tidy/etc/bind",
     "/usr/tidy/var/lib/bind",
     "/usr/tidy/var/log/bind",
     "/usr/tidy/var/cache/bind" ]:
      recurse => true,
      backup  => false,
      age     => "4w",
      require => Mount["/usr/tidy"],
  }

  Mount["/etc/bind"] -> Tidy["/usr/tidy/etc/bind"]
  Mount["/var/lib/bind"] -> Tidy["/usr/tidy/var/lib/bind"]
  Mount["/var/log/bind"] -> Tidy["/usr/tidy/var/log/bind"]
  Mount["/var/cache/bind"] -> Tidy["/usr/tidy/var/cache/bind"]
}
