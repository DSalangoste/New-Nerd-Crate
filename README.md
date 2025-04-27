# NerdCrate E-Commerce Project

This is a Rails-based e-commerce platform for selling subscription crates.

## Docker Setup Instructions

### Prerequisites
- Docker
- Docker Compose
- Git

### Setup Steps

1. Clone the repository:
```bash
git clone https://github.com/DSalangoste/New-Nerd-Crate.git
cd New-Nerd-Crate
```

2. Create a `.env` file in the root directory with the following variables:
```
RAILS_MASTER_KEY=your_rails_master_key_here
POSTGRES_PASSWORD=your_postgres_password_here
```

3. Build and start the containers:
```bash
docker-compose build
docker-compose up -d
```

4. Set up the database:
```bash
docker-compose exec web rails db:create db:migrate db:seed
```

5. Access the application:
- Web application: http://localhost:3000
- Admin interface: http://localhost:3000/admin

### Common Docker Commands

- Stop the containers:
```bash
docker-compose down
```

- View logs:
```bash
docker-compose logs -f
```

- Rebuild containers:
```bash
docker-compose build --no-cache
```

- Access Rails console:
```bash
docker-compose exec web rails console
```

### Troubleshooting

If you encounter issues with the Rails master key:
1. Check if you have the `config/master.key` file
2. If not, you'll need to obtain the correct master key from the project maintainers
3. Add the key to your `.env` file as `RAILS_MASTER_KEY`

