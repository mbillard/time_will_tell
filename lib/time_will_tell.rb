require 'time_will_tell/version'

class TimeWillTell
  DISTANCES_OF_TIME = [
    { unit: 'year',   minutes_per_unit: 365*24*60 },
    { unit: 'month',  minutes_per_unit: 30*24*60 },
    { unit: 'day',    minutes_per_unit: 24*60 },
    { unit: 'hour',   minutes_per_unit: 60 },
    { unit: 'minute', minutes_per_unit: 1 }
  ].freeze

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
end
