# PushToSNS

PushToSNS is an opinionated gem to allow pushing push notifications through SNS. It assumes you want to use a type and a message in your payload, that you already configured the AWS gem and that your message is encoded as json. If this is your case, this will make your life easier.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "push_to_sns"
```

And then execute:

```
$ bundle
```

## Usage

### Setup

1. First, configure the [AWS gem](https://github.com/aws/aws-sdk-ruby/tree/aws-sdk-v1).
2. Now, run the following command if you use rails:

    ```
    $ rails generate push_to_sns:install
    ```

  This will generate the file `app/initializers/push_to_sns.rb` with the following content: (if you're not using rails, just paste the code in a place to be executed once on startup)

  ```ruby
    PushToSNS.configure do
      read_device_token { |device| }
      read_source { |device| }
      read_endpoint_arn { |device| }
      read_platform_arn { |device|  }
      read_ios_apns { |device| }

      save_endpoint_arn do |device, endpoint_arn|
      end
    end
  ```

3. This initializer is only full of some empty methods. Why? Because we don't want to enforce a `Device` model or couple heavily with `ActiveRecord`, you can specify the way you want us to read and store device identifiers and SNS endpoints in your model. We don't want to be an obstacle in your way. But, anyway, we can suggest the following:

  ```ruby
    PushToSNS.configure do
      read_device_token { |device| device.device_token }
      read_source { |device| device.source }
      read_endpoint_arn { |device| device.endpoint_arn }
      read_platform_arn { |device| ENV["SNS_#{device.source.upcase}_PLATFORM_ARN"] }
      read_ios_apns { ENV["APNS"] }

      save_endpoint_arn do |device, endpoint_arn|
        device.update(endpoint_arn: endpoint_arn)
      end
    end
  ```

### Device Setup

This is up to you in some way. For example, you can have a controller to receive a `device_token` and `device_uuid` from a mobile device and you want to register the device to be able to receive push notifications. You can do it in this way:

```ruby
class DevicesController < ApiController
  def create
    device = Device.find_by(device_uuid: device_params[:device_uuid])
    if device.present?
      # We first teardown the old endpoint arn.
      PushToSNS.teardown_device(device)
      device.update(device_params.slice(:device_token))
    else
      device = Device.create(device_params)
    end

    PushToSNS.setup_device(device)
    respond_with device
  end

  private

  def device_params
    params.require(:device).permit(:device_token, :device_uuid, :source)
  end
end
```

`PushToSNS.setup_device` will get the device identifier from the object passed and register it on SNS. Then, it will store the endpoint returned using the code specified in `save_endpoint_arn` configuration.

### Create a Push Notifier

Now, imagine you have a football match and you want to notify users about a new goal being made. First, create a push notification object. In Rails, you can do this:

```
rails generate push_to_sns:notifier new_goal goal
```

The parameter `new_goal` will be used to set the notifier's name and the next parameters (`goal`, for example) will be used to add some attribute accessors to the new notifier. This will help with the initialization of the notifier.

It will create the following object in `app/push_notifiers/new_goal_push_notifier.rb`:

```ruby
class NewGoalPushNotifier < PushToSNS::PushNotifier
  message "New Goal"
  type :new_goal

  attr_accessor :goal

  def devices
    fail "Method Not Implemented: devices"
  end

  def notification(device)
    fail "Method Not Implemented: notification"
  end
end
```

Now, we need to answer two questions:

- What devices do we need to notify of this goal?
- What is the data we need to send?

To answer these questions, we need to implement the method `devices` and `notification`. For example, we can have these two methods:

```ruby
def devices
  goal.match.subscribed_devices
end

def notification(device)
  {
    scorer: goal.scorer,
    team: goal.team,
    match_id: goal.match_id,
    new_result: goal.new_result,
    is_favorite: device.user.favorite_teams.include?(goal.team)
  }
end
```


### Send the push notification

Now, in whatever place you want to, deliver the notifier by creating a push notifier with the given arguments (those attribute accesors that we set before) and calling `deliver` after that:

```ruby
NewGoalPushNotifier.new(goal: goal).deliver
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake false` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/push_to_sns.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
