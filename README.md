# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...


- Create project
- Add migration to postgis
- Add Devise for security
- Add Papertrail
- Split into subdomains
  - api
  - app
  - cli
- Create migration to store earthquake data + papertrail

APP:
- Login page
- List page
  - Title
  - Image
  - Description
- Details page
  -  image 
- Versions page
Create job with schedule to fetch data from API source of earthquakes
API:
- Get index + Filter with pagination
- Get by id

- Job