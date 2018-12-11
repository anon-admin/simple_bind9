class bind::resolv(
  $domain = $bind::local_domain,
  $searches = $bind::searches,
  $nameserver = $bind::local_ip
) inherits conf::network::config::resolv {
  contain conf::network::resolv

  File["/etc/resolv.conf"] {
    content => template("bind/resolv.conf.erb"),
  }

}