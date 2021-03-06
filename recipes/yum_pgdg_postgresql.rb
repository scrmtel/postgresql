# frozen_string_literal: true
#
# Cookbook:: postgresql
# Recipe::yum_pgdg_postgresql
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

######################################
# Install the "PostgreSQL RPM Building Project - Yum Repository"

rpm_platform = node['platform']
rpm_platform_version = node['platform_version'].to_f.to_i.to_s
arch = node['kernel']['machine']
pg_version = node['postgresql']['version']
pgdg_setup = node['postgresql']['pgdg']['repo_rpm_url'][pg_version][rpm_platform][rpm_platform_version][arch]
pgdg_package = pgdg_setup['package']
pgdg_repository = pgdg_setup['url']

# Download the PGDG repository RPM as a local file
remote_file "#{Chef::Config[:file_cache_path]}/#{pgdg_package}" do
  source "#{pgdg_repository}#{pgdg_package}"
  mode '0644'
end

# Install the PGDG repository RPM from the local file
package pgdg_package.to_s do
  provider Chef::Provider::Package::Rpm
  source "#{Chef::Config[:file_cache_path]}/#{pgdg_package}"
  action :install
end
