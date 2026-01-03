# 24H Fullstack case study

## Context
Your team is building a global monitoring system for natural disasters which ingests real-time
earthquake data, stores it efficiently, and makes it available for visualization and downstream
analytics. The system includes:

- A secure web application for authenticated users to explore recent earthquakes.
- A backend API and database to ingest and store earthquake data.
- A CLI tool that transforms earthquake-related images for enhanced visualization.
- A 3D visualization component that displays processed images interactively.

## Your mission
Deliver a fully working codebase that runs locally via Docker. You are free to choose the tech stack,
but it should reflect production-grade decisions. The system should include:
1. SWA (Secure Web App)
   - Login/logout functionality.
   - Authenticated access to:
      - List[X]: A paginated list of recent earthquakes.
      - Detail[X]: A detail page for a selected earthquake.
   - Each earthquake (X) should include:
      - Title (e.g., location or event name)
      - Image (e.g., generated or fetched from a random image API)
      - Description (e.g., magnitude, depth, time)
   - The Detail[X] page should:
      - Use the output of the CLI app to generate a 3D visualization of the earthquake image.
      - Display metadata and processed image.

2. API + DB
  - Ingest earthquake data from a public source (e.g., USGS Earthquake API).
  - Store data in PostgreSQL (e.g., PostGIS).
  - Provide endpoints for:
    - Listing earthquakes with filters (e.g., magnitude, date)
    - Fetching details by ID
  • Include basic audit/versioning (e.g., timestamps, change logs)
3. CLI App
  - Accept an image path or URL as input.
  - Perform a transformation (e.g., edge detection, FFT, etc.)
  - Output a processed image suitable for 3D visualization.
  - Must take >10 seconds to complete (simulate if needed).
  - Should be callable from the API or manually.

## Tech Expectations
- Use Docker for setup and orchestration.
- Include a README.md with setup instructions and design decisions.
- Use environment variables for secrets/configs.
- Use modern frameworks (e.g., React/Vue + FastAPI/Express).
- Use authentication (OAuth or session-based).
- Optional: Include a simple dashboard or map visualization.

## Deliverables
A GitHub repo containing:
- All source code from the frontend, backend, CLI app and database setup
- A README with setup instructions, architecture overview, and design decisions
- Docker configuration to run the project locally
- Screenshots or screen recordings (if applicable)
- Notes on architecture and performance optimizations
- Short document with your assumptions and any limitations

## Evaluation Criteria
- Code quality and structure
- Completeness and correctness of features
- UX and UI clarity
- Thoughtfulness in architecture and design
- Documentation and ease of setup
- Up to 1 extra feature of your choosing (e.g., dynamic map, vector search, RBAC, encryption)
