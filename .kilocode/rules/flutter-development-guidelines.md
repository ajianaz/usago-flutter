## Brief overview
Project-specific guidelines for Flutter development that emphasize documentation-first approach, testing, and focused implementation based on the existing codebase structure.

## Documentation adherence
- Always refer to the 'docs' directory before starting any task to ensure synchronization and clarity
- Follow all patterns already defined in the documentation
- Update relevant documentation immediately after implementation
- The docs directory contains both development/ and task/ subdirectories with important guidelines

## Testing requirements
- Create small, clear unit tests for every new function or class
- Ensure tests have a defined flow from start to finish
- Run tests periodically and manage using a checklist that records the last check date
- Test files should follow the existing structure in the test/ directory

## Development approach
- Focus on improvements that match specific user needs and directions
- Avoid over-development or adding features outside the defined scope
- Follow the existing clean architecture pattern with data/domain/presentation layers
- Maintain the existing dependency injection structure

## Code organization
- Follow the existing feature-based structure in lib/features/
- Maintain separation between data, domain, and presentation layers
- Use the existing naming conventions for files and directories
- Keep the shared widgets and utilities in their respective directories

## Implementation workflow
- Check docs/development/ and docs/task/ directories first
- Follow the patterns defined in architecture_rules.md and implementation_guide.md
- Update relevant task documentation after completing work
- Ensure all tests pass before considering a task complete