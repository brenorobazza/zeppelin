# Frontend Testing Documentation - Zeppelin

This document explains the testing strategy, infrastructure, and patterns used in the Zeppelin frontend to ensure the quality and reliability of the Continuous Software Engineering (CSE) diagnostic instrument.

## Testing Stack

The project uses a modern testing stack integrated with **Vite 5**:

- **[Vitest](https://vitest.dev/):** A Vite-native testing framework. It's fast, supports HMR (Hot Module Replacement) for tests, and is compatible with Jest's syntax.
- **[React Testing Library (RTL)](https://testing-library.com/docs/react-testing-library/intro/):** A library for testing React components by simulating user interactions rather than implementation details.
- **[jsdom](https://github.com/jsdom/jsdom):** A pure-JavaScript implementation of web standards (specifically the DOM) used as the test environment.
- **[user-event](https://testing-library.com/docs/user-event/intro):** Simulates user events more realistically than the built-in `fireEvent`.

## File Structure

Tests are co-located with the components or pages they test, inside a `__tests__` folder:

```text
frontend/src/
├── components/
│   └── assessment/
│       ├── AssessmentTabs.jsx
│       └── __tests__/
│           ├── AssessmentTabs.test.jsx
│           └── AssessmentQuestionBody.test.jsx
└── pages/
    └── __tests__/
        └── AssessmentKeyboard.test.jsx
```

## How to Run the Tests

From the `frontend/` directory, use the following commands:

- **Run all tests once:**
  ```bash
  npm test
  ```
- **Run in Watch Mode (Development):**
  ```bash
  npm run test:watch
  ```
- **Run with Coverage (Optional):**
  ```bash
  npx vitest run --coverage
  ```

## Test Categories

### 1. Unit Tests
Focus on individual components in isolation.
- **Example:** `AssessmentTabs.test.jsx` checks if stage names and progress counters are rendered correctly.
- **Goal:** Validate UI logic and state-to-view mapping.

### 2. Integration Tests
Focus on how multiple components and services work together.
- **Example:** `AssessmentKeyboard.test.jsx` tests the full flow from clicking "Continue" to answering questions using keys `1-5` and `Enter`.
- **Goal:** Validate complex business logic like **Circular Routing** and keyboard shortcuts.

## Common Patterns Used

### AAA (Arrange, Act, Assert)
All tests follow this structure:
1. **Arrange:** Render the component and prepare the data (mocks).
2. **Act:** Simulate user actions (click, keydown).
3. **Assert:** Verify if the DOM changed or a service was called as expected.

### Service Mocking
We mock the API communication layer (`services/questionnaire.js`) to ensure tests are fast, deterministic, and don't depend on a running backend.
```javascript
vi.mock("../../services/questionnaire", () => ({
  getStatements: vi.fn(),
  saveAnswer: vi.fn(),
  // ... other methods
}));
```

### Keyboard Event Simulation
Special care is taken to test keyboard shortcuts, as they involve global event listeners and refs:
```javascript
fireEvent.keyDown(window, { key: "2" }); // Selects the 2nd option
fireEvent.keyDown(window, { key: "Enter" }); // Advances to next
```

## CI/CD Integration

Tests are automatically executed on every **Push** or **Pull Request** via GitHub Actions (`.github/workflows/ci.yml`). The pipeline will fail if any test does not pass, ensuring that the `main` branch is always stable.
