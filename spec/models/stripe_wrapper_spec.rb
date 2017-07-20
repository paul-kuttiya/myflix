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

      response = Stripe::Charge.create(
        :amount => 999,
        :currency => "usd",
        :source => token,
        :description => "stripe charge"
      )

      expect(response.amount).to eq 999
      expect(response.currency).to eq "usd"
    end
  end
end