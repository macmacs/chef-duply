# Install the OS version.  Good enough for testing.
package 'duplicity python-boto' do
  action :install
end

include_recipe 'duply::default'
