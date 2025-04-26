class FixOrderTaxCalculation < ActiveRecord::Migration[7.1]
  def up
    # Find the order with ID 1 (changed from 3 since that order doesn't exist)
    order = Order.find_by(id: 1)
    
    if order
      # Get the shipping address and province
      shipping_address = order.shipping_address
      
      if shipping_address && shipping_address.province
        # Get the correct tax rate from the province
        tax_rate = shipping_address.province.tax_rate
        
        # Recalculate the tax based on the subtotal and tax rate
        # For NB province, tax rate is 0.15 (15%)
        # For a subtotal of $50.00 (5000 cents), tax should be $7.50 (750 cents)
        new_tax_cents = (order.subtotal_cents * tax_rate).round
        
        # Update the order with the correct tax and total
        new_total_cents = order.subtotal_cents + new_tax_cents + order.shipping_cents
        
        # Update the order
        order.update_columns(
          tax_cents: new_tax_cents,
          total_cents: new_total_cents
        )
        
        puts "Fixed tax calculation for Order ##{order.id}"
        puts "Old tax: #{order.tax_cents} cents, New tax: #{new_tax_cents} cents"
        puts "Old total: #{order.total_cents} cents, New total: #{new_total_cents} cents"
      else
        puts "Order ##{order.id} does not have a shipping address with a province"
      end
    else
      puts "Order with ID 1 not found"
    end
  end

  def down
    # No need for down migration as this is a data fix
  end
end
