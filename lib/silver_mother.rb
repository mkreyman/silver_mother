require 'silver_mother/version'
require 'silver_mother/utils'
require 'silver_mother/api'
require 'silver_mother/user'
require 'silver_mother/node'
require 'silver_mother/feed'
require 'silver_mother/subscription'
require 'silver_mother/person'
require 'silver_mother/event'
require 'silver_mother/auth'

# @TODO: delete

# SilverMother.register(device)
# SilverMother.authenticate
# Resource, Nodes, Events, Subscriptions, Feeds, Persons (they're actually Nodes)
#
# SilverMother::Resource (information common to our site/application)
# SilverMother::Node.new
# node.subscribe_to(feed)
# node.publish(event, to: feed)
#
# SilverMother::Event
# SilverMother::Subscription.new
# subscription.notify(node)
#
# SilverMother::Feed
#
# feed URLs: /feeds/(uid)
# nested feed URLs: /node/(uid)/feeds/(type)
# URLs relative to a node being created or updated (feed/(type) in POST and PUT requests on /nodes)
# i.e.
# /feeds/e9wyk1Xb42EH3mMhucR0PC7PjgUWmFMY/
# /nodes/Nf6QUJBWxsB9arukraSR9BfaRpx32QNS/feeds/temperature
# feeds/temperature
#
# import sense
# from sense.resources import APIResource, ListAPIResource
# https://pypi.python.org/pypi/sense/0.1.2

# profile: access to the user’s metadata (name, email, list of nodes and feeds)
#
# devices.read/devices.write: access to the user’s devices,
# and allow reading and/or writing data to them (e.g., if you want to receive motion data from their Cookies,
# or set the temperature on their Nest thermostat)
#
# members.read/members.write: access to the user’s family members information,
# and allow reading and/or writing data to them (e.g., if you want to receive sleep data, or send running data,
# for a member of this user’s family)
#
# feeds.read/feeds.write: access to all of a user’s feeds (both attached to devices and to members).
