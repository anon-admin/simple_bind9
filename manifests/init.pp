# Class: bind
#
# This module manages bind
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class bind($bind_ip,
  $forwarders,
  $local_domain,
  $searches,
  $bind_lvname,
  $bind_vgname,
  $bind_lvsize,
  $bind_lvfs,
  $bind_mountpoint,
  $external_domain
) inherits bind::install {
  
  $local_ip = "127.0.0.1"
  $bind_port = "53"

  $ns_hostname = "${hostname}"
  $ns_fqdn = "${ns_hostname}.${local_domain}"
  $rndckey = regsubst($ns_fqdn, '\.', '-', 'G')

  include userids
  $bind_user = $userids::bind_user
  $bind_id = $userids::bind_id

  # $bind_lvname = 'bind'
  # $bind_vgname = 'DATA'
  # $bind_lvsize = '100M'
  # $bind_lvfs = 'ext4'
  # $bind_mountpoint = "/var/bind"
  
  file { ["/etc/bind", "/var/lib/bind",  "/var/log/bind", "/var/cache/bind"]: }

  File["/etc/bind"] {
    owner  => root,
  }

  file { ["/etc/bind/named.conf", "/etc/bind/named.conf.options", "/etc/bind/named.conf.local", "/etc/bind/named.conf.default-zones", "/etc/bind/named.conf.log"]:
    owner => root,
    mode  => 644,
  }

  file { "/etc/default/bind9": }

  service { "bind9": }
}

#   40  apt-get install bind9
#   41  cat /etc/passwd
#   42  cd /etc/bind/
#   43  ls -alrt /var/log
#   44  ls
#   45  cat named.conf
#   46  cat "/etc/bind/named.conf.options"
#   47  cat "/etc/bind/named.conf.local"
#   48  cat "/etc/bind/named.conf.default-zones"
#   49  ls -al
#   50  emacs named.conf.options
#   51  cat /etc/resolv.conf
#   52  emacs named.conf.options
#   53  cat rndc.key
#   54  emacs named.conf.local
#   55  cp rndc.key ns-ppprod-net_rndc-key
#   56  dnssec-keygen -a HMAC-MD5 -b 512 -n USER ns-ppprod-net_rndc-key Kns-ppprod-net_rndc-key.+157+53334
#   57  dnssec-keygen -a HMAC-MD5 -b 512 -n USER ns-ppprod-net_rndc-key
#   58  ls -alrt
#   59  cat Kns-ppprod-net_rndc-key.+157+30410.private
#   60  emacs ns-ppprod-net_rndc-key
#   61  ifconfig
#   62  emacs ns-ppprod-net_rndc-key
#   63  emacs named.conf.options
#   64  dnssec-keygen -a HMAC-MD5 -b 128 -r /dev/urandom -n USER DDNS_UPDATE
#   65  ls -al
#   66  emacs ddns.key
#   67  cp db.empty /var/lib/db.ppprod.net
#   68  cp db.empty /var/lib/db.ppprod.net.inv
#   69  emacs /var/lib/db.ppprod.net
#   70  ls
#   71  cd /var/lib/
#   72  ls
#   73  mv db.ppprod.net* /etc/bind/
#   74  cd bind/
#   75  ln -s /etc/bind/db.ppprod.net
#   76  ln -s /etc/bind/db.ppprod.net.inv
#   77  service bind9 start
#   78  cd /etc/bind/
#   79  emacs named.conf.log
#   80  service bind9 start
#   81  emacs /etc/resolv.conf
#   82  vi /etc/resolv.conf
#   83  emacs /etc/hosts
#   84  ping experience
#   85  dig experience
#   86  ls -al
#   87  find . -name '*~'
#   88  find . -name '*~' -delete
#   89  ls
#   90  ls -al
#   91  ping experience.dyndns-at-home.com
#   92  ls -al
#   93  su - puppetadmin
