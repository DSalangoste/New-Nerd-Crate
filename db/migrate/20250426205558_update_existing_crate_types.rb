class UpdateExistingCrateTypes < ActiveRecord::Migration[7.1]
  def up
    # Add unique constraint to categories name
    execute <<-SQL
      ALTER TABLE categories ADD CONSTRAINT categories_name_key UNIQUE (name);
    SQL

    # Create categories if they don't exist
    categories = {
      'Gaming' => 'Video games, gaming accessories, and gaming-related merchandise',
      'Anime' => 'Anime merchandise, figures, and collectibles',
      'Comics' => 'Comic books, graphic novels, and comic-related items'
    }

    categories.each do |name, description|
      execute <<-SQL
        INSERT INTO categories (name, description, created_at, updated_at)
        VALUES ('#{name}', '#{description}', NOW(), NOW())
        ON CONFLICT (name) DO UPDATE
        SET description = '#{description}', updated_at = NOW();
      SQL
    end

    # Add unique constraint to crate_types name
    execute <<-SQL
      ALTER TABLE crate_types ADD CONSTRAINT crate_types_name_key UNIQUE (name);
    SQL

    # Create crate types with sizes
    crate_types = [
      # Gaming Crates
      {
        name: 'Gaming Crate - Small',
        description: 'Gaming goodies and collectibles (Small)',
        price: 30.0,
        category_name: 'Gaming'
      },
      {
        name: 'Gaming Crate - Medium',
        description: 'Gaming goodies and collectibles (Medium)',
        price: 50.0,
        category_name: 'Gaming'
      },
      {
        name: 'Gaming Crate - Large',
        description: 'Gaming goodies and collectibles (Large)',
        price: 100.0,
        category_name: 'Gaming'
      },
      # Anime Crates
      {
        name: 'Anime Crate - Small',
        description: 'Anime merchandise and collectibles (Small)',
        price: 30.0,
        category_name: 'Anime'
      },
      {
        name: 'Anime Crate - Medium',
        description: 'Anime merchandise and collectibles (Medium)',
        price: 50.0,
        category_name: 'Anime'
      },
      {
        name: 'Anime Crate - Large',
        description: 'Anime merchandise and collectibles (Large)',
        price: 100.0,
        category_name: 'Anime'
      },
      # Comic Crates
      {
        name: 'Comic Crate - Small',
        description: 'Comic books and superhero merchandise (Small)',
        price: 30.0,
        category_name: 'Comics'
      },
      {
        name: 'Comic Crate - Medium',
        description: 'Comic books and superhero merchandise (Medium)',
        price: 50.0,
        category_name: 'Comics'
      },
      {
        name: 'Comic Crate - Large',
        description: 'Comic books and superhero merchandise (Large)',
        price: 100.0,
        category_name: 'Comics'
      },
      # Special Crates
      {
        name: 'All-in-One Crate',
        description: 'A premium crate featuring a mix of anime, comics, and gaming items',
        price: 150.0,
        category_name: ['Gaming', 'Anime', 'Comics']
      },
      {
        name: 'Japanese Treats Crate',
        description: 'A curated selection of Japanese snacks, candies, and treats',
        price: 60.0,
        category_name: ['Anime']
      }
    ]

    crate_types.each do |crate_type|
      category_names = Array(crate_type[:category_name])
      
      execute <<-SQL
        WITH category_ids AS (
          SELECT id FROM categories WHERE name = ANY(ARRAY['#{category_names.join("','")}'])
        )
        INSERT INTO crate_types (name, description, price, created_at, updated_at)
        VALUES (
          '#{crate_type[:name]}',
          '#{crate_type[:description]}',
          #{crate_type[:price]},
          NOW(),
          NOW()
        )
        ON CONFLICT (name) DO UPDATE
        SET description = '#{crate_type[:description]}',
            price = #{crate_type[:price]},
            updated_at = NOW();
      SQL

      # Add category associations if they don't exist
      category_names.each do |category_name|
        execute <<-SQL
          INSERT INTO categories_crate_types (category_id, crate_type_id)
          SELECT c.id, ct.id
          FROM categories c
          CROSS JOIN crate_types ct
          WHERE c.name = '#{category_name}'
          AND ct.name = '#{crate_type[:name]}'
          AND NOT EXISTS (
            SELECT 1
            FROM categories_crate_types cct
            WHERE cct.category_id = c.id
            AND cct.crate_type_id = ct.id
          );
        SQL
      end
    end
  end

  def down
    # Remove unique constraints
    execute <<-SQL
      ALTER TABLE categories DROP CONSTRAINT IF EXISTS categories_name_key;
      ALTER TABLE crate_types DROP CONSTRAINT IF EXISTS crate_types_name_key;
    SQL
  end
end

