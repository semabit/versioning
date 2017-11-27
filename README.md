# Versioning

This Gem provides versioning helpers your Ruby on Rails Application.

This gem adds following rake tasks:

```ruby
rake version:init # create CHANGELOG.md and DEPLOYMENT.md Files
rake version:bump # Bump current version to supplied VERSION='x.x.x'
rake version:show # show current version
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'versioning', git: "git@github.com:semabit/versioning.git"
```

And then execute:

    $ bundle

### Create Versioning Files

First you need to create the version file under `config/initializers/version.rb`:
```ruby
module YourApplication
  module Application
    VERSION='x.x.x'
  end
end
```

Now execute `version:init` with:  
```
$ rails version:init
```

This will create the versioning files where you log the changes.

## Usage

Once you're ready to bump the app version, just do:
```
$ rails version:bump VERSION='your.new.version'
```

This will update your `version.rb` file as well as the CHANGELOG.md and DEPLOYMENT.md files.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/shanehofstetter/versioning.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
