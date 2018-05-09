file { 'C:\Program Files\Rightslogic':
  ensure => 'directory'
}

file { 'C:\Program Files\Rightslogic\v3.x':
  ensure => 'directory'
}
file { 'C:\Program Files\Rightslogic\v3.x\Web':
  ensure => 'directory'
}
file { 'c:\\RMSDOC':
  ensure => 'directory'
}


# Configure IIS

iis_application_pool { 'RL3.xWeb':
  ensure                  => 'present',
  state                   => 'started',
  managed_pipeline_mode   => 'Classic',
  enable32_bit_app_on_win64 => true,
  managed_runtime_version => 'v4.0',
}


iis_site { 'RightsLogicWeb':
  ensure           => 'started',
  physicalpath     => 'C:\Program Files\Rightslogic\v3.x\Web',
  applicationpool  => 'RL3.xWeb',
  enabledprotocols => 'https',
  logpath           => 'C:\\RMSDOC',
  bindings         => [
    {
      'bindinginformation'   => '*:82:insecure.website.com',
      'protocol'             => 'http',
    },
  ],
  
  require => File['C:\Program Files\Rightslogic\v3.x\Web'],
}

iis_virtual_directory { 'RMSDOC':
  ensure       => 'present',
  sitename     => 'RightsLogicWeb',
  physicalpath => 'C:\\RMSDOC',
}


