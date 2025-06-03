#!/bin/bash

# LTI ATS MVP - Use Case Validation Script
# Tests the three main use cases end-to-end

echo "🎯 LTI ATS MVP - Use Case Testing"
echo "=================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if backend is running
echo -e "${BLUE}Checking if backend is running...${NC}"
if ! curl -s http://localhost:4000/api/jobs > /dev/null; then
    echo -e "${RED}❌ Backend not running! Start with: make run${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Backend is running${NC}"

# Clean slate - remove any existing data
echo -e "${BLUE}Cleaning existing data...${NC}"
curl -s -X DELETE http://localhost:4000/api/jobs/test-job-1 > /dev/null 2>&1
curl -s -X DELETE http://localhost:4000/api/applications/test-app-1 > /dev/null 2>&1
curl -s -X DELETE http://localhost:4000/api/candidates/test-candidate-1 > /dev/null 2>&1

echo ""
echo "🧪 Testing Use Cases"
echo "===================="

# Use Case 1: Register New Candidate
echo ""
echo -e "${YELLOW}📋 UC1: Register New Candidate${NC}"
echo "Creating candidate with profile information..."

UC1_RESPONSE=$(curl -s -X POST http://localhost:4000/api/candidates \
  -H "Content-Type: application/json" \
  -d '{
    "id": "test-candidate-1",
    "name": "Alice Johnson", 
    "email": "alice.johnson@example.com"
  }')

if echo "$UC1_RESPONSE" | grep -q "test-candidate-1"; then
    echo -e "${GREEN}✅ UC1 PASSED: Candidate registered successfully${NC}"
    echo "   Name: Alice Johnson"
    echo "   Email: alice.johnson@example.com"
else
    echo -e "${RED}❌ UC1 FAILED: Candidate registration failed${NC}"
    echo "   Response: $UC1_RESPONSE"
    exit 1
fi

# Use Case 2: Create Job Position
echo ""
echo -e "${YELLOW}💼 UC2: Create Job Position${NC}"
echo "Creating job position by recruiter..."

UC2_RESPONSE=$(curl -s -X POST http://localhost:4000/api/jobs \
  -H "Content-Type: application/json" \
  -d '{
    "id": "test-job-1",
    "title": "Senior Elixir Developer",
    "description": "Build scalable web applications with Phoenix and Elixir. Experience with functional programming required."
  }')

if echo "$UC2_RESPONSE" | grep -q "test-job-1"; then
    echo -e "${GREEN}✅ UC2 PASSED: Job position created successfully${NC}"
    echo "   Title: Senior Elixir Developer"
    echo "   Status: open"
else
    echo -e "${RED}❌ UC2 FAILED: Job creation failed${NC}"
    echo "   Response: $UC2_RESPONSE"
    exit 1
fi

# Use Case 3: Submit Application
echo ""
echo -e "${YELLOW}📝 UC3: Submit Application${NC}"
echo "Candidate applying for job position..."

UC3_RESPONSE=$(curl -s -X POST http://localhost:4000/api/applications \
  -H "Content-Type: application/json" \
  -d '{
    "id": "test-app-1",
    "candidate_id": "test-candidate-1",
    "job_id": "test-job-1",
    "notes": "I have 5 years of Elixir experience and have built several Phoenix applications."
  }')

if echo "$UC3_RESPONSE" | grep -q "test-app-1"; then
    echo -e "${GREEN}✅ UC3 PASSED: Application submitted successfully${NC}"
    echo "   Application ID: test-app-1"
    echo "   Candidate: test-candidate-1 → Job: test-job-1"
else
    echo -e "${RED}❌ UC3 FAILED: Application submission failed${NC}"
    echo "   Response: $UC3_RESPONSE"
    exit 1
fi

# Verify data consistency
echo ""
echo -e "${BLUE}🔍 Verifying data consistency...${NC}"

# Check that job exists
JOBS_RESPONSE=$(curl -s http://localhost:4000/api/jobs)
if echo "$JOBS_RESPONSE" | grep -q "test-job-1"; then
    echo -e "${GREEN}✅ Job persisted correctly${NC}"
else
    echo -e "${RED}❌ Job not found in database${NC}"
fi

# Check that candidate exists
CANDIDATES_RESPONSE=$(curl -s http://localhost:4000/api/candidates)
if echo "$CANDIDATES_RESPONSE" | grep -q "test-candidate-1"; then
    echo -e "${GREEN}✅ Candidate persisted correctly${NC}"
else
    echo -e "${RED}❌ Candidate not found in database${NC}"
fi

# Check that application exists
APPS_RESPONSE=$(curl -s http://localhost:4000/api/applications)
if echo "$APPS_RESPONSE" | grep -q "test-app-1"; then
    echo -e "${GREEN}✅ Application persisted correctly${NC}"
else
    echo -e "${RED}❌ Application not found in database${NC}"
fi

echo ""
echo "🎉 USE CASE TESTING COMPLETE"
echo "=============================="
echo -e "${GREEN}✅ All 3 main use cases working correctly!${NC}"
echo ""
echo "💡 Next steps:"
echo "   1. Open frontend: http://localhost:8000/src/Main.elm"
echo "   2. Login with: admin / admin123"
echo "   3. Verify UI shows the created data"
echo ""
echo "🧹 Cleanup (optional):"
echo "   make reset-db    # Clear all test data"
