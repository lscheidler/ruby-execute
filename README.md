# Execute

[![Build Status](https://travis-ci.org/lscheidler/ruby-execute.svg?branch=master)](https://travis-ci.org/lscheidler/ruby-execute)

Popen-wrapper, which provides additional features

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'execute', git: 'https://github.com/lscheidler/ruby-execute'
```

And then execute:

    $ bundle

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

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/lscheidler/ruby-execute.


## License

The gem is available as open source under the terms of the [Apache 2.0 License](http://opensource.org/licenses/Apache-2.0).

