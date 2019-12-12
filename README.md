[![CircleCI](https://circleci.com/gh/jetthoughts/jt_tools.svg?style=svg)](https://circleci.com/gh/jetthoughts/jt_tools)

# JetThoughts Tools

Ruby on Rails ecosystem to maintain projects without losing your mind.
Automatization scripts and services integrations which make your product world class level with no effort!

More details could be found in such posts:

* [How to Setup a Project That Can Host Up to 1000 Users for Free](https://jtway.co/how-to-setup-a-project-that-can-host-up-to-1000-users-for-free-ab59ad3edaf1)
* [Our Default Ruby Development Stack](https://jtway.co/our-default-ruby-development-stack-9d7e80ef21df)
* [Heroku Reviews Apps prevent delivering bugs on production](https://jtway.co/make-master-stable-again-b15c9ff3b129)

# Services and Tools

Pre-setup for service 

* Heroku
* CircleCI
* Codecov
* Pronto
* Static Code Analysisers: Rubocop, Reek, and etc.
* Dependabot

## Installation

To install remotely:

```bash
rails app:template LOCATION=https://raw.githubusercontent.com/jetthoughts/jt_tools/master/template.rb
```

Add this line to your application's Gemfile:

```ruby
gem 'jt_tools', groups: [:development]
```

And then execute:

    $ bundle
    $ bin/rails jt_tools:install


## Usage

Setup and update all tools required to maintain static code analysis

```bash
bin/tools-setup

bin/tools-upgrade
```

Auto-review on GitHub opened Pull Rquests to follow code consensentcy

```bash
bin/lint-github-pr
```

Check localy all problems in the current branch cahnges

```bash
bin/pronto run
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
