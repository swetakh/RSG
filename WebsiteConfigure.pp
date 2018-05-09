file {['C:\RMSDOC', 'C:\RMSDOC\Documents', 'C:\Program Files\Rightslogic', 'C:\Program Files\Rightslogic\v3.x', 'C:\Program Files\Rightslogic\v3.x\Web']:
    ensure        => 'directory',
}


# Configure IIS

iis_application_pool { 'RL3.xWeb ':
  ensure                  => 'present',
  state                   => 'started',
  managed_pipeline_mode   => 'Classic',
  enable32_bit_app_on_win64 => true,
  managed_runtime_version => 'v4.0',
}


iis_site { 'Default Web Sites ':
  ensure           => 'started',
  physicalpath     => 'C:\Program Files\Rightslogic\v3.x\Web',
  applicationpool  => 'RL3.xWeb',
  enabledprotocols => 'https',
  logpath           => 'C:\\rmsdoc',
  bindings         => [
    {
      'bindinginformation'   => '*:80:insecure.website.com',
      'protocol'             => 'http',
    },
  ],
  
  require => File['C:\Program Files\Rightslogic\v3.x\Web'],
}

iis_virtual_directory { 'RMSDOC':
  ensure       => 'present',
  sitename     => 'Default Web Sites ',
  physicalpath => 'C:\\RMSDOC',
}


