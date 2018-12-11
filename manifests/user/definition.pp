class bind::user::definition ($bind_user = $bind::bind_user, $bind_id = $bind::bind_id) inherits bind {
  exec { [
    "/usr/local/bin/gidmod.sh ${bind_id} ${bind_user}",
    "/usr/local/bin/uidmod.sh ${bind_id} ${bind_user}"]: require => Mount["/usr/local/bin"], }

  group { "${bind_user}":
    ensure  => present,
    gid     => "${bind_id}",
    require => Exec["/usr/local/bin/gidmod.sh ${bind_id} ${bind_user}"],
    before  => Package["bind9"],
  }

  user { "${bind_user}":
    ensure  => present,
    uid     => "${bind_id}",
    gid     => "${bind_user}",
    require => [Exec["/usr/local/bin/uidmod.sh ${bind_id} ${bind_user}"], Group["${bind_user}"]],
    before  => [Package["bind9"], Service["bind9"]],
  }

}
