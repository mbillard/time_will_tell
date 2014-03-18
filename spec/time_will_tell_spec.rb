require 'spec_helper'

describe TimeWillTell do
  SECOND = 1
  MINUTE = 60 * SECOND
  HOUR   = 60 * MINUTE
  DAY    = 24 * HOUR
  MONTH  = 30 * DAY
  YEAR   = 365 * DAY

  subject { TimeWillTell }

  describe '.exact_distance_of_time_in_words' do
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
          subject.exact_distance_of_time_in_words(*[from_time, to_time, options].compact)
        ).to eq expected
      end
    end

    it 'swaps from_time and to_time to get a positive timespan' do
      to_time = Time.now
      from_time = Time.now + (4 * DAY + 15 * MINUTE)

      expect(
        subject.exact_distance_of_time_in_words(from_time, to_time)
      ).to eq '4 days 15 minutes'
    end
  end

  describe '.date_range' do
    {
      # short form
      [Date.new(2012, 10, 3), Date.new(2012, 10, 8)] => 'Oct 3 — 8, 2012',
      [Date.new(2013, 1, 30), Date.new(2013, 2, 5)] => 'Jan 30 — Feb 5, 2013',
      [Date.new(2012, 12, 26), Date.new(2013, 1, 3)] => 'Dec 26, 2012 — Jan 3, 2013',
      [Date.new(2013, 8, 24), Date.new(2013, 8, 24)] => 'Aug 24, 2013',
      [Date.new(2014, 2, 10), Date.new(2015, 2, 10)] => 'Feb 10, 2014 — Feb 10, 2015',

      # long form
      [Date.new(2012, 10, 3), Date.new(2012, 10, 8), format: :long] => 'October 3 — 8, 2012',
      [Date.new(2013, 1, 30), Date.new(2013, 2, 5), format: :long] => 'January 30 — February 5, 2013',
      [Date.new(2012, 12, 26), Date.new(2013, 1, 3), format: :long] => 'December 26, 2012 — January 3, 2013',
      [Date.new(2013, 8, 24), Date.new(2013, 8, 24), format: :long] => 'August 24, 2013',
      [Date.new(2014, 2, 10), Date.new(2015, 2, 10), format: :long] => 'February 10, 2014 — February 10, 2015',
    }.each do |args, expected|
      it "outputs '#{expected}" do
        from_date = args[0]
        to_date   = args[1]
        options   = args[2]

        expect(
          subject.date_range(*[from_date, to_date, options].compact)
        ).to eq expected
      end
    end

    it 'swaps from_date and to_date to get a positive range' do
      from_date = Date.new(2014, 3, 17)
      to_date   = Date.new(2000, 1, 1)

      expect(
        subject.date_range(from_date, to_date)
      ).to eq 'Jan 1, 2000 — Mar 17, 2014'
    end

    it 'accepts a custom separator' do
      from_date = Date.new(2013, 10, 31)
      to_date   = Date.new(2013, 12, 25)

      expect(
        subject.date_range(from_date, to_date, separator: '~')
      ).to eq 'Oct 31 ~ Dec 25, 2013'
    end
  end
end
