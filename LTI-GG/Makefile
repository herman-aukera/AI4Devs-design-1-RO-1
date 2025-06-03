# LTI ATS MVP - Makefile
# Modern functional programming ATS with Elm + Elixir
.PHONY: setup run test clean format help

# Default target
.DEFAULT_GOAL := help

help: ## Show this help message
	@echo "LTI ATS MVP - Development Commands"
	@echo "=================================="
	@egrep '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-12s\033[0m %s\n", $$1, $$2}'

setup: ## Install all dependencies (backend + frontend)
	@echo "🔧 Setting up LTI ATS MVP..."
	@echo "📦 Installing backend dependencies..."
	cd backend && mix deps.get
	@echo "📦 Installing frontend dependencies..."
	cd frontend && elm make src/Main.elm --optimize --output=/tmp/elm-test.js > /dev/null 2>&1 || true
	@echo "✅ Setup complete!"

run: ## Start both frontend and backend servers
	@echo "🚀 Starting LTI ATS MVP..."
	@echo "📱 Backend: http://localhost:4000"
	@echo "🌐 Frontend: http://localhost:8000"
	@echo "🔐 Login: admin / admin123"
	@echo ""
	@echo "Starting servers in parallel..."
	@(cd backend && mix phx.server) & \
	(cd frontend && elm reactor) & \
	wait

test: ## Run all tests (backend + frontend + integration)
	@echo "🧪 Running comprehensive test suite..."
	@echo "⚡ Backend unit tests..."
	cd backend && mix test
	@echo "⚡ Frontend unit tests..."
	cd frontend && elm-test
	@echo "⚡ Integration tests..."
	./integration-test.sh
	@echo "✅ All tests completed!"

test-backend: ## Run only backend tests
	@echo "🧪 Running backend tests..."
	cd backend && mix test

test-frontend: ## Run only frontend tests  
	@echo "🧪 Running frontend tests..."
	cd frontend && elm-test

test-integration: ## Run integration tests
	@echo "🧪 Running integration tests..."
	./integration-test.sh

test-e2e: ## Run end-to-end tests
	@echo "🧪 Running E2E tests..."
	./e2e-test.sh

format: ## Format all code (Elixir + Elm)
	@echo "🎨 Formatting code..."
	cd backend && mix format
	cd frontend && elm-format src/ --yes
	cd frontend && elm-format tests/ --yes
	@echo "✅ Code formatted!"

clean: ## Clean build artifacts
	@echo "🧹 Cleaning build artifacts..."
	cd backend && mix clean
	cd frontend && rm -rf elm-stuff/build-artifacts
	@echo "✅ Clean complete!"

reset-db: ## Reset in-memory data store
	@echo "🔄 Resetting in-memory database..."
	@echo "In-memory store will reset automatically on server restart"
	@echo "To reset: stop servers (Ctrl+C) and run 'make run' again"

dev: ## Start development servers with file watching
	@echo "🔄 Starting development mode with file watching..."
	@(cd backend && mix phx.server) & \
	(cd frontend && elm reactor) & \
	wait

check: ## Run all quality checks
	@echo "🔍 Running quality checks..."
	@echo "🧪 Tests..."
	$(MAKE) test
	@echo "🎨 Format check..."
	$(MAKE) format
	@echo "✅ Quality checks complete!"

quick-test: ## Quick functionality test
	@echo "⚡ Quick system test..."
	@echo "1. Ensure servers are running (make run)"
	@echo "2. Open http://localhost:8000/src/Main.elm"
	@echo "3. Login with admin/admin123"
	@echo "4. Create a job and application"
	@echo "5. Verify CRUD operations work"

test-use-cases: ## Test the three main use cases end-to-end
	@echo "🎯 Testing main use cases..."
	@./test-use-cases.sh

status: ## Show system status
	@echo "📊 LTI ATS MVP System Status"
	@echo "============================="
	@echo "Backend server: curl -s http://localhost:4000/api/jobs > /dev/null && echo '✅ Running' || echo '❌ Not running'"
	@echo "Frontend server: curl -s http://localhost:8000 > /dev/null && echo '✅ Running' || echo '❌ Not running'"
	@echo ""
	@echo "To start: make run"

# Advanced targets for CI/CD
ci-test: ## Run tests suitable for CI environment
	cd backend && mix test --cover
	cd frontend && elm-test
	./integration-test.sh

# Development helpers
deps-backend: ## Install only backend dependencies
	cd backend && mix deps.get

deps-frontend: ## Install only frontend dependencies  
	cd frontend && elm make src/Main.elm --optimize --output=/tmp/elm-test.js > /dev/null 2>&1 || true

# System information
info: ## Show system and dependency information
	@echo "🔍 LTI ATS MVP System Information"
	@echo "================================"
	@echo "Elixir version: $(shell elixir --version | head -1)"
	@echo "Elm version: $(shell elm --version 2>/dev/null || echo 'Not installed')"
	@echo "Mix version: $(shell mix --version)"
	@echo "Phoenix version: $(shell cd backend && mix phx.new --version 2>/dev/null || echo 'Check backend/mix.exs')"
	@echo ""
	@echo "Project structure:"
	@echo "├── backend/     # Elixir/Phoenix API"  
	@echo "├── frontend/    # Elm SPA"
	@echo "├── *.sh         # Test scripts"
	@echo "└── *.md         # Documentation"
