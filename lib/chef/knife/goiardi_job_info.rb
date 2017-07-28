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
    class GoiardiJobInfo < Chef::Knife
      deps do
	require 'chef/rest'
      end
      banner "knife goiardi job info <job id> <node>"

      def run
	job_id = @name_args[0]
	if job_id.nil?
	  ui.error "No job id specified"
	  show_usage
	  exit 1
	end
	node = @name_args[1]
	if node.nil?
	  ui.error "No node specified"
	  show_usage
	  exit 1
	end
	info = rest.get_rest("shovey/jobs/#{job_id}/#{node}")
	output(info)
      end
    end
  end
end
