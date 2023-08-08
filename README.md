# Evergreen

A gem for interacting with [Evergreen ILS](https://evergreen-ils.org)

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add evergreen-ils

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install evergreen-ils

## Usage

### Configuration

Configure your `Evergreen` object with a hostname, and any other relevant
options.  If using Rails, you might create an Evergreen service:

```
class EvergreenService
  attr_reader :evergreen
  def initialize
    @evergreen ||= Evergreen.new do |config|
      config.host = 'my.evergreen.server'
      config.default_username = 'user1'
      config.default_username = ENV['my_pass']
      config.read_only = false
    end
  end
end
```

You can then access those configurations in your app at
`service.evergreen.configuration.host`.

### Retrieving objects

Once you have an object:

```
Evergreen.new(host: 'my.evergreen.server') do |evergreen|
  bib = evergreen.get_bib_record(123)
  bib.to_marc
  evergreen.get_item(345)
  evergreen.get_call_number(2345)
end
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Goals

The priorities here are:
* Thread safety
* Good documentation
* Good tests

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sandbergja/evergreen-rb.
