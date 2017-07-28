# @copyright Copyright 2014 Jeremy Bingham.
# Incorporates software Copyright 2014 Chef Software Inc. All Rights Reserved.
#
# This file is provided to you under the Apache License,
# Version 2.0 (the "License"); you may not use this file
# except in compliance with the License. You may obtain
# a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied. See the License for the
# specific language governing permissions and limitations
# under the License.
#

class Chef
  class Knife
    class GoiardiJobCancel < Chef::Knife
      deps do
        require 'chef/rest'
      end
      banner "knife goiardi job cancel <job id> [<node> <node> ...]"

      option :kill_timeout,
        :long => '--kill-timeout TIMEOUT',
        :description => "Amount of time to wait, in seconds, to stop a job before it's forcefully killed"

      def run
        job_id = @name_args[0]
        if job_id.nil?
          ui.error "No job id specified"
          show_usage
          exit 1
        end
        @node_names = name_args[1, name_args.length - 1]
        cancel_json = {
          'run_id' => job_id,
          'nodes' => @node_names
        }
        if config[:kill_timeout]
          cancel_json['kill_timeout'] = config[:kill_timeout]
        end
        result = rest.put_rest('shovey/jobs/cancel', cancel_json)
        # wait to figure out what to do with the reply until I've confirmed that
        # it works on the goiardi end
        cancel_output = {
          "command" => result["command"],
          "id" => result["id"],
          "status" => result["status"],
          "cancelled nodes" => result["nodes"]["cancelled"]
        }
        output(cancel_output)
      end

    end
  end
end
