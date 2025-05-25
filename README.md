# Chess Club Administration App

A Ruby on Rails application for managing a chess club, including member management, match recording, and a live leaderboard with business ranking rules.

## Features

- Member CRUD (create, read, update, delete)
- Record matches between two players
- Automatic ranking updates based on match results (with business rules)
- Games played tracking for each member
- Leaderboard view (root page) showing all members ordered by rank, with games played
- Bootstrap-styled, modern UI
- Navigation links for easy access to leaderboard, match entry, and member management

## Getting Started

### Requirements

- Ruby 3.2+
- Rails 7.1+
- PostgreSQL

### Ruby Version Management (Recommended)

This project uses [asdf](https://asdf-vm.com/) for version management. Please install asdf and the required plugins before running the setup steps. This ensures you use the correct Ruby, Node.js, and Yarn versions.

To install all required tools with asdf:

```sh
asdf plugin add ruby
asdf plugin add nodejs
asdf plugin add yarn
asdf install
```

### Setup

1. Clone the repository
2. Install dependencies:
   ```sh
   bundle install
   ```
3. Set up the database:
   ```sh
   rails db:setup
   ```
4. (Optional) Seed with demo members:
   ```sh
   rails runner db/scripts/add_members.rb
   ```
5. Start the server:
   ```sh
   bin/dev
   # or
   rails server
   ```
6. Visit [http://localhost:3000](http://localhost:3000) — the leaderboard will be the homepage.

### Running Tests

```sh
bundle exec rspec
```

## Business Logic

- When a match is recorded, both players' `games_played` is incremented.
- Rankings are updated according to business rules:
  - Higher-ranked win: no change
  - Draw: lower moves up if not adjacent
  - Lower win: higher moves down by one, lower moves up by half the difference
- Rankings are normalized after every change and after a member is deleted.

## Navigation

- Leaderboard: `/` (root)
- Members list: `/members`
- Add member: `/members/new`
- Record match: `/matches/new`

## Styling

- Uses Bootstrap 5 for all UI components and layout.

## Contributing

Pull requests welcome! Please ensure all tests pass before submitting.

---

© 2025 Chess Club Admin App
