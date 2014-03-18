module TimeWillTell
  module Helpers
    module DateRangeHelper
      SHORT_MONTH_NAMES = [nil, 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'].freeze
      LONG_MONTH_NAMES = [nil,
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December'
      ].freeze

      DATE_RANGES_TEMPLATES = {
        different_months_same_year: "%{from_month} %{from_day} %{sep} %{to_month} %{to_day}, %{year}",
        different_years: "%{from_month} %{from_day}, %{from_year} %{sep} %{to_month} %{to_day}, %{to_year}",
        same_month: "%{month} %{from_day} %{sep} %{to_day}, %{year}",
        same_date: "%{month} %{from_day}, %{year}"
      }.freeze

      def date_range(from_date, to_date, options = {})
        format    = options.fetch(:format, :short)
        separator = options.fetch(:separator, '—')

        month_names = format.to_sym == :short ? SHORT_MONTH_NAMES : LONG_MONTH_NAMES

        from_date, to_date = to_date, from_date if from_date > to_date
        from_day   = from_date.day
        from_month = month_names[from_date.month]
        from_year  = from_date.year
        to_day  = to_date.day

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

        date_range = DATE_RANGES_TEMPLATES[template].dup
        dates.each do |key, value|
          date_range.gsub!("%{#{key}}", value.to_s)
        end

        date_range
      end
    end
  end
end
