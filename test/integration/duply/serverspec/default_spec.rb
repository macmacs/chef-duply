require 'spec_helper'

# Ensure duplicity profile exists
describe file('/etc/duply/test') do
  it { should be_directory }
end

describe file('/etc/duply/test/conf') do
  it { should be_file }
end

# Check backup files
describe file('/var/testing/run') do
  it { should be_directory }
end

# Check restore
describe file('/var/testing/restore_test/etc/duply/test/conf') do
  it { should be_file }
end

# Check conf written for Swift backend
# Also check if not used asymetric GPG options are missing
describe file('/etc/duply/swift/conf') do
  # TODO: add content verification
  it { should be_file }
  it { should contain 'SWIFT_USERNAME=\'swift_user123\'' }
  it { should contain 'SWIFT_TENANT=\'swift_tenant123\'' }
  it { should contain 'SWIFT_PASSWORD=\'swift_password123\'' }
  it { should contain 'SWIFT_AUTHURL=\'https:/swift.example.com:5000/v2.0\'' }
  it { should contain 'GPG_PW=\'swiftsecret\'' }
  it { should_not contain 'GPG_KEY_SIGN' }
  it { should_not contain 'GPG_PW_SIGN' }
end
