# TimeWillTell

Specialized conversions of dates and times to strings.

## Installation

Add `time_will_tell` to your Gemfile:

    gem 'time_will_tell'

### Install the default locale file

Run the generator to add the default locale file `time_will_tell.en.yml` to your `config/locales` directory:

    $ rails generate time_will_tell:install

## Usage

`time_will_tell` offers 2 view helpers for dealing with dates.

### exact_distance_of_time_in_words

The similarity with [`distance_of_time_in_words`](http://api.rubyonrails.org/classes/ActionView/Helpers/DateHelper.html#method-i-distance_of_time_in_words) is not a coincidence. Both methods share the a similar signature:

    exact_distance_of_time_in_words(from_time, to_time, options = {})

    # => '2 hours 33 minutes'
    # => '1 hour and a half'
    # => '3 years 11 months and 21 seconds'
    # => '1 month 15 days and 1 minute'
    # => '1 day 2 hours and a half and 5 seconds'
    # => 'half an hour'

#### Options

Displaying the seconds is optional and off by default. Use `include_seconds: true` to include them.

You can also supply your own locale by specifying a locale `scope`. The default is `time_will_tell.distance_in_words`.

#### Locales

You can either replace the default locale strings or copy the structure under a different scope to be able to toggle between a default version and an alternate one.

For example, the following scope would output

```
compact_distance_in_words:
  template: "%{count}%{unit}"
  template_long: "%{rest} %{last}"

  units:
    second: s
    minute: m
    hour: h
    day: d
    month: M
    year: Y

  special:
    half_an_hour: 30m
    and_a_half: 30m
```

    exact_distance_of_time_in_words(from_time, to_time, scope: 'compact_distance_in_words')
    # => '1d 2h 30m 5s'

### date_range

`date_range` simplifies displaying a date range in a brief format.

    # Oct 3 - 8, 2012
    # Jan 30 - Feb 5, 2013
    # Dec 26, 2012 - Jan 3, 2013

The output depends on whether the dates are on the same day, month and year.

#### Options

##### format

You can choose to display the full month names by specifying `format: :long`.

    date_range(from_date, to_date, format: :long)
    # January 30 - February 5, 2013

##### separator

You can choose a different separator if you don't like this guy `-`.

    date_range(from_date, to_date, separator: 'to')
    # Oct 3 to 8, 2012

##### show_year

Sometimes you don't want the year to show up in the date range.

    date_range(from_date, to_date, show_year: false)
    # Jan 30 - Feb 5

By default the year will always be shown. Also, if the dates are in different years, the years will be shown even if `show_year` is `false`.

#### Locales

Just as with `exact_distance_of_time_in_words` you can specify your own locale `scope`.

## Contributing

1. Fork it ( http://github.com/<my-github-username>/time_will_tell/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
