describe StripeWrapper::Charge do
  describe ".create" do
    it "successfully charges card", :vcr do
      Stripe.api_key = ENV['STRIPE_SECRET_KEY']
      token = Stripe::Token.create(
        card: {
          number: "4242424242424242",
          exp_month: 6,
          exp_year: Date.today.year + 1,
          cvc: 123
        }
      ).id

      response = StripeWrapper::Charge.create(
        :amount => 999,
        :currency => "usd",
        :source => token,
        :description => "stripe charge"
      )

      expect(response).to be_successful
    end

    it "makes a decline charge", :vcr do
      Stripe.api_key = ENV['STRIPE_SECRET_KEY']
      token = Stripe::Token.create(
        card: {
          number: "4000000000000002",
          exp_month: 6,
          exp_year: Date.today.year + 1,
          cvc: 123
        }
      ).id

      response = StripeWrapper::Charge.create(
        :amount => 999,
        :currency => "usd",
        :source => token,
        :description => "stripe charge"
      )

      expect(response).not_to be_successful 
    end

    it "returns error message", :vcr do
      Stripe.api_key = ENV['STRIPE_SECRET_KEY']
      token = Stripe::Token.create(
        card: {
          number: "4000000000000002",
          exp_month: 6,
          exp_year: Date.today.year + 1,
          cvc: 123
        }
      ).id

      response = StripeWrapper::Charge.create(
        :amount => 999,
        :currency => "usd",
        :source => token,
        :description => "stripe charge"
      )

      expect(response.error_message).to eq("Your card was declined.")
    end
  end
end