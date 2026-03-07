# Frontend Integration Guide: Zeppelin API

This document describes how the React frontend should communicate with the Django backend for authentication and questionnaire completion.

---

## Basic concepts

Every authenticated request must include a token in the HTTP header. This token is obtained at login and must be stored in the frontend (in memory or `localStorage`) to be reused in subsequent calls.

```
Authorization: Bearer YOUR_ACCESS_TOKEN
```

Without this header, the backend returns `401 Unauthorized`.

---

## Complete user flow

The user goes through four stages in the application:

**1. Organization search**: the user types the company name and the frontend searches for existing organizations. If the company already exists, the user selects it. If not, a new one will be created in the next step. *[can be skipped depending on the chosen workflow, as a default Organization can be assigned to the user instead of allowing the user to search for their own]*

**2. User registration**: the user creates an account with their name, email and password. If the organization already existed, its `id` is sent. If not, the organization name is sent and the backend creates both at once.

**3. Login**: the user exchanges their credentials for an `access_token`. From this point, all requests use this token.

**4. Questionnaire**: the user answers the questionnaire. The frontend loads the questions and available response levels, creates a questionnaire session, and sends each answer individually.

---

## Endpoint table

| Stage | Method | Endpoint | Authentication |
|---|---|---|---|
| Search organizations | GET | `/organization/organization/?search=name` | No |
| Register user (+ organization) | POST | `/auth/register/` | No |
| Login | POST | `/o/token/` | No |
| Refresh token | POST | `/o/token/` | No |
| List questions | GET | `/questionnaire/statement/` | Yes |
| List response levels | GET | `/questionnaire/adoptedlevel/` | Yes |
| Create questionnaire session | POST | `/questionnaire/questionnaire/` | Yes |
| Submit answer | POST | `/questionnaire/answer/` | Yes |

---

## Stage 1: Search for existing organization

This endpoint is public and does not require authentication.
> This can be changed by following the instructions in the `../organization/api_views.py` > `OrganizationViewSet()`  class

### Request

```js
const search = 'My Company'; // typed by the user

const response = await fetch(
  `http://localhost:8000/organization/organization/?search=${encodeURIComponent(search)}`
);

const data = await response.json();
const organizations = data.results; // list of matching organizations
```

### Expected response

```json
{
  "count": 1,
  "next": null,
  "previous": null,
  "results": [
    {
      "id": 1,
      "name": "My Company Ltd",
      "description": "Technology company"
    }
  ]
}
```

If `results` is empty, the organization does not exist yet and should be created in the next step.

---

## Stage 2: User registration

This endpoint is public and does not require authentication. It handles two scenarios:

**Scenario A: Organization already exists:** send `organization_id` with the id selected by the user in Stage 1.

**Scenario B: Organization does not exist yet:** send `organization_name` (and optionally `organization_description`) and the backend creates both the organization and the user at once.

Only one of the two (`organization_id` or `organization_name`) is required. If both are sent, `organization_id` takes precedence.

> **Optional - Default organization:** if the team decides to skip the organization search flow, the frontend can pass a pre-defined default organization `id` directly in `organization_id`. In this case the user is registered immediately without going through Stage 1. The default organization `id` should be agreed upon with the backend team.

### Request: Scenario A (existing organization)

```js
const response = await fetch('http://localhost:8000/auth/register/', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    username: 'john.doe',
    email: 'john@company.com',
    password: 'mypassword123',
    role: 'Developer',
    organization_id: 1
  })
});

const data = await response.json();
const employeeId = data.employee_id;
const organizationId = data.organization_id;
```

### Request: Scenario B (new organization)

```js
const response = await fetch('http://localhost:8000/auth/register/', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    username: 'john.doe',
    email: 'john@company.com',
    password: 'mypassword123',
    role: 'Developer',
    organization_name: 'My Company Ltd',
    organization_description: 'Technology company'
  })
});

const data = await response.json();
const employeeId = data.employee_id;
const organizationId = data.organization_id;
```

### Expected response (both scenarios)

```json
{
  "user_id": 1,
  "employee_id": 1,
  "organization_id": 1
}
```

### Possible errors

```json
{ "error": "username and password are required" }
{ "error": "Provide organization_id or organization_name" }
{ "error": "User already exists" }
{ "error": "Organization not found" }
```

---

## Stage 3: Login

Login uses a different format from other endpoints: `application/x-www-form-urlencoded` instead of JSON. In addition to the user credentials, the `client_id` and `client_secret` of the OAuth2 application are required (they can be obtained by creating the OAuth2 application in Django Admin).

### Request

```js
const params = new URLSearchParams();
params.append('grant_type', 'password');
params.append('username', 'john.doe');
params.append('password', 'mypassword123');
params.append('client_id', 'YOUR_CLIENT_ID');
params.append('client_secret', 'YOUR_CLIENT_SECRET');

const response = await fetch('http://localhost:8000/o/token/', {
  method: 'POST',
  headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
  body: params
});

const data = await response.json();
const accessToken = data.access_token;   // save this for all authenticated requests
const refreshToken = data.refresh_token; // save this to renew the token later
```

### Expected response

```json
{
  "access_token": "abc123xyz...",
  "token_type": "Bearer",
  "expires_in": 36000,
  "refresh_token": "def456...",
  "scope": "read write"
}
```

The token expires in 10 hours (`expires_in: 36000` seconds). After that, use the `refresh_token` to renew it without asking for credentials again:

```js
const params = new URLSearchParams();
params.append('grant_type', 'refresh_token');
params.append('refresh_token', savedRefreshToken);
params.append('client_id', 'YOUR_CLIENT_ID');
params.append('client_secret', 'YOUR_CLIENT_SECRET');

const response = await fetch('http://localhost:8000/o/token/', {
  method: 'POST',
  headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
  body: params
});
```

---

## Stage 4: Questionnaire

From here, all requests require the authentication header. A good practice is to create a helper function:

```js
const authFetch = (url, options = {}) => {
  return fetch(url, {
    ...options,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${accessToken}`,
      ...options.headers
    }
  });
};
```

### 4a. Load questions and response levels

Make both requests at the same time to save time:

```js
const [statementsRes, levelsRes] = await Promise.all([
  authFetch('http://localhost:8000/questionnaire/statement/'),
  authFetch('http://localhost:8000/questionnaire/adoptedlevel/')
]);

const statementsData = await statementsRes.json();
const levelsData = await levelsRes.json();

const statements = statementsData.results;
const levels = levelsData.results;
```

Each question (`statement`) will have the following structure:

```json
{
  "id": 1,
  "code": "P01",
  "text": "Does the team use continuous integration?",
  "sth_stage": { "id": 1, "name": "Initial Stage" },
  "pe_element": {
    "id": 2,
    "name": "Automation",
    "dimension": { "name": "Process" }
  }
}
```

Each response level (`adoptedlevel`) will have:

```json
{
  "id": 1,
  "name": "Not adopted",
  "description": "The practice is not used",
  "percentage": 0
}
```

### 4b. Create questionnaire session

```js
const questionnaireRes = await authFetch('http://localhost:8000/questionnaire/questionnaire/', {
  method: 'POST',
  body: JSON.stringify({
    employee_questionnaire: employeeId,
    applied_date: new Date().toISOString()
  })
});

const questionnaire = await questionnaireRes.json();
const questionnaireId = questionnaire.id;
```

### 4c. Submit answers

For each answered question, send one request:

```js
const sendAnswer = async (statementId, adoptedLevelId, comment = '') => {
  const response = await authFetch('http://localhost:8000/questionnaire/answer/', {
    method: 'POST',
    body: JSON.stringify({
      questionnaire_answer: questionnaireId,
      statement_answer: statementId,
      adopted_level_answer: adoptedLevelId,
      organization_answer: organizationId,
      comment_answer: comment
    })
  });
  return response.json();
};

// Example usage when the user confirms an answer:
await sendAnswer(statement.id, selectedLevel.id, 'We have been using this since 2022');
```

---

## Summary of values that need to be kept between stages

| Value | Obtained in | Used in |
|---|---|---|
| `organizationId` | Stage 2 | Stage 4c |
| `employeeId` | Stage 2 | Stage 4b |
| `accessToken` | Stage 3 | All authenticated stages |
| `refreshToken` | Stage 3 | Token renewal |
| `questionnaireId` | Stage 4b | Stage 4c |

---

## Common errors

**`401 Unauthorized`**: the token was not sent, has expired, or is incorrect. Check the `Authorization` header.

**`400 Bad Request`**: a required field is missing or has an invalid value. Check the request body.

**`403 Forbidden`**: the token exists but does not have permission for that operation.

**`404 Not Found`**: the resource does not exist. Check if the `id` being used is correct.