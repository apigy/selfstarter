# Selfstarter
Selfstarter makes it easy to roll your own crowdfunding site. To get started, fork this repository and change around ```config/settings.yml``` to suit your needs.

[See it in action](http://selfstarter.us)

## Background

After a [rejection from Kickstarter](http://techcrunch.com/2012/10/07/the-story-of-lockitron-crowdfunding-without-kickstarter/), we decided to follow in the footsteps of [App.net](https://app.net/) roll our own crowdfunding tool for [Lockitron](https://lockitron.com). We've been absolutely blown away by the response. As a first step in what will hopefully be a long history of giving back, we have decided to open source the crowdfunding platform that got us here. Please send questions, comments, or concerns to [hello@lockitron.com](mailto:hello@lockitron.com)!

Over the past week, a lot of people asked us for help with building their own crowdfunding app. This is it.

Selfstarter is starting point. We made some specific choices with Selfstarter for Lockitron and we recommend you tailor it for your project:

* We use Amazon Payments for payments. You can use [Stripe](https://stripe.com) or [WePay](https://www.wepay.com/). We used Kickstarter's awesome ```amazon_flex_pay``` gem.
* We collect multi-use tokens from customers with Amazon Payments - this let's us collect payment information without charging the customer until we are ready to ship
* Selfstarter doesn't come with any authentication, administration, mailers or analytics tools. We recommend adding a basic set of these so that you can message backers and manage orders.

## Getting Started

First you'll need to fork and clone this repo

Let's get all our dependencies setup:
```bash
bundle install --without production
```

Now let's create the database:
```bash
rake db:migrate
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

We recommend using Heroku, and we even include a ```Procfile``` for you. All you need to do is run:

```bash
gem install heroku
heroku create
git push heroku master
heroku run rake db:migrate
```