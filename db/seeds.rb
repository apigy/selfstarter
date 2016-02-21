

########## from the original:This line destroys all PaymentOption instances that exist in the DB - it does exactly a reset to the PaymentOptions
#  PaymentOption.destroy_all;



=begin (this =begin and =end is a multi-line comment in ruby) this is in case you want to bring back the old method of doing the seed.
  
  Since it destroys all paymentoptions with the previous command it's safe to create them all without any 
special concern, which is what the following action does,

  amount::: should be in decimals since it's converted for stripe into integer in the preorder controller.
  This is the real amount a user gets charged when paying with this option selected. 
  200$ is 200.00, 2$ is 2.00, 20cents is 0.20

  amount_display::: Is what is shown in the view - this is just for information and should accurately
  reflect the real value set in amount - your app doesn't use this information for anything else

  description::: is what appears written on that option and can contain html tags, which means you can 
write html inside of it to control how it shows up, include images, bold, color, etc.

  shipping_desc // delivery_desc ::: self-explanatory

  limit: -1 means without limit, other integer number > 0 means the number of available perks of this type.

  currency: I've fixed the main controller to attribute 'USD' as the currency for the charge in case this is missing, but it should be set here as well
  Because the problem is, it checked that there was an option assigned, so it loaded the values from that option, but since it didn't have a currency
it would throw an error, because it wouldn't fetch it from the global settings (since it "had" options), now in the controller it explicitly check for
the currency here if the options are available, and in case the options don't have a currency, it sets it.
  
  Unless you're already online and running you are able to use this without much hassle, simply by executing a rake db:seed 
on heroku, it will destroy everything and then create everything again. If on the other hand you are already online
you might want to do it differently. I created a different seed on the end of this file and commented it out.

  To add a new field to the options such as currency, you just write it as the others "currency: value" and put a comma in the previous line.
  

PaymentOption.create(
    [
        {
            amount: 10.00,
            amount_display: '$999',
            description: '<strong>Basic level: </strong>You receive a great big thankyou from us!  You Rock',
            shipping_desc: '',
            delivery_desc: '',
            limit: -1,
            currency: 'USD'
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

=end

### The new method
    
if PaymentOption.count == 0
  PaymentOption.create(
      [
          {
              amount: 10.00,
              amount_display: '$10',
              description: '<strong>Basic level: </strong>You receive a great big thankyou from us!  You Rock',
              shipping_desc: '',
              delivery_desc: '',
              limit: -1,
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
    payments = PaymentOption.all
    payments.each do |payment|
      payment.update!(currency: 'USD')
    end
else 
=begin
  PaymentOption.find(9).update!(
    amount: "1000.00",
    amount_display: "$1000",
    description: "<strong>Updating a single record</strong> (the one with id 1 - set by .find(1)) without destroying records.</br>",
    shipping_desc: "add $3 to ship outside the US",
    delivery_desc: "Estimated delivery: Oct 2013",
    limit: -1
  )
=end
end
    
       
    