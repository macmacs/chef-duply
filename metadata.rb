name 'duply'
maintainer 'Max Roth'
maintainer_email 'chef@macmacs.com'
license 'All rights reserved'
description 'Installs/Configures duply'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.3.2'
source_url 'https://github.com/datacoda/chef-duply'
issues_url 'https://github.com/datacoda/chef-duply/issues'

%w(ubuntu debian).each do |os|
  supports os
end
