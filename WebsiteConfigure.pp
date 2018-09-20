file { 'C:\Program Files\Rightslogic':
  ensure => 'directory'
}

file { 'C:\Program Files\Rightslogic\v3.x':
  ensure => 'directory'
}
file { 'C:\Program Files\Rightslogic\v3.x\Web':
  ensure => 'directory'
}
file { 'C:\Program Files\Rightslogic\v3.x\ReportBuilder11-SP5_RL3.x':
  ensure => 'directory'
}
file { 'c:\\RMSDOC':
  ensure => 'directory'
}



# Configure IIS

iis_application_pool { 'ReportBuilder11Pool':
  ensure                  => 'present',
  state                   => 'started',
  managed_pipeline_mode   => 'Classic',
  enable32_bit_app_on_win64 => true,
  managed_runtime_version => 'v4.0',
}

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

iis_site { 'ReportBuilder11-SP5_RL3.x':
  ensure           => 'started',
  physicalpath     => 'D:\ReportBuilder11-SP5_RL3.x',
  applicationpool  => 'ReportBuilder11Pool',
  enabledprotocols => 'https',
  bindings         => [
    {
      'bindinginformation'   => '*:90:insecure.website.com',
      'protocol'             => 'http',
    },
  ],
  
  require => File['D:\ReportBuilder11-SP5_RL3.x'],
}

iis_virtual_directory { 'RMSDOC':
  ensure       => 'present',
  sitename     => 'RightsLogicWeb',
  physicalpath => 'C:\\RMSDOC',
}

user { 'appdev':
     ensure           => 'present',
       groups              => ['Users', 'Administrators'],
       comment             => 'appdev',
       password         => 'Temporary.1',
     managehome   => true,
       
     }

user { 'admin':
     ensure           => 'present',
       groups              => ['Users', 'Administrators'],
       comment             => 'admin',
       password         => 'Kettlepins.9',
     managehome   => true,
       
     }
net_share {'RMSDOC':
    ensure        => present,
    path          => 'c:\RMSDOC',
    remark        => 'RMSDOC',
    maximumusers  => unlimited,
  cache         => manual,
  permissions   => ["\appdev,full"],
    
}