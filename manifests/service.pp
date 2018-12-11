class bind::service ($bind_user = $bind::bind_user) inherits bind {
  contain bind::config

  Service["bind9"] {
    ensure  => running,
    enable  => true,
    require => [
      File[
        "/etc/bind/named.conf.options", "/etc/bind/named.conf.local", "/etc/bind/named.conf.default-zones"],

      User["${bind_user}"]],
  }

  include storage
  if $storage::bind {
    Mount[
  "/etc/bind", "/var/lib/bind", "/var/log/bind", "/var/cache/bind"] -> Service["bind9"]
  }

  include bind::monit
  Service["bind9"] -> File["/etc/monit/conf.d/bind9"]

}