require 'spec_helper'

describe TimeWillTell::Helpers::DateHelper do
  # A helper instance with the DateHelper module included
  let(:helper) do
    Class.new do
      include TimeWillTell::Helpers::DateHelper
    end.new
  end

  SECOND = 1
  MINUTE = 60 * SECOND
  HOUR   = 60 * MINUTE
  DAY    = 24 * HOUR
  MONTH  = 30 * DAY
  YEAR   = 365 * DAY

  describe '#exact_distance_of_time_in_words' do
    {
      [2 * HOUR + 33 * MINUTE + 44 * SECOND] => '2 hours 33 minutes',
      [1 * HOUR + 30 * MINUTE] => '1 hour and a half',
      [3 * YEAR + 11 * MONTH + 21 * SECOND, include_seconds: true] => '3 years 11 months and 21 seconds',
      [45 * DAY + 1 * MINUTE] => '1 month 15 days and 1 minute',
      [1 * DAY + 2 * HOUR + 30 * MINUTE + 5 * SECOND, include_seconds: true] => '1 day 2 hours and a half and 5 seconds',
      [30 * MINUTE] => 'half an hour',
    }.each do |args, expected|
      it "outputs '#{expected}'" do
        timespan = args[0]
        options  = args[1]

        from_time = Time.now
        to_time   = from_time + timespan

        expect(
          helper.exact_distance_of_time_in_words(*[from_time, to_time, options].compact)
        ).to eq expected
      end
    end

    it 'swaps from_time and to_time to get a positive timespan' do
      to_time = Time.now
      from_time = Time.now + (4 * DAY + 15 * MINUTE)

      expect(
        helper.exact_distance_of_time_in_words(from_time, to_time)
      ).to eq '4 days 15 minutes'
    end
  end
end
