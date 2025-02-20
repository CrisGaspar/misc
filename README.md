# BMA Municipal Study

A TypeScript web application for analyzing municipal data, built with Bun.

## Prerequisites

- [Bun](https://bun.sh) runtime installed
- Node.js 16.0.0 or later (for some dependencies)

## Installation

1. Clone the repository
2. Install dependencies:
```bash
bun install
```

## Development

Run the development server with hot reload:
```bash
bun run dev
```

## Production

Start the production server:
```bash
bun run start
```

The application will be available at `http://localhost:3000`.

## Project Structure

```
.
├── src/
│   ├── app.ts              # Main application entry point
│   ├── bma_constants.ts    # Constants and configuration
│   └── bma_utils.ts        # Utility functions
├── public/
│   ├── login.html         # Login page
│   └── dashboard.html     # Main dashboard
├── package.json
├── tsconfig.json
└── README.md
```

## Features

- User authentication
- Municipal data analysis
- Excel file upload and processing
- Data visualization
- Year-over-year comparisons
- Custom municipality grouping

## API Endpoints

- `POST /login` - User authentication
- `GET /municipalities` - Get municipalities for a year
- `GET /municipality-groups` - Get municipality groups
- `POST /data-by-years` - Get data filtered by years
- `POST /upload` - Upload Excel files

## Development Notes

This is a TypeScript port of the original R Shiny application. Key changes include:

1. Using Bun's native HTTP server instead of Express/Elysia
2. Native fetch API for HTTP requests
3. Modern async/await patterns
4. TypeScript type safety
5. Improved error handling
