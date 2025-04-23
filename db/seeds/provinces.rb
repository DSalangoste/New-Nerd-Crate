# Canadian Provinces and Territories
provinces_data = [
  { name: 'Alberta', code: 'AB', tax_rate: 5.0 },
  { name: 'British Columbia', code: 'BC', tax_rate: 12.0 },
  { name: 'Manitoba', code: 'MB', tax_rate: 12.0 },
  { name: 'New Brunswick', code: 'NB', tax_rate: 15.0 },
  { name: 'Newfoundland and Labrador', code: 'NL', tax_rate: 15.0 },
  { name: 'Northwest Territories', code: 'NT', tax_rate: 5.0 },
  { name: 'Nova Scotia', code: 'NS', tax_rate: 15.0 },
  { name: 'Nunavut', code: 'NU', tax_rate: 5.0 },
  { name: 'Ontario', code: 'ON', tax_rate: 13.0 },
  { name: 'Prince Edward Island', code: 'PE', tax_rate: 15.0 },
  { name: 'Quebec', code: 'QC', tax_rate: 14.975 },
  { name: 'Saskatchewan', code: 'SK', tax_rate: 11.0 },
  { name: 'Yukon', code: 'YT', tax_rate: 5.0 }
]

provinces_data.each do |province_data|
  Province.find_or_create_by!(code: province_data[:code]) do |province|
    province.name = province_data[:name]
    province.tax_rate = province_data[:tax_rate]
  end
end 