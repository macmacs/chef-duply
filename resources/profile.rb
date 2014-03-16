#
# Cookbook Name:: duply
# Resource:: profile
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

actions :create, :delete

attribute :name,              :kind_of => String, :name_attribute => true

attribute :destination,       :kind_of => String, :required => true
attribute :includes,          :kind_of => Array, :default => [ ]
attribute :excludes,          :kind_of => Array, :default => [ ]

attribute :max_age,           :kind_of => String, :default => '1M'

attribute :keep_full,         :kind_of => [Integer, NilClass]
attribute :full_every,        :kind_of => [String, NilClass]

attribute :encrypt_for,       :kind_of => [String, Array],  :required => true
attribute :signed_by,         :kind_of => String, :required => true
attribute :passphrase,        :kind_of => String, :required => true
attribute :compression,       :kind_of => Symbol, :equal_to => [:bzip2, :incremental], :default => :none
attribute :volume_size,       :kind_of => Integer, :default => 25
attribute :temp_dir,          :kind_of => String, :default => '/tmp'

attribute :template,          :kind_of => String, :default => 'conf.erb'
attribute :cookbook,          :kind_of => String, :default => 'duply'

def initialize(*args)
  super
  @action = :create
end
