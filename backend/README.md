# README

Deployment

* cd backend

* cp config/database.yml.example config/database.yml

* docker compose build

* docker compose up -d

Database initialization

* docker compose exec app rails db:create

* docker compose exec app rails db:migrate
