# Bookify Backend API (Spring Boot)

Spring Boot backend for the Bookify SaaS platform. It handles core business logic including auth, booking workflows, business and staff operations, notifications, and integrations with AI and tracking services.

## Tech Stack

- Java 21
- Spring Boot 3
- Spring Security
- Spring Data JPA (Hibernate)
- MySQL
- Maven Wrapper
- SpringDoc OpenAPI (Swagger UI)

## Prerequisites

- Java 21+
- MySQL 8+
- Git Bash or shell terminal (macOS/Linux), or PowerShell on Windows

## Quick Start

1. Install/confirm MySQL and create access for your local user.
2. Copy env template and set values:

```bash
cp .env.example .env
```

3. Run locally:

macOS/Linux:

```bash
./scripts/run-local.sh
```

Windows PowerShell:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
./scripts/run-local.ps1 -SkipTests
```

Alternative direct run:

```bash
./mvnw spring-boot:run
```

The server runs on `http://localhost:8088` with context path `/api`.

## Build and Test

```bash
./mvnw clean test
./mvnw clean package
```

## API Documentation

Swagger UI:

- `http://localhost:8088/api/swagger-ui.html`

OpenAPI JSON:

- `http://localhost:8088/api/v3/api-docs`

## Core Configuration

Main runtime settings are in `src/main/resources/application.properties`.

Common environment variables:

```env
GEMINI_API_KEY=
SPRING_MAIL_PASSWORD=
APP_FRONTEND_URL=http://localhost:3000
TRACKING_SERVICE_BASE_URL=http://localhost:5000/api
TRACKING_SERVICE_API_KEY=your-tracking-api-key
TRACKING_SERVICE_TIMEOUT_MS=1000
```

## Integrations

- AI evaluation integration via Gemini API key (`GEMINI_API_KEY`).
- Tracking profile snapshot fallback integration via tracking backend (`TRACKING_SERVICE_BASE_URL`).
- Email/notification integrations (SMTP and optional Telegram settings).

## Security Notes

- Do not commit `.env` or real secrets.
- Keep API keys and bot tokens in environment variables.
- Rotate exposed secrets immediately if leaked.

## Project Structure (High Level)

- `src/main/java`: Domain logic, controllers, services, repositories, security.
- `src/main/resources`: Application configuration and static resources.
- `scripts`: Local startup scripts for Unix and Windows.

## Troubleshooting

- Startup fails on DB connection:
  - Verify MySQL is running and credentials in `application.properties` are valid.
- 401/403 auth issues:
  - Check JWT configuration and request headers.
- Tracking fallback not working:
  - Confirm tracking backend is reachable and API key matches.
- AI features not available:
  - Ensure `GEMINI_API_KEY` is set in environment before startup.

## License and Copyright

This repository is proprietary.

Copyright (c) 2026 StoonProduction. All rights reserved.

No right is granted to use, copy, edit, modify, distribute, or create derivative works without prior written permission from StoonProduction.

See `LICENSE` in this repository and `../LICENSE` at workspace root for full terms.
