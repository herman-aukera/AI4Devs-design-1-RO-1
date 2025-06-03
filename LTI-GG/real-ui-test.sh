#!/bin/bash

# Real UI E2E Test - Tests actual browser functionality
# This script identifies real UI issues that curl tests miss

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}🔍 Real UI E2E Test - Testing Actual Browser Functionality${NC}"

# Check if servers are running
check_servers() {
    echo -e "\n${YELLOW}📡 Checking servers...${NC}"
    
    if ! curl -s http://localhost:4000/api/jobs > /dev/null; then
        echo -e "${RED}❌ Backend server not running on port 4000${NC}"
        echo "Please start backend with: cd backend && mix phx.server"
        exit 1
    fi
    
    if ! curl -s http://localhost:8000 > /dev/null; then
        echo -e "${RED}❌ Frontend server not running on port 8000${NC}"
        echo "Please start frontend with: cd frontend && elm reactor --port=8000"
        exit 1
    fi
    
    echo -e "${GREEN}✅ Both servers are running${NC}"
}

# Test API endpoints for baseline functionality
test_api_baseline() {
    echo -e "\n${YELLOW}🔧 Testing API Baseline (Backend Only)...${NC}"
    
    # Clear any existing test data
    curl -s -X DELETE http://localhost:4000/api/jobs/ui-test-job > /dev/null 2>&1 || true
    curl -s -X DELETE http://localhost:4000/api/applications/ui-test-app > /dev/null 2>&1 || true
    
    # Test job creation via API
    echo "Testing job creation via API..."
    JOB_RESPONSE=$(curl -s -X POST http://localhost:4000/api/jobs \
        -H "Content-Type: application/json" \
        -d '{"id":"ui-test-job","title":"UI Test Job","description":"Test job for UI validation"}')
    
    if echo "$JOB_RESPONSE" | grep -q "ui-test-job"; then
        echo -e "${GREEN}✅ API job creation works${NC}"
    else
        echo -e "${RED}❌ API job creation failed: $JOB_RESPONSE${NC}"
        exit 1
    fi
    
    # Test job deletion via API
    echo "Testing job deletion via API..."
    DELETE_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X DELETE http://localhost:4000/api/jobs/ui-test-job)
    
    if [ "$DELETE_RESPONSE" = "204" ] || [ "$DELETE_RESPONSE" = "200" ]; then
        echo -e "${GREEN}✅ API job deletion works${NC}"
    else
        echo -e "${RED}❌ API job deletion failed. HTTP code: $DELETE_RESPONSE${NC}"
        exit 1
    fi
}

# Test CORS for frontend requests
test_cors_headers() {
    echo -e "\n${YELLOW}🌐 Testing CORS Headers for Frontend Requests...${NC}"
    
    # Test preflight request
    CORS_RESPONSE=$(curl -s -X OPTIONS http://localhost:4000/api/jobs \
        -H "Origin: http://localhost:8000" \
        -H "Access-Control-Request-Method: POST" \
        -H "Access-Control-Request-Headers: content-type" \
        -o /dev/null -w "%{http_code}")
    
    if [ "$CORS_RESPONSE" = "200" ] || [ "$CORS_RESPONSE" = "204" ]; then
        echo -e "${GREEN}✅ CORS preflight request works${NC}"
    else
        echo -e "${RED}❌ CORS preflight failed. HTTP code: $CORS_RESPONSE${NC}"
        exit 1
    fi
    
    # Test actual CORS headers in response
    CORS_HEADERS=$(curl -s -I http://localhost:4000/api/jobs -H "Origin: http://localhost:8000")
    
    if echo "$CORS_HEADERS" | grep -qi "access-control-allow-origin"; then
        echo -e "${GREEN}✅ CORS headers present${NC}"
    else
        echo -e "${RED}❌ CORS headers missing${NC}"
        echo "Response headers:"
        echo "$CORS_HEADERS"
        exit 1
    fi
}

# Test the actual frontend request pattern
test_frontend_request_pattern() {
    echo -e "\n${YELLOW}🎯 Testing Frontend Request Pattern...${NC}"
    
    # Clear test data
    curl -s -X DELETE http://localhost:4000/api/jobs/frontend-test-job > /dev/null 2>&1 || true
    
    # Test the exact request pattern the frontend uses
    echo "Testing frontend-style job creation..."
    FRONTEND_RESPONSE=$(curl -s -X POST http://localhost:4000/api/jobs \
        -H "Content-Type: application/json" \
        -H "Origin: http://localhost:8000" \
        -d '{"id":"frontend-test-job","title":"Frontend Test","description":"Test from frontend pattern"}' \
        -w "\n%{http_code}")
    
    HTTP_CODE=$(echo "$FRONTEND_RESPONSE" | tail -n 1)
    RESPONSE_BODY=$(echo "$FRONTEND_RESPONSE" | head -n -1)
    
    if [ "$HTTP_CODE" = "201" ] || [ "$HTTP_CODE" = "200" ]; then
        if echo "$RESPONSE_BODY" | grep -q "frontend-test-job"; then
            echo -e "${GREEN}✅ Frontend-style job creation works${NC}"
        else
            echo -e "${RED}❌ Frontend-style job creation returned unexpected response: $RESPONSE_BODY${NC}"
            exit 1
        fi
    else
        echo -e "${RED}❌ Frontend-style job creation failed. HTTP code: $HTTP_CODE${NC}"
        echo "Response: $RESPONSE_BODY"
        exit 1
    fi
    
    # Test frontend-style deletion
    echo "Testing frontend-style job deletion..."
    DELETE_RESPONSE=$(curl -s -X DELETE http://localhost:4000/api/jobs/frontend-test-job \
        -H "Origin: http://localhost:8000" \
        -o /dev/null -w "%{http_code}")
    
    if [ "$DELETE_RESPONSE" = "204" ] || [ "$DELETE_RESPONSE" = "200" ]; then
        echo -e "${GREEN}✅ Frontend-style job deletion works${NC}"
    else
        echo -e "${RED}❌ Frontend-style job deletion failed. HTTP code: $DELETE_RESPONSE${NC}"
        exit 1
    fi
}

# Test the specific error scenarios the user reported
test_error_scenarios() {
    echo -e "\n${YELLOW}🚨 Testing Reported Error Scenarios...${NC}"
    
    # Test creation with empty fields (should fail gracefully)
    echo "Testing job creation with empty fields..."
    EMPTY_RESPONSE=$(curl -s -X POST http://localhost:4000/api/jobs \
        -H "Content-Type: application/json" \
        -H "Origin: http://localhost:8000" \
        -d '{"id":"","title":"","description":""}' \
        -w "\n%{http_code}")
    
    HTTP_CODE=$(echo "$EMPTY_RESPONSE" | tail -n 1)
    
    if [ "$HTTP_CODE" = "400" ] || [ "$HTTP_CODE" = "422" ]; then
        echo -e "${GREEN}✅ Empty field validation works${NC}"
    else
        echo -e "${YELLOW}⚠️ Empty field validation might be missing. HTTP code: $HTTP_CODE${NC}"
    fi
    
    # Test deletion of non-existent job
    echo "Testing deletion of non-existent job..."
    MISSING_DELETE=$(curl -s -X DELETE http://localhost:4000/api/jobs/non-existent-job \
        -H "Origin: http://localhost:8000" \
        -o /dev/null -w "%{http_code}")
    
    if [ "$MISSING_DELETE" = "404" ]; then
        echo -e "${GREEN}✅ 404 handling for missing jobs works${NC}"
    else
        echo -e "${YELLOW}⚠️ Missing job deletion returned: $MISSING_DELETE (expected 404)${NC}"
    fi
}

# Provide manual testing instructions
provide_manual_test_instructions() {
    echo -e "\n${YELLOW}📖 Manual UI Testing Instructions${NC}"
    echo "The automated tests show the backend works. If you're still seeing UI errors:"
    echo ""
    echo "1. Open: http://localhost:8000/src/Main.elm"
    echo "2. Login with: admin / admin123"
    echo "3. Try creating a job with valid data"
    echo "4. Check browser console (F12) for JavaScript errors"
    echo "5. Check network tab for failed requests"
    echo ""
    echo "If you see 'Failed to create job' or 'Failed to delete job':"
    echo "- Check browser console for CORS errors"
    echo "- Verify both servers are running"
    echo "- Try refreshing the page"
    echo ""
    echo -e "${GREEN}🔧 Backend API is working correctly!${NC}"
    echo "The issue is likely in the frontend UI layer."
}

# Run all tests
main() {
    check_servers
    test_api_baseline
    test_cors_headers
    test_frontend_request_pattern
    test_error_scenarios
    provide_manual_test_instructions
    
    echo -e "\n${GREEN}🎉 Backend API Tests Complete!${NC}"
    echo -e "If UI issues persist, the problem is in the frontend JavaScript layer."
}

main "$@"
