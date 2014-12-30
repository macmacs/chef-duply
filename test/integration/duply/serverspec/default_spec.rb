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
