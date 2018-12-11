class bind::conf::options ($bind_ip = $bind::bind_ip, 
  $local_ip = $bind::local_ip, 
  $forwarders = $bind::forwarders
) inherits bind {
  define check_forwarder () {
    $forwarder = $name

    include conf::network::install::ping_latest

    exec { "bind check forwarder ${forwarder}":
      cwd      => "/tmp",
      command  => "/bin/ping -q -c1 ${forwarder}",
      provider => shell,
    }
    Exec["bind check forwarder ${forwarder}"] -> File["/etc/bind/named.conf.options"]
  }

  check_forwarder { $forwarders: }


  File["/etc/bind/named.conf.options"] {
    content => template("bind/named.conf.options.erb"), }
}