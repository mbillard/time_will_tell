require 'time_will_tell/version'

class TimeWillTell
  DISTANCES_OF_TIME = [
    { unit: 'year',   minutes_per_unit: 365*24*60 },
    { unit: 'month',  minutes_per_unit: 30*24*60 },
    { unit: 'day',    minutes_per_unit: 24*60 },
    { unit: 'hour',   minutes_per_unit: 60 },
    { unit: 'minute', minutes_per_unit: 1 }
  ].freeze

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

  def self.exact_distance_of_time_in_words(from_time, to_time, options = {})
    include_seconds         = options.fetch(:include_seconds, false)

    from_time, to_time = to_time, from_time if from_time > to_time
    timespan = to_time - from_time
    distance_in_minutes = (timespan / 60.0).to_i

    distance_in_words = []

    DISTANCES_OF_TIME.each do |distance_of_time|
      unit =             distance_of_time[:unit]
      minutes_per_unit = distance_of_time[:minutes_per_unit].to_f

      count = (distance_in_minutes / minutes_per_unit).to_i

      next if count == 0

      if count == 30 && unit == 'minute'
        if distance_in_words.empty?
          distance_in_words << 'half an hour'
        else
          distance_in_words << 'and a half'
        end
      else
        distance_in_words << "#{count} #{unit}#{'s' if count > 1}"
      end

      distance_in_minutes -= count * minutes_per_unit
    end

    if include_seconds && (seconds_count = (timespan % 60).to_i) > 0
      distance_in_words << "#{seconds_count} second#{'s' if seconds_count > 1}"
    end

    distance_in_words.insert(-2, 'and') if distance_in_words.length > 2
    distance_in_words.join(' ')
  end

  def self.date_range(from_date, to_date, options = {})
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
