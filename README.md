# Versioning

This Gem provides versioning helpers your Ruby on Rails Application.

Following rake tasks will be added to your project:

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

This will create the versioning files (CHANGELOG.md, DEPLOYMENT.md) where you log the changes.

## Usage

Once you're ready to bump the app version, just do:
```
$ rails version:bump VERSION='your.new.version'
```

This will update your `version.rb` file as well as the CHANGELOG.md and DEPLOYMENT.md files.
