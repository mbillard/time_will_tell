require 'spec_helper'

describe TimeWillTell::Helpers::DateRangeHelper do
  # A helper instance with the DateRangeHelper module included
  let(:helper) do
    Class.new do
      include TimeWillTell::Helpers::DateRangeHelper
    end.new
  end

  describe '#date_range' do
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
          helper.date_range(*[from_date, to_date, options].compact)
        ).to eq expected
      end
    end

    it 'swaps from_date and to_date to get a positive range' do
      from_date = Date.new(2014, 3, 17)
      to_date   = Date.new(2000, 1, 1)

      expect(
        helper.date_range(from_date, to_date)
      ).to eq 'Jan 1, 2000 — Mar 17, 2014'
    end

    it 'accepts a custom separator' do
      from_date = Date.new(2013, 10, 31)
      to_date   = Date.new(2013, 12, 25)

      expect(
        helper.date_range(from_date, to_date, separator: '~')
      ).to eq 'Oct 31 ~ Dec 25, 2013'
    end
  end
end
