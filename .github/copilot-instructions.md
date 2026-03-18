# Copilot Instructions - backend-Saas-Kayedni

## Purpose
Use these instructions when generating or modifying code for the Java Spring Boot backend in this repository.

## Architecture Rules
- Keep strict layer flow: controller -> service interface -> service implementation -> repository.
- Controllers must only handle HTTP concerns: request parsing, DTO validation, auth principal access, and response mapping.
- Place all business logic in service implementations, not in controllers.
- Repositories are data-access boundaries and are called only from services.
- Keep API contracts on DTOs. Do not expose JPA entities directly in controller responses.
- Prefer constructor injection and clear interface boundaries for testability.

## Service and Repository Conventions
- Define public business operations in service interfaces under the services layer.
- Keep orchestration, business checks, and transactional behavior in service implementation classes.
- Use repository methods for persistence operations and avoid business branching in repositories.
- Keep query methods explicit and readable; avoid over-complex derived names when custom queries are clearer.

## Security and Validation
- Apply role checks consistently with Spring Security and @PreAuthorize where needed.
- Never log credentials, JWTs, reset tokens, or other secrets.
- Validate all incoming request DTOs with Jakarta Validation annotations.
- Return safe error messages to clients and keep sensitive details in server logs only.

## Code Quality Standards
- Favor clean, readable, and maintainable code over shortcut implementations.
- Optimize where it matters (query count, unnecessary allocations, repeated network calls), not by premature micro-optimizations.
- Follow SOLID principles and keep coupling low between modules.
- Keep methods small and purpose-driven.
- Add tests for business logic branches in service layer changes.

## Anti-patterns To Avoid
- Putting business rules in controllers.
- Calling repositories directly from controllers.
- Returning entities directly from REST endpoints.
- Mixing persistence concerns into DTO mapping utilities.
- Logging passwords, tokens, or secret keys.
- Adding role-sensitive operations without explicit authorization checks.
- Shipping code that only works for the happy path without validation and error handling.

## Change Checklist
- Is the layer direction respected?
- Are DTOs used at API boundaries?
- Are auth and role checks explicit?
- Is business logic located in service implementations?
- Are tests updated for critical logic changes?
