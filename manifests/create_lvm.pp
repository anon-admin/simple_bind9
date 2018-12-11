class bind::create_lvm($vgname = "DATA") inherits storage {
  
  if $storage::bind {
    include bind

    $bind_lvname = $bind::bind_lvname
    $bind_lvsize = $bind::bind_lvsize
    $bind_lvfs = $bind::bind_lvfs
    $bind_mountpoint = $bind::bind_mountpoint

    storage::lvm::createlv { "${bind_lvname}":
      vgname     => $vgname,
      size       => "${bind_lvsize}",
      fstype     => "${bind_lvfs}",
      mountpoint => "${$bind_mountpoint}"
    }

    include bind::clean
  }

}
