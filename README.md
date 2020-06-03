[![CircleCI](https://circleci.com/gh/jetthoughts/jt_tools.svg?style=svg)](https://circleci.com/gh/jetthoughts/jt_tools)
[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2Fjetthoughts%2Fjt_tools.svg?type=shield)](https://app.fossa.io/projects/git%2Bgithub.com%2Fjetthoughts%2Fjt_tools?ref=badge_shield)
[![Gem Version](https://badge.fury.io/rb/jt_tools.svg)](https://badge.fury.io/rb/jt_tools)

# JetThoughts Tools

Ruby on Rails Continious Deployemnt ecosystem to maintain projects without losing your mind.
Automatization scripts and services integrations which make your product world class level with no effort!

More details could be found in such posts:

* [How to Setup a Project That Can Host Up to 1000 Users for Free](https://jtway.co/how-to-setup-a-project-that-can-host-up-to-1000-users-for-free-ab59ad3edaf1)
* [Our Default Ruby Development Stack](https://jtway.co/our-default-ruby-development-stack-9d7e80ef21df)
* [Heroku Reviews Apps prevent delivering bugs on production](https://jtway.co/make-master-stable-again-b15c9ff3b129)
* [Effortless Code Conventions Review for Pull Request Changes](https://jtway.co/effortless-code-review-for-pull-request-changes-241206b1cb04)

# Services and Tools

Pre-setup for service 

* [GitHub](https://github.com)
* [Heroku](https://jtway.co/make-master-stable-again-b15c9ff3b129) (Heroku Reviews Apps)
* [CircleCI](https://circleci.com/)
* [Codecov](https://codecov.io/) and [Simplecov](https://github.com/colszowka/simplecov)
* [Dependabot](https://dependabot.com/)
* [MemCachier](https://www.memcachier.com/)
* Code Styles:
  * [Pronto](https://jtway.co/effortless-code-review-for-pull-request-changes-241206b1cb04)
  * [Rubocop](https://github.com/rubocop-hq/rubocop)
  * [ESLint](https://eslint.org/)
  * [EditorConfig](https://editorconfig.org/)

## Installation

To install remotely:

```bash
rails app:template LOCATION=https://raw.githubusercontent.com/jetthoughts/jt_tools/master/template.rb
```

Add this line to your application's Gemfile:

```ruby
gem 'jt_tools', groups: [:development], github: 'jetthoughts/jt_tools'
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

Auto-review on GitHub opened Pull Rquests to follow code consistency

```bash
bin/lint-pr
```

Check locally all problems in the current branch changes

```bash
bin/pronto run
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).


[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2Fjetthoughts%2Fjt_tools.svg?type=large)](https://app.fossa.io/projects/git%2Bgithub.com%2Fjetthoughts%2Fjt_tools?ref=badge_large)
