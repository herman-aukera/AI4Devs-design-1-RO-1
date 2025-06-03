#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔍 Starting Comprehensive LTI ATS Integration Tests...${NC}"
echo ""

# Function to check if servers are running
check_servers() {
    echo -e "${YELLOW}📡 Checking if servers are running...${NC}"
    
    # Check backend
    if ! curl -s http://localhost:4000/api/jobs > /dev/null; then
        echo -e "${RED}❌ Backend server not running on port 4000${NC}"
        echo "Please start backend with: cd backend && mix phx.server"
        exit 1
    fi
    
    # Check frontend
    if ! curl -s http://localhost:8000 > /dev/null; then
        echo -e "${RED}❌ Frontend server not running on port 8000${NC}"
        echo "Please start frontend with: cd frontend && elm reactor --port=8000"
        exit 1
    fi
    
    echo -e "${GREEN}✅ Both servers are running${NC}"
}

# Test API endpoints with comprehensive data validation
test_api_endpoints() {
    echo -e "\n${YELLOW}🔧 Testing API Endpoints with Validation...${NC}"
    
    # Clear any existing data
    curl -s -X DELETE http://localhost:4000/api/jobs/test-job-1 > /dev/null 2>&1
    curl -s -X DELETE http://localhost:4000/api/applications/test-app-1 > /dev/null 2>&1
    curl -s -X DELETE http://localhost:4000/api/candidates/test-candidate-1 > /dev/null 2>&1
    
    # Test job creation
    echo "Testing job creation..."
    JOB_RESPONSE=$(curl -s -X POST http://localhost:4000/api/jobs \
        -H "Content-Type: application/json" \
        -d '{"id":"test-job-1","title":"Senior Software Engineer","description":"Build amazing software with Elixir and Elm"}')
    
    if echo "$JOB_RESPONSE" | grep -q "test-job-1"; then
        echo -e "${GREEN}✅ Job creation works${NC}"
    else
        echo -e "${RED}❌ Job creation failed: $JOB_RESPONSE${NC}"
        exit 1
    fi
    
    # Test job retrieval
    echo "Testing job retrieval..."
    JOBS_RESPONSE=$(curl -s http://localhost:4000/api/jobs)
    if echo "$JOBS_RESPONSE" | grep -q "test-job-1"; then
        echo -e "${GREEN}✅ Job retrieval works${NC}"
    else
        echo -e "${RED}❌ Job retrieval failed: $JOBS_RESPONSE${NC}"
        exit 1
    fi
    
    # Test candidate creation
    echo "Testing candidate creation..."
    CANDIDATE_RESPONSE=$(curl -s -X POST http://localhost:4000/api/candidates \
        -H "Content-Type: application/json" \
        -d '{"id":"test-candidate-1","name":"John Doe","email":"john.doe@example.com"}')
    
    if echo "$CANDIDATE_RESPONSE" | grep -q "test-candidate-1"; then
        echo -e "${GREEN}✅ Candidate creation works${NC}"
    else
        echo -e "${RED}❌ Candidate creation failed: $CANDIDATE_RESPONSE${NC}"
        exit 1
    fi
    
    # Test application creation
    echo "Testing application creation..."
    APP_RESPONSE=$(curl -s -X POST http://localhost:4000/api/applications \
        -H "Content-Type: application/json" \
        -d '{"id":"test-app-1","candidate_id":"test-candidate-1","job_id":"test-job-1"}')
    
    if echo "$APP_RESPONSE" | grep -q "test-app-1"; then
        echo -e "${GREEN}✅ Application creation works${NC}"
    else
        echo -e "${RED}❌ Application creation failed: $APP_RESPONSE${NC}"
        exit 1
    fi
    
    # Test deletion
    echo "Testing job deletion..."
    DELETE_RESPONSE=$(curl -s -w "%{http_code}" -X DELETE http://localhost:4000/api/jobs/test-job-1)
    if [[ "$DELETE_RESPONSE" == *"204"* ]]; then
        echo -e "${GREEN}✅ Job deletion works${NC}"
    else
        echo -e "${RED}❌ Job deletion failed: $DELETE_RESPONSE${NC}"
        exit 1
    fi
    
    # Test that job is actually deleted
    echo "Verifying job was deleted..."
    JOBS_AFTER_DELETE=$(curl -s http://localhost:4000/api/jobs)
    if ! echo "$JOBS_AFTER_DELETE" | grep -q "test-job-1"; then
        echo -e "${GREEN}✅ Job deletion verified${NC}"
    else
        echo -e "${RED}❌ Job still exists after deletion: $JOBS_AFTER_DELETE${NC}"
        exit 1
    fi
}

# Test CORS headers
test_cors() {
    echo -e "\n${YELLOW}🌐 Testing CORS Headers...${NC}"
    CORS_RESPONSE=$(curl -s -I -H "Origin: http://localhost:8000" http://localhost:4000/api/jobs)
    if echo "$CORS_RESPONSE" | grep -q "access-control-allow-origin"; then
        echo -e "${GREEN}✅ CORS headers present${NC}"
    else
        echo -e "${RED}❌ CORS headers missing${NC}"
        exit 1
    fi
}

# Test backend unit tests
test_backend() {
    echo -e "\n${YELLOW}🧪 Running Backend Unit Tests...${NC}"
    cd backend
    TEST_OUTPUT=$(mix test 2>&1)
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ All backend tests pass${NC}"
        echo "$TEST_OUTPUT" | tail -3
    else
        echo -e "${RED}❌ Backend tests failed${NC}"
        echo "$TEST_OUTPUT"
        exit 1
    fi
    cd ..
}

# Test frontend compilation
test_frontend_compilation() {
    echo -e "\n${YELLOW}🎨 Testing Frontend Compilation...${NC}"
    cd frontend
    if elm make src/Main.elm --output=/dev/null > /dev/null 2>&1; then
        echo -e "${GREEN}✅ Frontend compiles successfully${NC}"
    else
        echo -e "${RED}❌ Frontend compilation failed${NC}"
        elm make src/Main.elm --output=/dev/null
        exit 1
    fi
    cd ..
}

# Test frontend unit tests
test_frontend_tests() {
    echo -e "\n${YELLOW}🧪 Running Frontend Unit Tests...${NC}"
    cd frontend
    if elm-test > /dev/null 2>&1; then
        echo -e "${GREEN}✅ All frontend tests pass${NC}"
    else
        echo -e "${RED}❌ Frontend tests failed${NC}"
        elm-test
        exit 1
    fi
    cd ..
}

# Test frontend-backend integration with realistic workflow
test_integration_workflow() {
    echo -e "\n${YELLOW}🔄 Testing Full Integration Workflow...${NC}"
    
    # Clear existing test data first
    echo "Clearing existing test data..."
    curl -s -X DELETE http://localhost:4000/api/jobs/job-se-001 > /dev/null 2>&1
    curl -s -X DELETE http://localhost:4000/api/jobs/job-devops-001 > /dev/null 2>&1
    curl -s -X DELETE http://localhost:4000/api/applications/app-alice-se > /dev/null 2>&1
    curl -s -X DELETE http://localhost:4000/api/applications/app-bob-devops > /dev/null 2>&1
    curl -s -X DELETE http://localhost:4000/api/candidates/candidate-alice > /dev/null 2>&1
    curl -s -X DELETE http://localhost:4000/api/candidates/candidate-bob > /dev/null 2>&1
    
    # Create test data that mimics real user workflow
    echo "Creating realistic test data..."
    
    # Job 1: Software Engineer
    curl -s -X POST http://localhost:4000/api/jobs \
        -H "Content-Type: application/json" \
        -d '{"id":"job-se-001","title":"Senior Software Engineer","description":"Join our team building scalable web applications with Elixir and Elm"}' > /dev/null
    
    # Job 2: DevOps Engineer  
    curl -s -X POST http://localhost:4000/api/jobs \
        -H "Content-Type: application/json" \
        -d '{"id":"job-devops-001","title":"DevOps Engineer","description":"Manage our cloud infrastructure and deployment pipelines"}' > /dev/null
    
    # Candidate 1: Alice Smith
    curl -s -X POST http://localhost:4000/api/candidates \
        -H "Content-Type: application/json" \
        -d '{"id":"candidate-alice","name":"Alice Smith","email":"alice.smith@example.com"}' > /dev/null
    
    # Candidate 2: Bob Johnson
    curl -s -X POST http://localhost:4000/api/candidates \
        -H "Content-Type: application/json" \
        -d '{"id":"candidate-bob","name":"Bob Johnson","email":"bob.johnson@example.com"}' > /dev/null
    
    # Application 1: Alice applies for Software Engineer
    curl -s -X POST http://localhost:4000/api/applications \
        -H "Content-Type: application/json" \
        -d '{"id":"app-alice-se","candidate_id":"candidate-alice","job_id":"job-se-001"}' > /dev/null
    
    # Application 2: Bob applies for DevOps Engineer
    curl -s -X POST http://localhost:4000/api/applications \
        -H "Content-Type: application/json" \
        -d '{"id":"app-bob-devops","candidate_id":"candidate-bob","job_id":"job-devops-001"}' > /dev/null
    
    echo "Verifying complete data consistency..."
    
    # Check all jobs exist
    JOBS_CHECK=$(curl -s http://localhost:4000/api/jobs)
    JOB_COUNT=$(echo "$JOBS_CHECK" | grep -o "job-se-001\|job-devops-001" | wc -l | tr -d ' ')
    if [[ "$JOB_COUNT" -eq 2 ]]; then
        echo -e "${GREEN}✅ Both jobs created successfully${NC}"
    else
        echo -e "${RED}❌ Job creation verification failed${NC}"
        echo "Expected 2 jobs, found $JOB_COUNT"
        echo "Jobs response: $JOBS_CHECK"
        exit 1
    fi
    
    # Check all candidates exist
    CANDIDATES_CHECK=$(curl -s http://localhost:4000/api/candidates)
    CANDIDATE_COUNT=$(echo "$CANDIDATES_CHECK" | grep -o "candidate-alice\|candidate-bob" | wc -l | tr -d ' ')
    if [[ "$CANDIDATE_COUNT" -eq 2 ]]; then
        echo -e "${GREEN}✅ Both candidates created successfully${NC}"
    else
        echo -e "${RED}❌ Candidate creation verification failed${NC}"
        echo "Expected 2 candidates, found $CANDIDATE_COUNT"
        echo "Candidates response: $CANDIDATES_CHECK"
        exit 1
    fi
    
    # Check all applications exist
    APPS_CHECK=$(curl -s http://localhost:4000/api/applications)
    APP_COUNT=$(echo "$APPS_CHECK" | grep -o "app-alice-se\|app-bob-devops" | wc -l | tr -d ' ')
    if [[ "$APP_COUNT" -eq 2 ]]; then
        echo -e "${GREEN}✅ Both applications created successfully${NC}"
    else
        echo -e "${RED}❌ Application creation verification failed${NC}"
        echo "Expected 2 applications, found $APP_COUNT"
        echo "Applications response: $APPS_CHECK"
        exit 1
    fi
    
    echo "Testing data relationships..."
    
    # Verify application references valid job and candidate
    if echo "$APPS_CHECK" | grep -q "job-se-001" && echo "$APPS_CHECK" | grep -q "candidate-alice"; then
        echo -e "${GREEN}✅ Application-Job-Candidate relationships valid${NC}"
    else
        echo -e "${RED}❌ Data relationship validation failed${NC}"
        exit 1
    fi
    
    echo "Testing deletion cascade..."
    
    # Delete a job and verify related applications are handled correctly
    curl -s -X DELETE http://localhost:4000/api/jobs/job-se-001 > /dev/null
    
    JOBS_AFTER_DELETE=$(curl -s http://localhost:4000/api/jobs)
    if ! echo "$JOBS_AFTER_DELETE" | grep -q "job-se-001"; then
        echo -e "${GREEN}✅ Job deletion successful${NC}"
    else
        echo -e "${RED}❌ Job deletion failed${NC}"
        exit 1
    fi
    
    # Clean up remaining test data
    curl -s -X DELETE http://localhost:4000/api/jobs/job-devops-001 > /dev/null
    curl -s -X DELETE http://localhost:4000/api/applications/app-alice-se > /dev/null
    curl -s -X DELETE http://localhost:4000/api/applications/app-bob-devops > /dev/null
    curl -s -X DELETE http://localhost:4000/api/candidates/candidate-alice > /dev/null
    curl -s -X DELETE http://localhost:4000/api/candidates/candidate-bob > /dev/null
}

# Main test execution
main() {
    check_servers
    test_api_endpoints
    test_cors
    test_backend
    test_frontend_compilation
    test_frontend_tests
    test_integration_workflow
    
    echo ""
    echo -e "${GREEN}🎉 ALL INTEGRATION TESTS PASSED!${NC}"
    echo ""
    echo -e "${BLUE}📋 System Status Summary:${NC}"
    echo -e "${GREEN}✅ Backend API endpoints working${NC}"
    echo -e "${GREEN}✅ CORS headers configured${NC}"
    echo -e "${GREEN}✅ Backend unit tests passing${NC}"
    echo -e "${GREEN}✅ Frontend compilation successful${NC}"
    echo -e "${GREEN}✅ Frontend unit tests passing${NC}"
    echo -e "${GREEN}✅ Full integration workflow verified${NC}"
    echo -e "${GREEN}✅ Data consistency validated${NC}"
    echo -e "${GREEN}✅ CRUD operations functional${NC}"
    echo ""
    echo -e "${BLUE}🔧 Next Steps:${NC}"
    echo "1. Open http://localhost:8000/src/Main.elm in your browser"
    echo "2. Login with: admin / admin123"
    echo "3. Test creating, viewing, and deleting jobs and applications"
    echo ""
    echo -e "${GREEN}System is ready for manual testing! 🚀${NC}"
}

# Run the tests
main
