class bind::conf::log (
) inherits bind {


  File["/etc/bind/named.conf.log"] {
    content => template("bind/named.conf.log.erb"), }
}