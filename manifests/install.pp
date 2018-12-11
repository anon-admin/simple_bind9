class bind::install {

  include apt_source_list
  
  package { "bind9":
  }
  
  
}