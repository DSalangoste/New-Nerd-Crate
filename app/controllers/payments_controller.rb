class PaymentsController < ApplicationController
  def create
    @order = Order.find(params[:order_id])
    
    begin
      payment_intent = Stripe::PaymentIntent.create({
        amount: (@order.total * 100).to_i, # Stripe expects amounts in cents
        currency: 'usd',
        payment_method_types: ['card'],
        metadata: {
          order_id: @order.id
        }
      })

      render json: {
        clientSecret: payment_intent.client_secret
      }
    rescue => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  def webhook
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    endpoint_secret = Rails.application.credentials.stripe[:webhook_secret]

    begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, endpoint_secret
      )
    rescue JSON::ParserError => e
      render json: { error: e.message }, status: :bad_request
      return
    rescue Stripe::SignatureVerificationError => e
      render json: { error: e.message }, status: :bad_request
      return
    end

    if event['type'] == 'payment_intent.succeeded'
      payment_intent = event.data.object
      order = Order.find(payment_intent.metadata.order_id)
      
      order.update(status: :paid)
      Payment.create!(
        order: order,
        amount: payment_intent.amount / 100.0,
        status: 'completed',
        payment_method: 'stripe',
        transaction_id: payment_intent.id
      )
    end

    render json: { received: true }
  end
end 