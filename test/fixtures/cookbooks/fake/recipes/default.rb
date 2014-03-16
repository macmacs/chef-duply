require 'systemu'

# Needed otherwise GPG just won't have enough entropy
package 'haveged' do
  action :install
end


gpg_home = '/root/.gnupg'
keys = Hash.new
keys['alice'] = {
    :keyfile => 'alice.pub',
    :key_id => 'DBD8962C',
    :passphrase => 'alicesecret',
    :fingerprint => '14447E6957AC4C75065C9CEFCE7B21DCDBD8962C'
}

keys['bob'] = {
    :keyfile => 'bob.pub',
    :key_id => '5A250D54',
    :passphrase => 'bobsecret',
    :fingerprint => 'EBF515F2EB6542505235C2134390D06A5A250D54'
}

keys['server'] = {
    :keyfile => 'server.key',
    :key_id => '41AB2B65',
    :passphrase => 'serversecret',
    :fingerprint => 'DEBA80E2924424EFD240630B362AC8FF41AB2B65'
}

directory gpg_home do
  owner 'root'
  group 'root'
  mode 0700
  action :create
end

key_tmpdir = "#{Chef::Config['file_cache_path'] || '/tmp'}/gpg_keys"
directory key_tmpdir do
  action :create
end

# Import the test public/private keys

keys.each do |name,key|

  cookbook_file key[:keyfile] do
    path "#{key_tmpdir}/#{key[:keyfile]}"
    sensitive true
    action :create
    not_if "gpg --homedir #{gpg_home} --list-keys #{key[:key_id]} | grep #{key[:key_id]}"
  end

  execute "key_#{name}_import" do
    command "gpg --homedir #{gpg_home} --import #{key_tmpdir}/#{key[:keyfile]}"
    not_if "gpg --homedir #{gpg_home} --list-keys #{key[:key_id]} | grep #{key[:key_id]}"
  end

  ruby_block "key_#{name}_trust" do
    block do
      status = systemu(
          "gpg --homedir #{gpg_home} --import-ownertrust",
          0 => "#{key[:fingerprint]}:6:\n",
          1 => stdout = '',
          2 => stderr = ''
      )
      if status != 0
        Chef::Log.error("duply: #{stdout} #{stderr}")
      end
    end
  end

end


# Install the OS version.  Good enough for testing.
package 'duplicity python-boto' do
  action :install
end

include_recipe 'duply::default'


duply_profile "test" do
  destination "file:///var/backups/test"
  encrypt_for [ keys['server'][:key_id], keys['alice'][:key_id], keys['bob'][:key_id] ]
  signed_by   keys['server'][:key_id]
  passphrase  keys['server'][:passphrase]
  compression :bzip2
  volume_size 50
  keep_full   5
  full_every  '2M'
  includes [
      '/etc/duply'
           ]
  excludes [
      '**.asc'
           ]
end


# Test commands

directory "/var/backups/test" do
  action :delete
  recursive true
end


duply "test" do
  profile "test"
  action :backup
end

duply "test-incr" do
  profile "test"
  action :incremental
end


duply "test-full" do
  profile "test"
  action :full
end


duply "test-incr-auto" do
  profile "test"
  action :backup
end

# Restoration Tests
restore_dir = "/var/backups/restore_test"

directory restore_dir do
  action :delete
  recursive true
end

duply "test-restore" do
  profile "test"
  destination restore_dir
  action :restore
end