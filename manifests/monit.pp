class bind::monit inherits monit::minimal::config {
  
  monit::fullfill_service{ "bind9": 
    module => "bind",
  }
}