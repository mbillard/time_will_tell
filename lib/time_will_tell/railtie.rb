require 'rails/railtie'
require 'time_will_tell/helpers/date_helper'
require 'time_will_tell/helpers/date_range_helper'

module TimeWillTell
  class Railtie < Rails::Railtie
    config.eager_load_namespaces << TimeWillTell::Helpers::DateHelper
    config.eager_load_namespaces << TimeWillTell::Helpers::DateRangeHelper
  end
end
