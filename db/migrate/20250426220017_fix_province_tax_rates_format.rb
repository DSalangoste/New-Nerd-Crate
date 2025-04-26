class FixProvinceTaxRatesFormat < ActiveRecord::Migration[7.1]
  def up
    # Fix any tax rates that are stored as percentages (e.g., 5.0 for 5%)
    Province.find_each do |province|
      if province.tax_rate > 1
        # Convert from percentage to decimal (e.g., 5.0 -> 0.05)
        new_rate = province.tax_rate / 100.0
        province.update_columns(tax_rate: new_rate)
        puts "Fixed tax rate for #{province.name} (#{province.code}): #{province.tax_rate} -> #{new_rate}"
      end
    end
  end

  def down
    # No need for down migration as this is a data fix
  end
end 