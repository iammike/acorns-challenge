# Redfin Search Results Verification

An exercise in automating search, filters, and verification of the displayed results for Redfin.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

Any modern machine and operating system should be able to run this project.

For simplicity's sake, the instructions will be catered to a Mac running OS X with [Google Chrome](https://www.google.com/chrome/) installed. 

### Installing

Perform the following steps from your terminal of choice:

1. Install [Homebrew](https://brew.sh), a package manager for macOS:

    ```
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    ```

1. Install [rbenv](https://github.com/rbenv/rbenv), a Ruby version manager:

    ```
    brew install rbenv
    ```
    
1. Configure rbenv in your shell:

    ````
    rbenv init
    ````
    
1. Restart your shell:

    ````
    exec $SHELL -l
    ````
    
1. Install [Ruby](https://en.wikipedia.org/wiki/Ruby_(programming_language) 2.6.0:

    ````
    rbenv install 2.6.0
    ````
    
1. Install [Bundler](https://bundler.io), a Ruby gem manager:

    ````
    gem install bundler
    ````
    
1. From a directory of your choice, clone [the repository](https://github.com/iammike/). Following this step, all subsequent 
steps should be performed from inside this cloned directory:

    ````
    git clone [replace brackets and bracketed text with value provided by 'Clone or Download' button in link above']
    ````

1. Install the required [Ruby Gems](https://en.wikipedia.org/wiki/RubyGems):
    
    ````
    bundle install
    ````

## Running the code

From inside the respository directory, run the following command:

````
cucumber
````

## Built With

* [Capybara](https://github.com/teamcapybara/capybara) - Web-based test automation software that simulates scenarios for user stories and automates web application testing for behavior-driven software development.
* [Cucumber](https://cucumber.io) - Allows for readable test specification.
* [Ruby](https://www.ruby-lang.org/en/) - Dynamic, open source programming language with a focus on simplicity and productivity.
* [RubyMine](https://www.jetbrains.com/ruby/) - Ruby-specific Integrated Development Environment.
* [Site Prism](https://github.com/natritmeyer/site_prism) - Page Object Model Domain-Specific Language (DSL) for Capybara. 

## Authors

* **Michael Collins** - *Initial work* - [iammike](https://github.com/iammike)


## License

This project is bound by The Unlicense. For more information, please refer to <http://unlicense.org>.

