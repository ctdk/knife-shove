# Copyright 2020 Jeremy Bingham (<jeremy@goiardi.gl>)
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

class Chef
  class Knife
    class GoiardiShoveyKey < Chef::Knife
      banner "knife goiardi shovey key"

      def run
        key = rest.get_rest("shovey/key")
        # TODO: adjust a bit as needed to only print out the key, and not the
        # jsonified version
        output(key)
      end
    end
  end
end
