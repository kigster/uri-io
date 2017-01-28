[![Downloads](http://ruby-gem-downloads-badge.herokuapp.com/uri-io?type=total)](https://rubygems.org/gems/uri-io)
[![Gem Version](https://badge.fury.io/rb/uri-io.svg)](https://badge.fury.io/rb/uri-io)

[![Build Status](https://travis-ci.org/kigster/uri-io.svg?branch=master)](https://travis-ci.org/kigster/uri-io)
[![Code Climate](https://codeclimate.com/repos/588d08ab8dcb7c006a004c31/badges/fbe3044e50dfc06f7b93/gpa.svg)](https://codeclimate.com/repos/588d08ab8dcb7c006a004c31/feed)
[![Test Coverage](https://codeclimate.com/repos/588d08ab8dcb7c006a004c31/badges/fbe3044e50dfc06f7b93/coverage.svg)](https://codeclimate.com/repos/588d08ab8dcb7c006a004c31/coverage)
[![Issue Count](https://codeclimate.com/repos/588d08ab8dcb7c006a004c31/badges/fbe3044e50dfc06f7b93/issue_count.svg)](https://codeclimate.com/repos/588d08ab8dcb7c006a004c31/feed)

> **WARNING**: This gem is currently under active development, and is not yet stable. Use at your own risk.

# URI::IO

## Summary

This gem aims to combine the extensibility of the `URI` class — its design supports adding new and custom URI __schemes__, with the idea of a consistent interface to read/write resources offered by the `OpenURI` standard ruby module, and aims to greatly expand the list of URIs that can be used to *read*, *write*, (maybe also *append*) and *delete* resources. 

## Usage

The overall interface very simple, but powerful:

```ruby
require 'uri-io'
URI::IO.from([URI]).operation
URI::IO[[URI]].operation
```

Let's take a look at a few examples:

```ruby
require 'uri-io'

URI::IO['env://HOME'].read
# => "/Users/"

URI::IO['file:///usr/local/etc/hosts'].read
# => "127.0.0.1    localhost\n...."
URI::IO['file:///usr/local/etc/hosts'].write(data)
# => 23425
URI::IO['file:///usr/local/etc/hosts'].delete
# => true

URI::IO['redis:///1/mykey'].write('keyvalue')
# => 8
URI::IO['redis:///1/mykey'].read
# => "keyvalue"
URI::IO['redis:///1/mykey'].delete
# => true
```


### Using DSL 

_[ Not yet implemented ]_

This module decorates string with the `#io` method, which attempts to parse the string into the URI first, and then find an appropriate handler supporting IO operations for this resource.

```ruby
File.exist?('/home/kig/.bashrc')
# => true

require 'uri/io/string'
uri = 'file:///home/kig/.bashrc'
uri.io.read
# => "#!/usr/bin/env bash\n...... "
uri.io.write('echo "Your bashrc has been wiped"')
# => 45
uri.io.append('echo "Maybe not completely"')
# => 334
uri.io.delete
# => true
File.exist?('/home/kig/.bashrc')
# => false
```

### Motivation

This gem was born out of the desire to easily read and write data via a large number of ways during development of another gem — [sym](https://github.com/kigster/sym) — which performs symmetric encryption, and needs to read the private key and the data, and write the result (and sometimes the private key). After running out of flags to pass indiciating how exactly the private key is supplied, I had an epiphany — what if I can just use one flag with the data source URI? 

### Approach

There are two high-level steps required to create a unified way of reading/writing various resources:

 1. One must define the syntax for describing how to access it
 2. One must implement the actual read/write code for each supported syntax.

The most natural fit for 1 seems to be the `URI` module. It can be easily extended by design, and already supports many schemes out the box. In addition, a popular `OpenURI` extension adds the `open` call to `http[s]`, `ftp`, and `ssh` protocols, partially providing #2 for these schemes.

However, `OpenURI` only supports a few protocols, and does not currently support *delete* operation. 

The approach we take is to extend `URI` with the schemes with support, and fulfill them using `Handlers` that can be easily added.

## Supported URIs

The following types are planned to be supported:

##### Environment Variables

```ruby
URI::IO['env://HOME').read
# => /Users/kig
```
##### Redis

###### Read/Write Hash Value by Key

```ruby
URI::IO['redis://localhost:6379/1/firstname').write('konstantin')
# => 'OK'
URI::IO['redis://localhost:6379/1/firstname').read
# => 'konstantin'
```

###### Any Operation?

```ruby
URI::IO['redis://localhost:6379/1/operation').run(*args)
```

##### File Operation

```ruby
URI::IO['scp://user@host/path/file').delete
```

Suggested possible ways of accessing local and remote data:

```ruby
URI::IO['string://value'].read
# => "value"

URI::IO['env://PATH').read
# => "/bin:/usr/bin:/usr/local/bin"

URI::IO['stdin:/'].read
# => data from STDIN until EOF

URI::IO['shell://echo%20hello'].read
# => "hello"

URI::IO['redis://127.0.0.1:6397/1/get,firstname'].read
# => 'konstantin'
```

Similarly, we could read data from:

    memcached://127.0.0.1:11211/operation,arg1,arg2,...
    scp://user@host/path/file        
    postgresql://user@host/db/?sql=<sql-query>

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'uri-io'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install uri-io


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kigster/uri-io.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

