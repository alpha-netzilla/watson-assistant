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
You can use either USERNAME and PASSWORD or API KEY authentication.

### (Username and Passowrd)
Set the Environment:
```sh
export USERNAME="***"
export PASSWORD="***"
export WORKSPACE_ID="***"

export REGION="gateway.watsonplatform.net" # Optional: Default region is "gateway.watsonplatform.net"

# You can select ruby hash or a redis server for managing users.
export STORAGE="hash" # Optional: Default storage is ruby hash.
# or
#export STORAG="redis://127.0.0.1:6379"
```

Send requests:
```ruby
require 'watson/assistant'

manager = Watson::Assistant::Manager.new(
  username: ENV["USERNAME"],
  password: ENV["PASSWORD"],
  workspace_id: ENV["WORKSPACE_ID"],
  region: ENV["REGION"],
  storage: ENV["STORAGE"]
)

# Get a greet message from a assistant service.
puts response1 = manager.talk("user1", "")
#=> {user: user1, status_code: 200, output: [\"What would you like me to do?\"]}

# Get a response to a user's input.
puts response2 = manager.talk("user1", "I would like you to ...")
#=> {user: user1, status_code: 200, output: [\"I help you ...\"]}

# Check if the user exists
puts manager.has_key?("user1")

# Delete the user
puts manager.delete("user1")
```

### (API KEY)
Set the Environment:
```sh
export APIKEY="***"
export WORKSPACE_ID="***"
export REGION="gateway.watsonplatform.net"
export STORAGE="hash"
```

Send requests:
```ruby
require 'watson/assistant'

manager = Watson::Assistant::Manager.new(
  apikey: ENV["APIKEY"],
  workspace_id: ENV["WORKSPACE_ID"],
  region: ENV["REGION"],
  storage: ENV["STORAGE"]
)

puts response1 = manager.talk("user1", "")
puts response2 = manager.talk("user1", "I would like you to ...")
```

## Advanced usage
### Edit context variables
The SDK exposes the access to a context variable.  You can edit a context variable. I 
The most common use cases to edit a context variable is that when you call cloud function nodes from Watson Assistant instances. You do not have to store credentials in the Watson Assistant workspace. Instead, pass them from the client application as part of context. 
```ruby
section = {"my_credentials"=> {
              "user": "user_for_calling_functions",
              "password": "password_for_calling_functions"
            }
          }

manager.update_context_section(user: "user1", key: "private", value: section))

```

Other use cases to operate a context variable
```ruby
manager.read_context(user: "user1")
manager.read_context_section(user: "user1", key: "conversation_id"
manager.delete_context_section(user: "user1", key: "private")

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

