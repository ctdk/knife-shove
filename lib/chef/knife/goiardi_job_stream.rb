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
    class GoiardiJobStream < Chef::Knife
      deps do
	require 'chef/rest'
      end
      banner "knife goiardi job stream <job id> <node>"

      def run
	job_id = @name_args[0]
	if job_id.nil?
	  ui.error "No job id specified"
	  show_usage
	  exit 1
	end
	node_name = @name_args[1]
	if node_name.nil?
	  ui.error "No node specified"
	  show_usage
	  exit 1
	end
	outseq = 0
	errseq = 0
	outdone = false
	errdone = false
	loop do
	  if !outdone
	    outres = rest.get_rest("shovey/stream/#{job_id}/#{node_name}?sequence=#{outseq}&output_type=stdout")
	    if !outres["last_seq"].nil?
	      seq = outres["last_seq"] + 1
	    end
	    if outres["output"] != ""
	      stdout.print(outres["output"])
	    end
	    if outres["is_last"]
	      outdone = true
	    end
	  end
	  if !errdone
	    errres = rest.get_rest("shovey/stream/#{job_id}/#{node_name}?sequence=#{errseq}&output_type=stderr")
	    if !errres["last_seq"].nil?
	      seq = errres["last_seq"] + 1
	    end
	    if errres["output"] != ""
	      stderr.print(ui.color(errres["output"], :red))
	    end
	    if errres["is_last"]
	      errdone = true
	    end
	  end
	  break if outdone && errdone
	  sleep 0.25
	end
	ui.msg(ui.color("\nDone!", :blue))
	ui.pretty_print("\nFinished streaming output for job #{job_id} on node #{node_name}")
      end
    end
  end
end
