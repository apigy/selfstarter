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