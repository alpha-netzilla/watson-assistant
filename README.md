# Watson::Assistant

Ruby client library to use the [IBM Watson Assistant][wc] service.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'watson-assistant'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install watson-assistant

## Usage
```sh
export USERNAME="***"
export PASSWORD="***"
export WORKSPACE_ID="***"

# Optional
# Default region is "gateway.watsonplatform.net"
export REGION="gateway.watsonplatform.net"

# Optional
# Default storage is ruby hash.
# You can select ruby hash or a redis server for managing users.
export STORAGE="hash" # Default
#export STORAG="redis://127.0.0.1:6379"
```

```ruby
require 'watson/assistant'

manage = Watson::Assistant::ManageDialog.new(
  username: ENV["USERNAME"],
  password: ENV["PASSWORD"],
  workspace_id: ENV["WORKSPACE_ID"],
  region: ENV["REGION"],
  storage: ENV["STORAGE"]
)

# Get a greet message from a assistant service.
puts response1 = manage.talk("user1", "")
#=> {user: user1, status_code: 200, output: [\"What would you like me to do?\"]}

# Get a response to a user's input.
puts response2 = manage.talk("user1", "I would like you to ...")
#=> {user: user1, status_code: 200, output: [\"I help you ...\"]}

# Check if the user exists
puts manage.has_key?("user1")

# Delete the user
puts manage.delete("user1")
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/alpha-netzilla/watson-assistant. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Authors
* http://alpha-netzilla.blogspot.com/

[wc]: http://www.ibm.com/watson/developercloud/doc/assistant/index.html
