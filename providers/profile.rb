#
# Cookbook Name:: duply
# Provider:: profile
#
# Copyright (C) 2014 Nephila Graphic
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#


action :delete do
  directory "#{node['duply']['dir']}/#{new_resource.name}" do
    action :delete
  end
end

action :create do
  directory "#{node['duply']['dir']}/#{new_resource.name}" do
    user    "root"
    group   "root"
    mode    0700
    action :create
  end

  tconf = template "#{node['duply']['dir']}/#{new_resource.name}/conf" do
    cookbook  new_resource.cookbook
    source    new_resource.template
    owner     "root"
    group     "root"
    mode      0600
    variables(
        :gpg_keys_enc => [ new_resource.encrypt_for ].flatten,
        :gpg_key_sign => new_resource.signed_by,
        :gpg_pw_sign => new_resource.passphrase,
        :target => new_resource.destination,
        :max_age => new_resource.max_age,
        :max_full_backups => new_resource.keep_full,
        :max_fullbkp_age => new_resource.full_every,
        :volsize => new_resource.volume_size,
        :temp_dir => new_resource.temp_dir
    )
    action :create
  end

  texclude = template "#{node['duply']['dir']}/#{new_resource.name}/exclude" do
    cookbook  'duply'
    source    'exclude.erb'
    owner     "root"
    group     "root"
    mode      0600
    variables(
    )
    action :create
  end

  new_resource.updated_by_last_action(tconf.updated_by_last_action? ||
                                      texclude.updated_by_last_action?)
end