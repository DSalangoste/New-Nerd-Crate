# Create categories
categories = {
  'Gaming' => {
    description: 'Video games, gaming accessories, and gaming culture items',
    crate_types: ['Gaming Crate - Small', 'Gaming Crate - Medium', 'Gaming Crate - Large']
  },
  'Anime' => {
    description: 'Anime merchandise, figures, and collectibles',
    crate_types: ['Anime Crate - Small', 'Anime Crate - Medium', 'Anime Crate - Large']
  },
  'Comics' => {
    description: 'Comic books, graphic novels, and superhero merchandise',
    crate_types: ['Comic Crate - Small', 'Comic Crate - Medium', 'Comic Crate - Large']
  },
  'Special' => {
    description: 'Special themed crates that combine multiple categories or offer unique items',
    crate_types: ['All-in-One Crate', 'Japanese Treats Crate']
  }
}

# Create crate types
crate_types = {
  'Gaming Crate - Small' => {
    price: 30.00,
    description: 'Gaming goodies and collectibles (Small)',
    category_name: 'Gaming'
  },
  'Gaming Crate - Medium' => {
    price: 50.00,
    description: 'Gaming goodies and collectibles (Medium)',
    category_name: 'Gaming'
  },
  'Gaming Crate - Large' => {
    price: 100.00,
    description: 'Gaming goodies and collectibles (Large)',
    category_name: 'Gaming'
  },
  'Anime Crate - Small' => {
    price: 30.00,
    description: 'Anime merchandise and collectibles (Small)',
    category_name: 'Anime'
  },
  'Anime Crate - Medium' => {
    price: 50.00,
    description: 'Anime merchandise and collectibles (Medium)',
    category_name: 'Anime'
  },
  'Anime Crate - Large' => {
    price: 100.00,
    description: 'Anime merchandise and collectibles (Large)',
    category_name: 'Anime'
  },
  'Comic Crate - Small' => {
    price: 30.00,
    description: 'Comic books and superhero merchandise (Small)',
    category_name: 'Comics'
  },
  'Comic Crate - Medium' => {
    price: 50.00,
    description: 'Comic books and superhero merchandise (Medium)',
    category_name: 'Comics'
  },
  'Comic Crate - Large' => {
    price: 100.00,
    description: 'Comic books and superhero merchandise (Large)',
    category_name: 'Comics'
  },
  'All-in-One Crate' => {
    price: 150.00,
    description: 'A premium crate featuring a mix of anime, comics, and gaming items',
    category_name: 'Special'
  },
  'Japanese Treats Crate' => {
    price: 60.00,
    description: 'A curated selection of Japanese snacks, candies, and treats',
    category_name: 'Special'
  }
}

# First, remove all existing categories and crate types to start fresh
Category.destroy_all
CrateType.destroy_all

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