#
# Cookbook Name:: nexus
# Provider:: hosted_repository
#
# Author:: Jonathan Morley (<jmorley@cvent.com>)
# Copyright 2015, Cvent Inc.
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

def load_current_resource
  @current_resource = Chef::Resource::NexusCapability.new(new_resource.name)

  run_context.include_recipe "nexus::cli"
  Chef::Nexus.ensure_nexus_available(node)

  @current_resource
end

action :create do
  begin
    Chef::Nexus.nexus(node).create_capability(new_resource.type, true, new_resource.properties)
  rescue NexusCli::CreateCapabilityException => e
    Chef::Log.info "Cannot create capability."
  end
end

action :delete do
  if capability_exists?(@current_resource.id)
    Chef::Nexus.nexus(node).delete_capability(new_resource.id)
  end
end

private

  def capability_exists?(id)
    begin
      Chef::Nexus.nexus(node).get_capability_info(id)
      true
    rescue NexusCli::CapabilityNotFoundException => e
      return false
    end
  end
