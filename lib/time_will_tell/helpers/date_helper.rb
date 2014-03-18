module TimeWillTell
  module Helpers
    module DateHelper

      DISTANCES_OF_TIME = [
        { unit: :year,   minutes_per_unit: 365*24*60 },
        { unit: :month,  minutes_per_unit: 30*24*60 },
        { unit: :day,    minutes_per_unit: 24*60 },
        { unit: :hour,   minutes_per_unit: 60 },
        { unit: :minute, minutes_per_unit: 1 }
      ].freeze

      def exact_distance_of_time_in_words(from_time, to_time, options = {})
        options = {
          scope: :'time_will_tell.distance_in_words'
        }.merge!(options)

        include_seconds = options.fetch(:include_seconds, false)

        from_time, to_time = to_time, from_time if from_time > to_time
        timespan = to_time - from_time
        distance_in_minutes = (timespan / 60.0).to_i

        distance_in_words = []

        I18n.with_options scope: options[:scope] do |locale|
          DISTANCES_OF_TIME.each do |distance_of_time|
            unit =             distance_of_time[:unit]
            minutes_per_unit = distance_of_time[:minutes_per_unit].to_f

            count = (distance_in_minutes / minutes_per_unit).to_i

            next if count == 0

            if count == 30 && unit == :minute
              if distance_in_words.empty?
                distance_in_words << locale.t(:half_an_hour)
              else
                distance_in_words << locale.t(:and_a_half)
              end
            else
              distance_in_words << pluralize(count, locale.t(unit))
            end

            distance_in_minutes -= count * minutes_per_unit
          end

          if include_seconds && (seconds_count = (timespan % 60).to_i) > 0
            distance_in_words << pluralize(seconds_count, locale.t(:second))
          end

          distance_in_words.insert(-2, locale.t(:and)) if distance_in_words.length > 2
          distance_in_words.join(' ')
        end
      end

      private

      # Simplified reimplementation of Rails' ActionView::Helpers::TextHelper::pluralize
      def pluralize(count, singular)
        word = count == 1 ? singular : singular.pluralize
        "#{count || 0} #{word}"
      end

    end
  end
end
