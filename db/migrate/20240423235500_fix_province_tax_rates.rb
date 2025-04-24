class FixProvinceTaxRates < ActiveRecord::Migration[7.0]
  def up
    # Fix tax rates for all provinces
    {
      'AB' => 0.05,
      'BC' => 0.12,
      'MB' => 0.12,
      'NB' => 0.15,
      'NL' => 0.15,
      'NS' => 0.15,
      'ON' => 0.13,
      'PE' => 0.15,
      'QC' => 0.14975,
      'SK' => 0.11,
      'NT' => 0.05,
      'NU' => 0.05,
      'YT' => 0.05
    }.each do |code, rate|
      province = Province.find_by(code: code)
      if province
        # Ensure we're setting the exact decimal value
        province.update_columns(tax_rate: BigDecimal(rate.to_s))
      end
    end
  end

  def down
    # No need for down migration as this is a data fix
  end
end 