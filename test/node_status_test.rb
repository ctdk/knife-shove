#
# Author:: Jeremy Bingham (<jbingham@gmail.com>)
# Copyright:: Copyright (c) 2014 Jeremy Bingham
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
#####
#
# These tests are inspired by the knife-rightscale tests found in
# https://github.com/caryp/knife-rightscale
#
#####

def run_status_command
  cmd = "knife goiardi node status -c test/support/knife.rb"
  puts `#{cmd}`
  raise "ERROR: #{cmd} failed" unless $? == 0
end

describe "node status" do
  it "lists node statuses" do
    run_status_command
  end
end
