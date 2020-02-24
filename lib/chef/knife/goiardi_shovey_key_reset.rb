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
    class GoiardiShoveyKeyReset < Chef::Knife
      banner "knife goiardi shovey key reset [options]"

      option :yes,
        :short => '-y'
        :long => '--yes'
        :required => false,
        :boolean => true,
        :description => 'Skip confirmation of key regeneration'

      def run
        ui.info("WARNING: This will regenerate the keys goiardi uses to sign shovey requests. This is not a destructive operation, but be aware.")
        ui.confirm("Continue:")

        resp = rest.post_rest("shovey/key/reset")
        output(resp)
      end
    end
  end
end
