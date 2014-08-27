module TimeWillTell
  module Helpers
    module DateRangeHelper

      def date_range(from_date, to_date, options = {})
        format    = options.fetch(:format, :short)
        scope     = options.fetch(:scope, 'time_will_tell.date_range')
        separator = options.fetch(:separator, '—')
        show_year = options.fetch(:show_year, true)

        month_names = format.to_sym == :short ? I18n.t("date.abbr_month_names") : I18n.t("date.month_names")

        from_date, to_date = to_date, from_date if from_date > to_date
        from_day   = from_date.day
        from_month = month_names[from_date.month]
        from_year  = from_date.year
        to_day     = to_date.day

        dates = { from_day: from_day, sep: separator }

        if from_date == to_date
          template = :same_date
          dates.merge!(month: from_month, year: from_year)
        elsif from_date.month == to_date.month && from_date.year == to_date.year
          template = :same_month
          dates.merge!(to_day: to_day, month: from_month, year: from_year)
        else
          to_month = month_names[to_date.month]

          dates.merge!(from_month: from_month, to_month: to_month, to_day: to_day)

          if from_date.year == to_date.year
            template = :different_months_same_year
            dates.merge!(year: from_year)
          else
            to_year = to_date.year

            template = :different_years
            dates.merge!(from_year: from_year, to_year: to_year)
          end
        end

        without_year = I18n.t("#{scope}.#{template}", dates)

        if show_year && from_date.year == to_date.year
          I18n.t("#{scope}.with_year", date_range: without_year, year: from_year)
        else
          without_year
        end
      end

    end
  end
end
