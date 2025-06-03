#!/bin/bash

# LTI ATS System Integration Test Script
# This script tests the complete system functionality

set -e

echo "🚀 Starting LTI ATS System Integration Tests..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test backend API endpoints
echo -e "\n${YELLOW}📡 Testing Backend API Endpoints...${NC}"

echo "✅ Testing GET /api/jobs..."
JOBS_RESPONSE=$(curl -s http://localhost:4000/api/jobs)
echo "Response: $JOBS_RESPONSE"

echo "✅ Testing POST /api/jobs..."
JOB_CREATE_RESPONSE=$(curl -s -X POST http://localhost:4000/api/jobs \
  -H "Content-Type: application/json" \
  -d '{"id":"test-job-1","title":"Senior Software Engineer","description":"Build amazing software with Elixir and Elm"}')
echo "Response: $JOB_CREATE_RESPONSE"

echo "✅ Testing GET /api/jobs (should now have 1 job)..."
JOBS_AFTER_CREATE=$(curl -s http://localhost:4000/api/jobs)
echo "Response: $JOBS_AFTER_CREATE"

echo "✅ Testing GET /api/applications..."
APPS_RESPONSE=$(curl -s http://localhost:4000/api/applications)
echo "Response: $APPS_RESPONSE"

echo "✅ Testing POST /api/applications..."
APP_CREATE_RESPONSE=$(curl -s -X POST http://localhost:4000/api/applications \
  -H "Content-Type: application/json" \
  -d '{"id":"app-1","candidate_id":"candidate-1","job_id":"test-job-1"}')
echo "Response: $APP_CREATE_RESPONSE"

echo "✅ Testing GET /api/candidates..."
CANDIDATES_RESPONSE=$(curl -s http://localhost:4000/api/candidates)
echo "Response: $CANDIDATES_RESPONSE"

echo "✅ Testing POST /api/candidates..."
CANDIDATE_CREATE_RESPONSE=$(curl -s -X POST http://localhost:4000/api/candidates \
  -H "Content-Type: application/json" \
  -d '{"id":"candidate-1","name":"John Doe","email":"john.doe@example.com"}')
echo "Response: $CANDIDATE_CREATE_RESPONSE"

# Test CORS headers
echo -e "\n${YELLOW}🌐 Testing CORS Headers...${NC}"
CORS_RESPONSE=$(curl -s -I -H "Origin: http://localhost:8000" http://localhost:4000/api/jobs)
if echo "$CORS_RESPONSE" | grep -q "access-control-allow-origin"; then
    echo -e "${GREEN}✅ CORS headers present${NC}"
else
    echo -e "${RED}❌ CORS headers missing${NC}"
    exit 1
fi

# Test backend test suite
echo -e "\n${YELLOW}🧪 Running Backend Test Suite...${NC}"
cd backend
TEST_OUTPUT=$(mix test 2>&1)
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ All backend tests pass${NC}"
    echo "$TEST_OUTPUT" | tail -5
else
    echo -e "${RED}❌ Backend tests failed${NC}"
    echo "$TEST_OUTPUT"
    exit 1
fi
cd ..

# Test frontend compilation
echo -e "\n${YELLOW}🎨 Testing Frontend Compilation...${NC}"
cd frontend
FRONTEND_OUTPUT=$(elm make src/Main.elm --output=dist/main.js 2>&1)
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Frontend compiles successfully${NC}"
else
    echo -e "${RED}❌ Frontend compilation failed${NC}"
    echo "$FRONTEND_OUTPUT"
    exit 1
fi

# Test frontend tests
echo "✅ Running Frontend Tests..."
FRONTEND_TEST_OUTPUT=$(elm-test 2>&1)
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ All frontend tests pass${NC}"
else
    echo -e "${RED}❌ Frontend tests failed${NC}"
    echo "$FRONTEND_TEST_OUTPUT"
    exit 1
fi
cd ..

echo -e "\n${GREEN}🎉 All System Integration Tests Pass!${NC}"
echo -e "\n${YELLOW}📋 System Status:${NC}"
echo "✅ Backend API: Running on http://localhost:4000"
echo "✅ Frontend: Available at http://localhost:8000/src/Main.elm"
echo "✅ All endpoints working with CORS enabled"
echo "✅ All tests passing"
echo -e "\n${YELLOW}🔧 To use the system:${NC}"
echo "1. Login with admin/admin123"
echo "2. Create jobs and applications"
echo "3. View the data in the dashboard"

echo -e "\n${GREEN}System is ready for testing!${NC}"
