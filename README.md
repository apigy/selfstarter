# Selfstarter
Selfstarter makes it easy to roll your own crowdfunding site. To get started, fork this repository and change around ```config/settings.yml``` to suit your needs.

[See it in action](http://selfstarter.us)

## Background

After a [rejection from Kickstarter](http://techcrunch.com/2012/10/07/the-story-of-lockitron-crowdfunding-without-kickstarter/), we decided to follow in the footsteps of [App.net](https://app.net/) and make our own crowdfunding site for [Lockitron](https://lockitron.com). We've been absolutely blown away by the response. As a first step in what will hopefully be a long history of giving back, we have decided to open source the crowdfunding platform that got us here. Please send questions, comments, or concerns to [hello@lockitron.com](mailto:hello@lockitron.com)!

Selfstarter is a starting point. We made some specific choices with Selfstarter for Lockitron and we recommend you tailor it for your project:

* We use Amazon Payments for payments. You can use [Stripe](https://stripe.com) or [WePay](https://www.wepay.com/). We used Kickstarter's awesome ```amazon_flex_pay``` gem.
* We collect multi-use tokens from customers with Amazon Payments - this lets us collect payment information without charging the customer until we are ready to ship
* Selfstarter doesn't come with any authentication, administration, mailers or analytics tools. We recommend adding a basic set of these so that you can message backers and manage orders.
* There is a payment options component that allows you to define different packages or levels for people to puchase/support at.  You can turn it on and off with a configuration setting.

## Getting Started

*Note: This assumes you have Ruby 1.9.2 or later installed properly and have a basic working knowledge of how to use RubyGems*

First you'll need to fork and clone this repo

```bash
git clone https://github.com/lockitron/selfstarter.git
```

Let's get all our dependencies setup:
```bash
bundle install --without production
```

Now let's create the database:
```bash
rake db:migrate
```

If you're using the payment options component (use_payment_options = true in settings.yml) then need to seed some data for the options:
```bash
rake db:seed
```

Let's get it running:
```bash
rails s
```

### Customizing

While it is *just* a skeleton, we did make it a little quicker to change around things like your product name, the colors, pricing, etc.

To change around the product name, tweet text, and more, open this file:

```
config/settings.yml
```

To change around the colors and fonts, open this file:

```
app/assets/stylesheets/variables.css.scss
```

To dive into the code, open this file:

```
app/controllers/preorder_controller.rb
```

### Deploying to Production

We recommend using Heroku, and we even include a ```Procfile``` for you. All you need to do is first install the [Heroku Toolbelt](https://toolbelt.heroku.com) and then run:

```bash
heroku create
git push heroku master
heroku run rake db:migrate
heroku open
```
## Contributing

In it's current state, Selfstarter is very skeletal. We welcome your pull requests. If you're looking to contribute, here are some good starting points.

### Email Updates

Using Amazon FPS will send users a notification when they place an order, however, it's nice to notify people when they place an order. 

Something that we built into Lockitron.com was "Remind Me" functionality. The idea behind this is that you can capture potential backers and notify them near the end of your campaign that they should reserve your product. We have no data on this yet, however, it seems to be part of why Kickstarter campaigns pick up a lot of steam in their final hours.

### Reporting

There is no admin panel with Selfstarter. This could be useful when the project's funding time is over and you want to export your orders elsewhere.

Relatedly, some analytics would be nice. It'd be good to know how many reservations you receive over time, as well as the specifics of each order. Customers may have questions or might want to modify their order after they've placed it.

### Alternate Payment Processors

Amazon Payments works great for us, but it may not work out for everyone. If you'd rather use Stripe, WePay, or any other payment processor, feel free to send out a pull request.

### Tests

There aren't any tests yet. Tests are very welcome!

## License

Selfstarter is licensed under the [MIT License](https://tldrlegal.com/license/mit-license).
