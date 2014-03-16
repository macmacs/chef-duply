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

require "chef/mixin/command"


action :nothing do
end

action :backup do
  r = execute "duply_backup_#{new_resource.profile}" do
    command "/usr/bin/duply #{new_resource.profile} backup"
    user "root"
  end
  new_resource.updated_by_last_action(r.updated_by_last_action?)
end

action :full do
  r = execute "duply_full_#{new_resource.profile}" do
    command "/usr/bin/duply #{new_resource.profile} full"
  end
  new_resource.updated_by_last_action(r.updated_by_last_action?)
end


action :incremental do
  r = execute "duply_incr_#{new_resource.profile}" do
    command "/usr/bin/duply #{new_resource.profile} incr"
  end
  new_resource.updated_by_last_action(r.updated_by_last_action?)
end


action :restore do
  r = execute "duply_restore_#{new_resource.profile}" do
    command "/usr/bin/duply #{new_resource.profile} restore #{new_resource.destination}"
  end
  new_resource.updated_by_last_action(r.updated_by_last_action?)
end
