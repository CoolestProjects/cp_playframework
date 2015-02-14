name             'cp_playframework'
maintainer       'Noel King'
maintainer_email 'coolestprojects@coderdojo.com'
license          'MIT'
description      'Deploys Play Application'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.0.1'

depends 'cp_baseconfiguration'
depends 'cp_java'
depends 'zip'
depends 'simple_iptables'

supports 'centos'

recipe 'cp_playframework::default', 'Deploys Play Application on your Node'
