# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
PaymentOption.create(
    [
        {
            amount: 25.00,
            amount_display: '€25',
            description: '<strong>Challenge Coin:</strong> You receive a Milliways Camp 2015 challeng coin',
            shipping_desc: 'add €5 to ship (Free delivery at camp)',
            delivery_desc: 'Estimated delivery: August, 2015',
            limit: 500
        },
        {
            amount: 50.00,
            amount_display: '€50',
            description: '<strong>Challenge Coin + Extra for food:</strong> You receive a Milliways Camp 2015 challeng coin, includes an extra amount for food.',
            shipping_desc: 'add €5 to ship (Free delivery at camp)',
            delivery_desc: 'Estimated delivery: August, 2015',
            limit: 500
        },
        {
            amount: 125.00,
            amount_display: '€125',
            description: '<strong>Custom Dishware:</strong> You receive a Milliways Camp 2015 set of custom dishes.',
            shipping_desc: 'add €5 to ship (Free delivery at camp)',
            delivery_desc: 'Estimated delivery: August, 2015',
            limit: 500
        },
        {
            amount: 500.00,
            amount_display: '€500',
            description: '<strong>Custom Milliways Hoodie:</strong> You receive a custom embroidered Milliways hoodie.',
            shipping_desc: 'add €5 to ship (Free delivery at camp)',
            delivery_desc: 'Estimated delivery: August, 2015',
            limit: 5
        },
        {
            amount: 2500.00,
            amount_display: '€2500',
            description: '<strong>The Pub:</strong> You get to take home the Pub!  Constructed from German timber.',
            shipping_desc: 'Pick up at the end of Camp',
            delivery_desc: 'Estimated delivery: August, 2015',
            limit: 1
        }
    ])
