# Canadian Provinces and Territories
provinces_data = [
  { name: 'Alberta', code: 'AB', tax_rate: 0.05 },
  { name: 'British Columbia', code: 'BC', tax_rate: 0.12 },
  { name: 'Manitoba', code: 'MB', tax_rate: 0.12 },
  { name: 'New Brunswick', code: 'NB', tax_rate: 0.15 },
  { name: 'Newfoundland and Labrador', code: 'NL', tax_rate: 0.15 },
  { name: 'Northwest Territories', code: 'NT', tax_rate: 0.05 },
  { name: 'Nova Scotia', code: 'NS', tax_rate: 0.15 },
  { name: 'Nunavut', code: 'NU', tax_rate: 0.05 },
  { name: 'Ontario', code: 'ON', tax_rate: 0.13 },
  { name: 'Prince Edward Island', code: 'PE', tax_rate: 0.15 },
  { name: 'Quebec', code: 'QC', tax_rate: 0.14975 },
  { name: 'Saskatchewan', code: 'SK', tax_rate: 0.11 },
  { name: 'Yukon', code: 'YT', tax_rate: 0.05 }
]

provinces_data.each do |province_data|
  Province.find_or_create_by!(code: province_data[:code]) do |province|
    province.name = province_data[:name]
    province.tax_rate = province_data[:tax_rate]
  end
end 