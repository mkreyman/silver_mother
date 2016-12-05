# SilverMother API

A ruby library for communicating with the SilverMother REST API (https://sen.se/developers/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'silver_mother'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install silver_mother


## Usage

Fetch your token first:

```ruby
user = SilverMother::User.new('your_username', 'your_password')
token = user.token
```

### Events

```ruby
events_api = SilverMother::Event.instance
events_api.call(token)
feeds = events_api.feeds
nodes = events_api.nodes
node_uids = events_api.node_uids
feed_uids = events_api.feed_uids

options = {
            uid:   'n3TQUtzAp3c67BYOUsIuMAwgWe7i0r3A',
            type:  'notification',
            limit: 5,   # limit the number of results, default is 10
            secs:  3600 # ttl for returned results, default is 300
          }
```

Possible types appear to be:

 * 'alert'
 * 'battery'
 * 'medication'
 * 'motion'
 * 'notification'
 * 'presence'
 * 'status'
 * 'temperature'
 * 'tile'

**NOTE:** you can only specify 'type' for node UIDs.

```ruby
events = events_api.events(options)
```

If you need to work with a particular event:

```ruby
event = events[0]
```

Attributes/methods now available for the `event` object:

 * data
 * dateEvent
 * dateServer
 * expiresAt
 * feedUid
 * gatewayNodeUid
 * geometry
 * nodeUid
 * payload
 * profile
 * signal
 * type
 * version

Some attributes might, in turn, be objects or arrays of objects that
you could further explore, i.e.

```ruby
events.first.data.body
events.first.geometry.coordinates
```

### Feeds

```ruby
feeds_api = SilverMother::Feed.instance
feeds_api.call(token)
feeds = feeds_api.feeds
uids = feeds_api.uids
```

To get a feed (or feeds) for a particular uid:

```ruby
feed = feeds_api.feed(uid)
```

Attributes/methods now available for the `feed` object:

 * uid
 * eventsModel
 * eventsUrl
 * label
 * node
 * object
 * type
 * url
 * used

Some attributes are objects or arrays of objects that you could further explore, i.e.

```ruby
feed.eventsModel.geometry
```

### Nodes

```ruby
nodes_api = SilverMother::Node.instance
nodes_api.call(token)
nodes = nodes_api.nodes
uids = nodes_api.uids
```

`nodes` is an array of node objects that you could iterate over. i.e.

```ruby
node = nodes.first
```

Attributes/methods now available for the `node` object:

 * uid
 * label
 * url
 * resource
 * token
 * object
 * geometry
 * createdAt
 * updatedAt
 * paused
 * subscribes
 * publishes

Some attributes are, in turn, objects or arrays of objects that you could further explore, i.e.

```ruby
node.resource.type
node.publishes[0].url
```

There's another way to get a node, assuming you've run `nodes_api.uids`, in order to get a list of uids:

```ruby
node = nodes_api.node(uid)
```

To get feed(s) for a uid:

```ruby
feed = nodes_api.feed(uid)
```

### Persons

```ruby
persons_api = SilverMother::Person.instance
persons_api.call(token)
persons = persons_api.persons
person = persons.first
```

Attributes/methods now available for the `person` object:

 * uid
 * avatarUrl
 * email
 * firstName
 * lastName
 * gender
 * object
 * phoneNumber

### Subscriptions

```ruby
subscriptions_api = SilverMother::Subscription.instance
subscriptions_api.call(token)
subscriptions = subscriptions_api.subscriptions
subscription = subscriptions.first
```

Attributes/methods now available for the `subscription` object:

 * uid
 * createdAt
 * updatedAt
 * gatewayUrl
 * geometry
 * label
 * object
 * paused
 * publishes
 * resource
 * subscribes
 * url

Some attributes might, in turn, be objects or arrays of objects that you could explore further, i.e.

```ruby
subscription.subscribes[0].type
```

### User

```ruby
user = SilverMother::User.new('your_username', 'your_password')
user.object
```

Attributes/methods now available for the `user.object` object:

 * uid
 * email
 * language
 * object
 * timezone
 * country
 * username
 * subscriptions
 * applications
 * createdAt
 * updatedAt
 * is_developer
 * firstName
 * lastName
 * devices
 * persons

Some attributes might be objects or arrays of objects that you could  explore further, i.e.

```ruby
user.subscriptions[0].uid
user.applications.first.label
user.devices.last.url
user.persons[1].firstName
```

### Making API requests not covered by the current version of the gem

```ruby
silver_mother_api = SilverMother::Api.instance

silver_mother_api.get(token, path, params = {})
silver_mother_api.post(token, path, params = {})
silver_mother_api.put(token, path, params = {})
silver_mother_api.delete(token, path, params = {})
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

* Fork the project.
* Run `bundle`
* Run `bundle exec rake`
* Create your feature branch (`git checkout -b my-new-feature`)
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a future version unintentionally.
* Run `bundle exec rake` again.
* Commit your changes. (`git commit -am 'Add some feature'`). Please do not mess with rakefile, version, or history.
* Push to the branch. (`git push origin my-new-feature`)
* Create a new Pull Request.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

