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

### Authorizing your app

```ruby
app_params = { gateway_url: 'http://your_app_domain/notification/',
               redirect_url: 'http://your_app_domain/oauth/',
               oauth2_client_id: 'your-client-id',
               oauth2_client_secret: 'your-client-secret',
               scope: 'profile+feeds.read' }

# see https://sen.se/developers/documentation/ for a list of available scopes;
# it appears that you could only use two scopes at a time.

app = SilverMother::Application.new(app_params)
```

Then construct authorization url for your user

```ruby
app.authorization_url
```

After following the URL the user would be directed to a Sen.se auth page, and then redirected to your `redirect_url`, with an auth code as `code` parameter, i.e.

```ruby
http://your_app_domain/oauth/?code=2zykyywQ5bcGAVzMbLUjW4hJSqm4rO

app.get_token('2zykyywQ5bcGAVzMbLUjW4hJSqm4rO')
```

**NOTE: You only have 60 secs to retrieve your access token with that code. If you’re getting an “invalid grant” error, it means that the given authorization code has expired already.**

The `app.token` object would now have the following attributes:

 * access_token
 * expires_in
 * expires_on (gets calculated based on `expires_in` and the current time)
 * refresh_token
 * scope
 * token_type


```ruby
token = app.token.access_token
```

It appears that the access token is valid for 1 year. Use the `refresh_token` method to retrieve a new access token:

```ruby
app.refresh_token(app.token.refresh_token)
```

And now you have an updated `app.token` object

```ruby
token = app.token.access_token
```

### Events

```ruby
events_api = SilverMother::Event.instance
events_api.call(token)
feeds = events_api.feeds
nodes = events_api.nodes
node_uids = events_api.node_uids
feed_uids = events_api.feed_uids

# with 'uid' being a node's uid
events = events_api.events(uid, type)

# i.e.
events = events_api.events('n3TQUtzAp3c67BYOUsIuMAwgWe7i0r3A', 'notification')
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

**NOTE:** you can only specify `type` for a node UID. So, if `type` is omitted, the `uid` is assumed to be a feed uid:

 ```ruby
events = events_api.events(uid)

```

Then, to work with a particular event:

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

To get a feed (or feeds) for a particular feed `uid`:

```ruby
feed = feeds_api.feed(uid)
```

Attributes/methods now available for the `feed` object:

 * eventsModel
 * eventsUrl
 * label
 * node
 * object
 * type
 * uid
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

 * createdAt
 * geometry
 * label
 * object
 * paused
 * publishes
 * resource
 * subscribes
 * token
 * uid
 * updatedAt
 * url

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

 * avatarUrl
 * email
 * firstName
 * gender
 * lastName
 * object
 * phoneNumber
 * uid

### Subscriptions

```ruby
subscriptions_api = SilverMother::Subscription.instance
subscriptions_api.call(token)
subscriptions = subscriptions_api.subscriptions
subscription = subscriptions.first
```

Attributes/methods now available for the `subscription` object:

 * createdAt
 * gatewayUrl
 * geometry
 * label
 * object
 * paused
 * publishes
 * resource
 * subscribes
 * uid
 * updatedAt
 * url

Some attributes might, in turn, be objects or arrays of objects that you could explore further, i.e.

```ruby
subscription.subscribes[0].type
```

### User

```ruby
users_api = SilverMother::User.instance
users_api.call(token)
user = users_api.user
```

Attributes/methods now available for the `user` object:

 * applications
 * country
 * createdAt
 * devices
 * email
 * firstName
 * is_developer
 * language
 * lastName
 * object
 * persons
 * subscriptions
 * timezone
 * uid
 * updatedAt
 * username

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

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

* Fork the project.
* Run `bundle`
* Run `bundle exec rake`
* Create your feature branch (`git checkout -b my-new-feature`)
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a future version unintentionally.
* Run `bundle exec rake` again.
* Run `rubocop .`
* Commit your changes. (`git commit -am 'Add some feature'`). Please do not mess with rakefile, version, or history.
* Push to the branch. (`git push origin my-new-feature`)
* Create a new Pull Request.

## Support

Please report bugs at [the project page on Github](https://github.com/mkreyman/silver_mother/issues). Don't
hesitate to [ask questions](http://stackoverflow.com/questions/tagged/silver-mother-api-ruby-client) about the client on [StackOverflow](http://stackoverflow.com). Please note that I'm __not__ affiliated with [Sen.se](https://sen.se) in any way. So all questions about their API should be directed to their support at [support@sen.se](support@sen.se) and [api@sen.se](api@sen.se).

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

