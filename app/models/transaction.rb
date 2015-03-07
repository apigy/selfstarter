require 'pagarme'
# example:
# PagarMe.api_key = "ak_test_Po52jGJ5XIWiutdmkZc7lpccveMUoh";
PagarMe.api_key = "ak_test_Po52jGJ5XIWiutdmkZc7lpccveMUoh";
class Transaction < ActiveRecord::Base
  belongs_to :payment

  def self.save_transaction(payment)
    @transaction =  Transaction.new(
      amount: payment.payment_amount,
      card_hash: payment.card_hash,
      payment_id: payment.id
    )

    pagarme_transaction = PagarMe::Transaction.new(
      {
        amount: @transaction.amount,
        card_hash: @transaction.card_hash
      }
    )
    pagarme_transaction.charge

    @transaction.status = pagarme_transaction.status
    @transaction.save
  end
end
