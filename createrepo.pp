vcsrepo { 'C:/application/RSG':
  ensure   => present,
  provider => git,
  source   => 'https://github.com/swetakh/RSG/',
}