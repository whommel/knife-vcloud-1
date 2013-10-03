#
# Author:: Stefano Tortarolo (<stefano.tortarolo@gmail.com>)
# Copyright:: Copyright (c) 2013
# License:: Apache License, Version 2.0
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

class Chef
  class Knife
    class VcVappReboot < Chef::Knife
      include Knife::VcCommon
      include Knife::VcVappCommon

      banner "knife vc vapp reboot [VAPP] (options)"

      option :org_name,
             :long => "--org ORG_NAME",
             :description => "Organization to whom vApp's VDC belongs",
             :proc => Proc.new { |key| Chef::Config[:knife][:default_org_name] = key }

      option :vdc_name,
             :long => "--vdc VDC_NAME",
             :description => "VDC to whom vApp belongs",
             :proc => Proc.new { |key| Chef::Config[:knife][:default_vdc_name] = key }

      def run
        $stdout.sync = true

        vapp_arg = @name_args.shift

        connection.login
        vapp = get_vapp(vapp_arg)

        task_id = connection.reboot_vapp vapp[:id]

        ui.msg "vApp reboot..."
        wait_task(connection, task_id)

        connection.logout
      end
    end
  end
end