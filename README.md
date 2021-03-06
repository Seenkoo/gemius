# Gemius

Parses your Gemfile.lock file and lists all dependencies.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gemius'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gemius

## Usage

```ruby
  gemfile_lock = Gemius.gemfile_lock('path to Gemfile.lock or its contents')

  spec = gemfile_lock.specs.first
  => {
    name: "aws-s3",
    version: "0.6.3",
    remote: "git://github.com/JeremyGeros/aws-s3.git",
    revision: "bdf58c51f55bb16a7f2a83f01c34976333cc5f4c"
  }
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/gemius.
