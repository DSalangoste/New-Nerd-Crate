# Create categories
categories = {
  'Gaming' => {
    description: 'Video games, gaming accessories, and gaming culture items',
    crate_types: ['Gaming Crate']
  },
  'Anime' => {
    description: 'Anime merchandise, figures, and collectibles',
    crate_types: ['Anime Crate']
  },
  'Comics' => {
    description: 'Comic books, graphic novels, and superhero merchandise',
    crate_types: ['Comic Crate']
  }
}

# Create crate types
crate_types = {
  'Gaming Crate' => {
    price: 49.99,
    description: 'Monthly gaming goodies and collectibles',
    category_name: 'Gaming'
  },
  'Anime Crate' => {
    price: 59.99,
    description: 'Anime merchandise and collectibles',
    category_name: 'Anime'
  },
  'Comic Crate' => {
    price: 54.99,
    description: 'Comic books and superhero merchandise',
    category_name: 'Comics'
  }
}

# Create categories first
categories.each do |name, attributes|
  Category.find_or_create_by!(name: name) do |category|
    category.description = attributes[:description]
  end
end

# Then create crate types and associate them with categories
crate_types.each do |name, attributes|
  CrateType.find_or_create_by!(name: name) do |crate_type|
    crate_type.price = attributes[:price]
    crate_type.description = attributes[:description]
    
    # Associate with category
    category = Category.find_by(name: attributes[:category_name])
    crate_type.categories << category if category
  end
end 