# Execute

Popen-wrapper, which provides additional features

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'execute'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install execute

## Usage

execute echo command
```ruby
status = Execute::execute ['echo', 'hello world']

# print output
puts status.stdout
```

execute echo command and print command
```ruby
status = Execute::execute ['echo', 'hello world'], print_cmd: true
```

execute echo command and print output
```ruby
status = Execute::execute ['echo', 'hello world'], print_lines: true
```

execute false command and throw exception, because exitstatus > 0
```ruby
status = Execute::execute ['false'], throw_exception: true
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/execute.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

