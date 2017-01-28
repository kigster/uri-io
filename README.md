[![Downloads](http://ruby-gem-downloads-badge.herokuapp.com/uri-io?type=total)](https://rubygems.org/gems/uri-io)
[![Gem Version](https://badge.fury.io/rb/uri-io.svg)](https://badge.fury.io/rb/uri-io)

[![Build Status](https://travis-ci.org/kigster/uri-io.svg?branch=master)](https://travis-ci.org/kigster/uri-io)
[![Code Climate](https://codeclimate.com/repos/588d08ab8dcb7c006a004c31/badges/fbe3044e50dfc06f7b93/gpa.svg)](https://codeclimate.com/repos/588d08ab8dcb7c006a004c31/feed)
[![Test Coverage](https://codeclimate.com/repos/588d08ab8dcb7c006a004c31/badges/fbe3044e50dfc06f7b93/coverage.svg)](https://codeclimate.com/repos/588d08ab8dcb7c006a004c31/coverage)
[![Issue Count](https://codeclimate.com/repos/588d08ab8dcb7c006a004c31/badges/fbe3044e50dfc06f7b93/issue_count.svg)](https://codeclimate.com/repos/588d08ab8dcb7c006a004c31/feed)


# URI::IO

This gem was born out of the need to be able to read data, and write data via a large number of ways. There are two parts to this: 

 1. Defining the syntax for describing where to read it from
 2. Implementing actual read/write code for each type.

The most natural fit for #1 is using the `URI` ruby module. It can already be extended, and supports many schemes out the box.

In addition, a popular `OpenURI` extension adds the `open` call to `http[s]`, `ftp`, and `ssh` protocols.

However, what I wanted is a gem that not only understands much wider set of URIs than what `OpenURI` supports today, but can also read/write, as well as delete local or remote resources defined via URIs.

## Why is this useful?

This functionality could be so tremendously helpful because any ruby program that reads and writes data can suddenly replace File.read with, something completely generic:

## What can it do?

##### Environment Variables

```ruby
URI::IO('env://HOME').read
# => /Users/kig
```

##### Arbitrary Redis Operation

```ruby
URI::IO('redis://localhost:6379/1/set,firstname,konstantin').write
# => 'OK'
```
##### File Operation

```ruby
URI::IO('scp://user@host/path/file').delete
```

As I continued on this path, I've thought of the following candidate URIs. Not all of them can support writing or deleting the resource, but all of them can read the data:

Existing URIs supported by OpenURI:

    http[s]://user@host/path/file    
    file://filename                  
    ftp[s]://user@host/path/file
    
Suggested possible ways of accessing local and remote data:

```ruby
URI::IO('string://value').read
# => "value"

URI::IO('env://PATH').read
# => "/bin:/usr/bin:/usr/local/bin"

URI::IO('stdin:/').read
# => data from STDIN until EOF

URI::IO('shell://echo%20hello').read
# => "hello"

URI::IO('redis://127.0.0.1:6397/1/get,firstname').read
# => 'konstantin'
```

Similarly, we could read data from:

    memcached://127.0.0.1:11211/operation,arg1,arg2,...
    scp://user@host/path/file        
    postgresql://user@host/db/?sql=<sql-query>

And so on.

### Command Line Tools

If you are building a command line tool, you can ask for input in the for of `uri-io` supported URI, and then read/write to it, as well as delete it.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'uri-io'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install uri-io

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kigster/uri-io.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

