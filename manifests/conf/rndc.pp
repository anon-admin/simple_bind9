class bind::conf::rndc ($rndckey = $bind::rndckey
) inherits bind {


  exec { "dnssec-keygen -a HMAC-MD5 -b 512 -n USER ${rndckey}_rndc-key 1>./${rndckey}.keygen 2>&1":
    creates => "/etc/bind/${rndckey}.keygen",
    provider => shell,
    timeout => 0,
    cwd => "/etc/bind",
  }

  $command=join(["KEYGEN=$( cat /etc/bind/${rndckey}.keygen )",
    "SECRET=$( cat \${KEYGEN}.private | grep '^Key: ' | cut -f2 -d' ' )",
    join(
      ["cat /etc/bind/rndc.key",
        "sed \"s#secret \\\".*\\\"\\\;#secret\\\"\${SECRET}\\\";#\" ",
        "sed \"s#^key \\\".*\\\" {#key \\\"\${USER}_rndc-key\\\" {#\" >/etc/bind/${rndckey}_rndc-key"
      ], ' | ')], " ; ")

  exec { $command:
    creates => "/etc/bind/${rndckey}.keygen",
    provider => shell,
    timeout => 0,
    cwd => "/etc/bind",
    refreshonly => true,
  }

  Exec["dnssec-keygen -a HMAC-MD5 -b 512 -n USER ${rndckey}_rndc-key 1>./${rndckey}.keygen 2>&1"] ~> Exec[$command]
  Exec["dnssec-keygen -a HMAC-MD5 -b 512 -n USER ${rndckey}_rndc-key 1>./${rndckey}.keygen 2>&1"] -> Exec[$command]

  file {"/etc/bind/${rndckey}_rndc-key":
    owner   => root,
    group   => "${bind_user}",
    mode    => 640,
  }

  file {"/tmp/.${rndckey}_rndc-key":
    content => template("bind/rndc-key.erb"),
  }

  $rndckey_cp_command = "sed -n 's/^Key: \\(.*\\)/\\1/p' /etc/bind/$( cat /etc/bind/${rndckey}.keygen ).private >/tmp/.${rndckey}.secret ; SECRET=$( cat /tmp/.${rndckey}.secret ) ; sed \"s#CHANGE_ME#\${SECRET}#\" /tmp/.${rndckey}_rndc-key >/etc/bind/${rndckey}_rndc-key"
  exec {$rndckey_cp_command:
    cwd => "/etc/bind",
    provider => shell,
  }
  File["/tmp/.${rndckey}_rndc-key"] -> Exec[$rndckey_cp_command]
  Exec[$command] -> Exec[$rndckey_cp_command]

  Exec[$rndckey_cp_command]-> File["/etc/bind/${rndckey}_rndc-key"]

  File["/etc/bind/${rndckey}_rndc-key"] -> File["/etc/bind/named.conf"]
}