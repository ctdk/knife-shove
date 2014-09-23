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

require 'chef/rest'

def run_list_command
  cmd = "knife goiardi job list -c test/support/knife.rb"
  puts `#{cmd}`
  raise "ERROR: #{cmd} failed" unless $? == 0
end

def run_start_command(jcmd, args="")
  cmd = "knife goiardi job start #{jcmd} #{args} -c test/support/knife.rb"
  puts `#{cmd}`
  raise "ERROR: #{cmd} failed" unless $? == 0
end

def make_rest
  return Chef::REST.new("http://localhost:4646", "admin", "/tmp/schob-goiardi/admin.pem")
end

describe "job list" do
  it "lists jobs" do
    run_list_command
  end
end


describe "job start" do
  it "starts a job" do
    run_start_command("ls", "foobar.local")
  end
  it "starts a job and returns" do
    run_start_command("ls", "foobar.local -b")
  end
  it "returns a job id" do
    rest = make_rest
    job_json = {
      'command' => "ls",
      'nodes' => [ "foobar.local" ],
      'quorum' => "100%"
    }
    result = rest.post_rest('shovey/jobs', job_json)
    raise "ERROR: no id returned" if result["id"].nil?
  end
  it "gets status on a job" do
    rest = make_rest
    job_json = {
      'command' => "ls",
      'nodes' => [ "foobar.local" ],
      'quorum' => "100%"
    }
    result = rest.post_rest('shovey/jobs', job_json)
    `knife goiardi job status #{result["id"]} -c test/support/knife.rb`
    raise "ERROR: failed to get status on job" unless $? == 0
  end
  it "gets info on a job" do
    rest = make_rest
    job_json = {
      'command' => "ls",
      'nodes' => [ "foobar.local" ],
      'quorum' => "100%"
    }
    result = rest.post_rest('shovey/jobs', job_json)
    `knife goiardi job info #{result["id"]} foobar.local -c test/support/knife.rb`
    raise "ERROR: failed to get status on job" unless $? == 0
  end
  it "streams a job" do
    rest = make_rest
    job_json = {
      'command' => "ls",
      'nodes' => [ "foobar.local" ],
      'quorum' => "100%"
    }
    result = rest.post_rest('shovey/jobs', job_json)
    `knife goiardi job stream #{result["id"]} foobar.local -c test/support/knife.rb`
    raise "ERROR: failed to stream output on job" unless $? == 0
  end
  it "cancels a job" do
    rest = make_rest
    job_json = {
      'command' => "sleepy",
      'nodes' => [ "foobar.local" ],
      'quorum' => "100%"
    }
    result = rest.post_rest('shovey/jobs', job_json)
    `knife goiardi job cancel #{result["id"]} foobar.local -c test/support/knife.rb`
    raise "ERROR: failed to cancel job" unless $? == 0
  end
  
end
