# Git-Helpers

[![Build Status](https://travis-ci.org/KierranM/git-helpers.svg?branch=master)](https://travis-ci.org/KierranM/git-helpers) [![Code Climate](https://codeclimate.com/github/KierranM/git-helpers/badges/gpa.svg)](https://codeclimate.com/github/KierranM/git-helpers) [![Dependency Status](https://gemnasium.com/KierranM/git-helpers.svg)](https://gemnasium.com/KierranM/git-helpers) [![Documentation Coverage](http://inch-ci.org/github/kierranm/git-helpers.svg?branch=master)](http://inch-ci.org/github/kierranm/git-helpers?branch=master)

Git-Helpers is a small library of commands to extend `git` to help improve your git workflow

## Installation

Install it using:

    $ gem install git-helpers

## Usage

Thanks to the way `git` finds extension commands on the path, once the gem is installed
all of the commands are available in the usual `git <command>` manner.

## Available Commands

### Update
Running `git update` will pull down the latest changes for your current branch
from the upstream remote (or origin if you don't have an upstream), and pushes
the changes to your origin (or not at all if it was pulled from origin).

## Development

After checking out the repo, run `bundle` to install dependencies. Then, run `bundle exec rake spec` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then push your changes to your fork, and create a pull request into [KierranM/git-helpers](https://github.com/KierranM/git-helpers). Once merged a release will be
created and the gem pushed to upstream

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/KierranM/git-helpers.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
