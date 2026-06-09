# Little Scholar Product Documentation

## 1. Product Overview

Little Scholar is a child-focused learning and assessment app for early-grade students. Parents create kid profiles, generate exam papers by subject and difficulty, let children attempt those papers in a kid-friendly interface, and review performance through history, dashboards, and AI insights.

The app is designed around a backend-first data model. Durable data such as parent accounts, kid profiles, generated exam papers, exam attempts, and analytics should be stored on the backend so the same parent login can access learning data across devices.

## 2. Target Users

### Parent

Parents register or log in, create and manage kid profiles, generate exam papers, review exam performance, and request AI insights.

### Child

Children select their profile, open assigned exam papers, answer questions, and view their result after submission.

## 3. Core Product Areas

### Authentication

Parents must register or log in before using the app.

Registration collects:

- Parent name
- Email
- City
- Password
- Disclaimer acceptance

Login uses:

- Email
- Password

After login, the app stores the authenticated session in memory for the active app session. The app currently does not persist login state locally.

### Kid Profiles

Parents can create, edit, and delete kid profiles.

Kid profile fields:

- Name
- Age
- Grade
- Avatar

Supported grades in the app:

- Nursery
- LKG
- UKG
- Grade 1

Supported avatars:

- Unicorn
- Princess
- Superhero
- Space Hero
- Shield Hero

Kid profiles are backend-owned. The app keeps a temporary in-memory copy for UI rendering and uses the backend child ID for all server operations.

### Exam Paper Generation

Parents generate exam papers for a selected child.

Inputs:

- Child profile
- Subject
- Difficulty
- Question count

Supported subjects:

- English
- Maths
- Hindi
- EVS
- GK

Supported difficulty levels:

- Easy
- Medium
- Hard

The backend generates and saves exam papers against the selected child profile. Generated but unattempted exam papers are treated as pending backend records so they can appear on other devices using the same parent login.

### Pending Exam Papers

Pending exam papers are fetched from the backend for the selected child profile.

The app refreshes pending papers when:

- Exam mode opens and a child is selected
- Kid mode opens and a child is selected
- The selected child changes
- A new exam is generated

Pending exams are stored only as an in-memory UI cache in the app. The backend remains the source of truth.

### Kid Exam Attempt

Children choose their profile, see pending papers assigned to them, and start an exam.

Question support:

- Multiple choice questions
- True/false-style questions via options
- Text-entry answers when options are empty

The app evaluates answers locally for immediate result rendering, then submits the attempt to the backend using the backend exam ID. The backend should save the attempt and remove or complete the pending generated exam atomically.

### Results

After submission, children see:

- Score percentage
- Grade label
- Correct answer count
- Total question count
- Feedback message
- Question-by-question review

The local result is inserted into the in-memory results cache after the backend accepts the attempt.

### Performance Dashboard

Parents can view performance summaries by all kids or by a selected kid.

Dashboard data is fetched from persisted backend exam attempts by child profile. The app's in-memory result list is only a display cache and is replaced with backend attempt history when Performance opens or the selected child changes:

- Exams taken
- Average score
- Best score
- Exam history list

Backend-loaded history supports cross-device performance review for the same parent login.

### AI Insights

Parents can generate AI learning insights for a child after enough completed exams.

The app requires at least three completed results for meaningful insights.

AI insight output includes:

- Summary
- Strengths
- Needs practice
- Recommendations
- Suggested difficulty
- Token usage

The current app calls the backend analytics endpoint using the backend child ID. Cached AI insight persistence is not currently implemented client-side.

## 4. Backend API Contract

### Base URL

Default backend URL:

```text
https://little-scholar-server-production.up.railway.app
```

All authenticated routes use:

```text
Authorization: Bearer <accessToken>
```

All app responses are expected to use the wrapper:

```json
{
  "success": true,
  "data": {}
}
```

Error responses are expected to include:

```json
{
  "success": false,
  "error": {
    "message": "Validation failed",
    "details": []
  }
}
```

### Authentication

#### Register Parent

```http
POST /api/auth/register
```

Request:

```json
{
  "name": "Parent Name",
  "email": "parent@example.com",
  "city": "Mumbai",
  "password": "password"
}
```

#### Login Parent

```http
POST /api/auth/login
```

Request:

```json
{
  "email": "parent@example.com",
  "password": "password"
}
```

Expected auth response data:

```json
{
  "user": {
    "id": "user-id",
    "name": "Parent Name",
    "email": "parent@example.com",
    "city": "Mumbai",
    "plan": "free"
  },
  "accessToken": "token"
}
```

### Child Profiles

#### List Children

```http
GET /api/children
```

#### Create Child

```http
POST /api/children
```

Request:

```json
{
  "name": "Aarav",
  "age": 5,
  "grade": "UKG",
  "avatarUrl": "https://little-scholar.app/avatar/unicorn"
}
```

#### Update Child

```http
PUT /api/children/:childId
```

Request:

```json
{
  "name": "Aarav",
  "age": 5,
  "grade": "UKG",
  "avatarUrl": "https://little-scholar.app/avatar/unicorn"
}
```

#### Delete Child

```http
DELETE /api/children/:childId
```

The app expects deletion to remove or cascade relevant child-owned backend records according to backend policy.

### Generated Exam Papers

#### Generate And Save Exam

```http
POST /api/children/:childId/exams/generate
```

Request:

```json
{
  "subject": "Maths",
  "difficulty": "Easy",
  "questionCount": 10
}
```

The backend schema allows `grade`, but the app intentionally omits it. The backend should derive the grade from the child profile to avoid stale client-side grade mismatches.

Backend responsibilities:

- Validate the child belongs to the authenticated parent.
- Use the child profile grade unless a valid optional grade is supplied.
- Generate the exam paper.
- Save it as a pending generated exam.
- Return the saved generated exam with backend exam ID and questions.

Expected response data shape:

```json
{
  "id": "exam-id",
  "examId": "exam-id",
  "childId": "child-id",
  "grade": "UKG",
  "subject": "Maths",
  "difficulty": "Easy",
  "questionCount": 10,
  "questions": [
    {
      "id": "q1",
      "type": "mcq",
      "question": "What is 3 + 3?",
      "options": ["5", "6", "7", "8"],
      "correctAnswer": "6",
      "acceptableAnswers": ["6"],
      "explanation": "3 + 3 equals 6.",
      "topic": "Counting",
      "marks": 1
    }
  ]
}
```

The app can decode either `id` or `examId` as the backend exam identifier.

#### List Generated Exams

```http
GET /api/children/:childId/exams?status=pending
```

No request body.

Allowed status values:

- pending
- completed
- deleted

Default backend behavior should be `pending` when `status` is omitted.

The app currently requests `status=pending`.

### Exam Attempts

#### Submit Attempt

```http
POST /api/exams/:examId/attempt
```

Request:

```json
{
  "correctAnswers": 8,
  "totalMarks": 10,
  "earnedMarks": 8,
  "scorePercentage": 80,
  "timeSpentSeconds": null,
  "answers": {
    "q1": "6",
    "q2": "True"
  },
  "strongTopics": ["Counting"],
  "weakTopics": ["Subtraction"],
  "attemptedAt": "2026-06-09T10:30:00.000Z"
}
```

Only `correctAnswers` is required by the backend. The app also sends marks, answer map, topics, score percentage, and timestamp when available.

Backend responsibilities:

- Validate the exam belongs to the authenticated parent and child.
- Save the attempt/result.
- Snapshot enough question and answer detail to preserve history after the generated exam is removed.
- Delete, complete, or mark the generated exam as no longer pending in the same transaction.

The app treats any `2xx` response as successful for this endpoint. The response body may be empty, a generic success object, or the saved attempt.

### AI Analytics

#### Generate AI Insight

```http
POST /api/analytics/generate
```

Request:

```json
{
  "childId": "child-id",
  "period": "all_time"
}
```

Expected response data:

```json
{
  "id": "insight-id",
  "childId": "child-id",
  "period": "all_time",
  "summary": "Short summary",
  "strengths": ["Counting"],
  "needsPractice": ["Subtraction"],
  "recommendations": ["Practice number bonds"],
  "suggestedDifficulty": "Easy",
  "createdAt": "2026-06-09T10:30:00.000Z",
  "usage": {
    "tokensUsed": 100,
    "remainingTokens": 900,
    "monthlyLimit": 1000
  }
}
```

## 5. App Data Ownership

### Backend-Owned Data

The following should be durable backend records:

- Parent account
- Auth token/session source
- Child profiles
- Generated exam papers
- Pending/completed/deleted generated exam status
- Exam attempts/results
- AI insight records or generated analytics responses

### App In-Memory Cache

The app keeps temporary state for:

- Authenticated parent details
- Loaded child profiles
- Pending generated exams for selected kids
- Latest result in the active session
- Results shown in dashboard during the active session

The app currently does not use SwiftData, UserDefaults, `@AppStorage`, browser local storage, or session storage for durable app data.

## 6. Important Product Workflows

### Parent Registration/Login

1. Parent opens app.
2. If not registered/logged in, parent sees registration or login.
3. App calls backend auth endpoint.
4. On success, app stores session details in memory.
5. App loads child profiles from backend.

### Create Kid Profile

1. Parent opens Parent mode.
2. Parent enters child details.
3. App calls `POST /api/children`.
4. Backend returns saved child profile.
5. App displays profile in UI.

### Generate Pending Exam

1. Parent opens Exam mode.
2. Parent selects child, subject, difficulty, and question count.
3. App calls `POST /api/children/:childId/exams/generate`.
4. Backend creates and saves pending generated exam.
5. App displays returned exam in pending papers.

### Retrieve Pending Exams

1. User opens Exam mode or Kid mode.
2. User selects a child profile.
3. App calls `GET /api/children/:childId/exams?status=pending`.
4. App replaces local pending-exam cache for that child.

### Child Attempts Exam

1. Child opens Kid mode.
2. Child selects their profile.
3. App fetches pending exams for that child.
4. Child starts and completes an exam.
5. App evaluates locally for immediate feedback.
6. App calls `POST /api/exams/:examId/attempt`.
7. Backend saves attempt and removes/completes generated exam.
8. App removes pending exam from local cache and shows result.

### Parent Reviews Performance

1. Parent opens Performance mode.
2. App calls `GET /api/exam-attempts/children/{childId}` for the selected child, or for each child when viewing all kids.
3. App maps returned attempts into the performance summary and exam history list.

### Generate AI Insight

1. Parent opens AI Insights mode.
2. Parent selects a child.
3. App requires at least three completed results in the active result cache.
4. App calls `POST /api/analytics/generate`.
5. App renders AI insight response.

## 7. Current Limitations

- Login/session is in-memory only; users may need to log in again after app restart.
- Backend-loaded performance history is summary-level unless the attempt history response includes question-level evaluation detail.
- AI insight eligibility is calculated from the displayed result cache, which is refreshed from backend attempt history when Performance is opened.
- The app expects generated exam response questions to include enough answer metadata for local evaluation.
- Full build verification is currently blocked in this environment by local Xcode/CoreSimulator asset catalog issues, not by known Swift source errors.

## 8. Recommended Backend Additions

To complete the backend-first product design, implement or confirm:

- Persisted generated exams with statuses: `pending`, `completed`, `deleted`.
- `GET /api/children/:childId/exams?status=pending`.
- Atomic `POST /api/exams/:examId/attempt` that saves attempt and removes/completes the pending exam.
- Attempt history endpoint for performance dashboard:

```http
GET /api/exam-attempts/children/{childId}
```

- Optional AI insight history endpoint if insights should persist across devices.
- Refresh-token or session persistence strategy if users should remain logged in across app launches.

## 9. Acceptance Criteria

### Multi-Device Pending Exam Continuity

Given a parent generates an exam for a child on device A, when the same parent logs in on device B and selects that child, the pending exam appears.

### Attempt Removes Pending Exam

Given a child submits an exam, when the backend accepts the attempt, the generated exam no longer appears in pending exam lists.

### Backend ID Integrity

All child and exam operations use backend IDs returned by the server, not locally generated UUIDs.

### No Durable Local Data

No durable learning data should be saved in local storage, SwiftData, UserDefaults, or `@AppStorage`.

### Grade Source Of Truth

The generate-exam endpoint should derive grade from the backend child profile unless a valid optional grade is explicitly supplied. The current app omits grade from the generate request.
