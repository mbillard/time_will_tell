require 'rails/railtie'
require 'time_will_tell/helpers/date_helper'
require 'time_will_tell/helpers/date_range_helper'

module TimeWillTell
  class Railtie < Rails::Railtie
    initializer "time_will_tell.helpers.date_helper" do
      ActionView::Base.send :include, TimeWillTell::Helpers::DateHelper
    end
    initializer "time_will_tell.helpers.date_range_helper" do
      ActionView::Base.send :include, TimeWillTell::Helpers::DateRangeHelper
    end
  end
end
