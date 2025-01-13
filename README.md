# usman_malik_event_booking

A simple **Event Booking** system built with **Ruby on Rails**, featuring:

- **User Registration & Authentication** (Devise)  
- **Event Creation** (name, description, location, date/time, total tickets)  
- **Ticket Booking** (with concurrency checks via service objects)  
- **Caching** (using Redis)  
- **RSpec** tests (models, requests, services)

## Technologies Used
- Ruby on Rails
- PostgreSQL
- Devise
- Redis
- RSpec, FactoryBot, Faker, Shoulda-Matchers

## Getting Started
1. **Clone** the repo:
   ```bash
   git clone https://github.com/YourGitHub/usman_malik_event_booking.git
   cd usman_malik_event_booking

2. **Install dependencies**
    ```bash
    bundle install

3. **Create & migrate the database**
    ```bash
    rails db:create
    rails db:migrate

4. **Run the server**
    ```bash
    rails server
## Testing
    bundle exec rspec
1. Model specs in spec/models/
2. Request specs in spec/requests/
3. Service specs in spec/services/

## Code Structure

1. Models: User, Event, Ticket
2. Controllers: EventsController, TicketsController
3. Services: Tickets::CreateService for ticket concurrency & booking
4. Minimal Views: Devise for auth & simple forms for events/tickets

## Future Improvements
1. DB indexing
2. CI/CD & RuboCop
3. Advanced search & filtering
4. Background jobs for reminders, analytics