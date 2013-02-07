# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Settings.create(
    [
        {
          product_name: "Your New Crowdfunding Website",
          project_goal: 100000,
          product_description: "a set of widgets",
          product_image_path: "my-product-image.png",
          value_proposition: "Roll your own crowdfunding",
          video_embed_url: "http://www.youtube.com/v/es1OJfSDthI",
          use_video_placeholder: true,
          amazon_access_key: "YOUR_AMAZON_ACCESS_KEY",
          amazon_secret_key: "YOUR_AMAZON_SECRET_KEY",
          price: 19.95,
          use_payment_options: false,
          payment_description: "You really should change this text because people will see it on Amazon's order page!!!!!",
          charge_limit: 25.00,
          primary_stat: "backers",
          primary_stat_verb: "backer",
          middle_reserve_text: "Reserve Now",
          expiration_date: DateTime.strptime("12/31/2013 8:00", "%m/%d/%Y %H:%M"),
          progress_text: "Implemented",
          ships: "Ships...sometime",
          call_to_action: "Reserve Now",
          price_human: "It costs money!",
          dont_give_them_a_reason_to_say_no: "You'll get this exact site. All you'll need to get started is a great product.",
          facebook_app_id: "1234567890",
          tweet_text: "to crowdfund",
          google_id: "1234567890"
        }
    ]
)

PaymentOption.create(
    [
        {
            amount: 10.00,
            amount_display: '$10',
            description: '<strong>Basic level: </strong>You receive a great big thankyou from us!  You Rock',
            shipping_desc: '',
            delivery_desc: '',
            limit: -1
        },
        {
            amount: 100.00,
            amount_display: '$100',
            description: '<strong>Package 1: </strong>You receive our print edition',
            shipping_desc: 'add $3 to ship outside the US',
            delivery_desc: 'Estimated delivery: Oct 2013',
            limit: 250
        },
        {
            amount: 125.00,
            amount_display: '$125',
            description: '<strong>Package 2: </strong>You will receive both our print and digital edition',
            shipping_desc: 'add $3 to ship outside the US',
            delivery_desc: 'Estimated delivery: Oct 2013',
            limit: -1
        },
        {
            amount: 200.00,
            amount_display: '$200',
            description: '<strong>Package 3: </strong>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
            shipping_desc: 'add $3 to ship outside the US',
            delivery_desc: 'Estimated delivery: Oct 2013',
            limit: -1
        },
        {
            amount: 250.00,
            amount_display: '$250',
            description: '<strong>Package 4: </strong>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
            shipping_desc: 'add $3 to ship outside the US',
            delivery_desc: 'Estimated delivery: Oct 2013',
            limit: -1
        },
        {
            amount: 300.00,
            amount_display: '$300',
            description: '<strong>Package 5: </strong>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
            shipping_desc: 'add $3 to ship outside the US',
            delivery_desc: 'Estimated delivery: Oct 2013',
            limit: -1
        },
        {
            amount: 500.00,
            amount_display: '$500',
            description: '<strong>Package 6: </strong>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
            shipping_desc: 'add $3 to ship outside the US',
            delivery_desc: 'Estimated delivery: Oct 2013',
            limit: -1
        },
        {
            amount: 1000.00,
            amount_display: '$1000',
            description: '<strong>Package 7: </strong>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
            shipping_desc: 'add $3 to ship outside the US',
            delivery_desc: 'Estimated delivery: Oct 2013',
            limit: -1
        }
    ])