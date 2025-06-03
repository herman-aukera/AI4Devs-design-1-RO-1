# 🧪 Testing Guide - LTI ATS MVP

Comprehensive testing documentation for the LTI Applicant Tracking System.

## 📋 Testing Overview

This system includes multiple testing layers:

- **Unit Tests**: Backend (38 tests) and Frontend (14 tests)
- **Integration Tests**: API endpoints, CORS, and data flow
- **End-to-End Tests**: Frontend-backend integration
- **Manual Testing**: User interface and workflow validation

## ⚡ Quick Test Run

```bash
# Run all tests (Makefile approach - Recommended)
make test

# Run individual test suites
make test-backend    # Backend tests only (38 tests)
make test-frontend   # Frontend tests only (14 tests)

# Run integration tests
make test-integration

# Test main use cases end-to-end
make test-use-cases

# Traditional approach
cd backend && mix test
cd frontend && elm-test
```

## 🔄 Integration Testing

### Automated Integration Tests

```bash
# Run comprehensive API integration tests
./integration-test.sh

# Run end-to-end frontend-backend tests
./e2e-test.sh
```

### What Integration Tests Cover

1. **API Endpoints**: All CRUD operations for jobs, applications, candidates
2. **CORS Headers**: Cross-origin request validation
3. **Error Scenarios**: Invalid data, 404s, malformed requests
4. **Performance**: Response time validation (~39ms for job creation)
5. **Data Consistency**: Verify data persistence and retrieval

## 🎯 Manual Testing Scenarios

### Login Flow Testing

```
✅ Valid credentials (admin/admin123) → Success
❌ Invalid credentials → Error message displayed
❌ Empty fields → Validation message
```

### Job Management Testing

```
✅ Create job with valid data → Job appears in list
✅ Create job with duplicate ID → Error handling
❌ Create job with empty required fields → Validation
✅ Delete job → Job removed from list
✅ Refresh jobs → Data reloaded from backend
```

### Application Management Testing

```
✅ Create application with valid job reference → Success
❌ Create application with invalid job ID → Error
✅ Delete application → Application removed
✅ Refresh applications → Data reloaded
```

## 🐛 Known Testing Issues

### Fixed Issues

- ✅ Login form now has proper username/password fields
- ✅ Authentication validation working correctly
- ✅ All frontend tests updated for new login flow
- ✅ Backend CRUD operations fully functional

### Current Limitations

- ⚠️ Backend returns HTML error pages for malformed JSON (not JSON errors)
- ⚠️ No real-time validation feedback in frontend forms
- ⚠️ Limited error message specificity for end users

## 📊 Test Results Summary

### Backend Tests (38 tests)

```
✅ Application Repository Tests: 6/6 passing
✅ Application Controller Tests: 6/6 passing
✅ Job Repository Tests: 6/6 passing
✅ Job Controller Tests: 6/6 passing
✅ Candidate Repository Tests: 6/6 passing
✅ Candidate Controller Tests: 6/6 passing
✅ Router Tests: 2/2 passing
```

### Frontend Tests (14 tests)

```
✅ Main Tests: 4/4 passing
✅ Job Fetch Tests: 5/5 passing
✅ Application Fetch Tests: 5/5 passing
```

### Integration Test Results

```
✅ Jobs API: CREATE, READ, DELETE working
✅ Applications API: CREATE, READ, DELETE working
✅ Candidates API: CREATE, READ, DELETE working
✅ CORS Headers: Properly configured
✅ Error Handling: 404s and validation working
✅ Performance: Response times < 50ms
```

## 🔧 Test Infrastructure

### Backend Testing Stack

- **Framework**: ExUnit (Elixir's built-in testing)
- **HTTP Testing**: Phoenix ConnTest
- **Mocking**: Mox for repository testing
- **Coverage**: Mix test coverage reporting

### Frontend Testing Stack

- **Framework**: elm-test
- **HTTP Testing**: elm-explorations/test
- **Test Structure**: Unit tests for all major functions
- **Mock Data**: Predefined test models and responses

### Integration Testing Stack

- **API Testing**: curl-based HTTP requests
- **Response Validation**: JSON parsing and field verification
- **Performance Testing**: Response time measurement
- **Error Scenarios**: Comprehensive negative testing

## 🎨 Writing New Tests

### Adding Backend Tests

```elixir
# Example test in test/lti_ats/controllers/job_controller_test.exs
test "creates job with valid attributes", %{conn: conn} do
  job_params = %{id: "job123", title: "Engineer", description: "Build things"}

  conn = post(conn, Routes.job_path(conn, :create), job_params)

  assert json_response(conn, 201)["id"] == "job123"
end
```

### Adding Frontend Tests

```elm
-- Example test in tests/MainTest.elm
testCreateJob : Test
testCreateJob =
    test "creating a job updates the model" <|
        \_ ->
            let
                initialModel = initModel
                newJob = { id = "j1", title = "Engineer", description = "Code" }
                updatedModel = update (JobCreated (Ok newJob)) initialModel
            in
            Expect.equal (List.length updatedModel.jobs) 1
```

### Adding Integration Tests

```bash
# Add to integration-test.sh
echo "Testing new endpoint..."
response=$(curl -s -X POST http://localhost:4000/api/new-endpoint \
  -H "Content-Type: application/json" \
  -d '{"test":"data"}')

if echo "$response" | grep -q "expected_field"; then
    echo "✅ New endpoint test passed"
else
    echo "❌ New endpoint test failed"
    exit 1
fi
```

## 📈 Test Coverage Goals

- **Backend**: >90% line coverage for controllers and repositories
- **Frontend**: 100% function coverage for main business logic
- **Integration**: 100% API endpoint coverage
- **Manual**: All user workflows tested before release

## 🚀 Continuous Testing

For development workflow:

```bash
# Watch mode for backend tests
cd backend && mix test --listen-on-stdin

# Watch mode for frontend tests
cd frontend && elm-test --watch

# Regular integration testing
./integration-test.sh && ./e2e-test.sh
```

## 📚 Related Documentation

- **Quick Start**: See [RUN.md](./RUN.md)
- **System Architecture**: See [LTI-GG.md](./LTI-GG.md)
- **Requirements Verification**: See [COMPLIANCE.md](./COMPLIANCE.md)
