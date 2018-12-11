class bind::logrotate {

  file { "/etc/logrotate.d/bind9":
    require => Package["logrotate","bind9"],
    notify  => Service["rsyslog"],
    source  => "puppet:///modules/bind/logrotate_bind9",
  }

}