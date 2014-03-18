require 'rails/railtie'
require 'time_will_tell'

I18n.load_path += Dir[ File.join(File.dirname(__FILE__), '../lib/generators/time_will_tell/templates/config/locales/*.yml') ]
I18n.default_locale = :en

# Require this file using `require 'spec_helper'` to ensure that it is only
# loaded once.
#
# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
end
