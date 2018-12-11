class bind::conf::global ($bind_ip = $bind::bind_ip,
  $local_ip = $bind::local_ip,
  $rndckey = $bind::rndckey
) inherits bind {

  define check_bind_ip () {
    $bind_ip = $name

    include conf::network::install::ping_latest

    exec { "bind check ip ${bind_ip}":
      cwd      => "/tmp",
      command  => "/bin/ping -q -c1 ${bind_ip}",
      provider => shell,
    }
    Exec["bind check ip ${bind_ip}"] -> File["/etc/bind/named.conf"]
  }

  check_bind_ip { $bind_ip: }

  contain bind::conf::rndc

  File["/etc/bind/named.conf"] {
    content => template("bind/named.conf.erb"),
  }

  File["/etc/bind/named.conf.options"] -> File["/etc/bind/named.conf"]
}