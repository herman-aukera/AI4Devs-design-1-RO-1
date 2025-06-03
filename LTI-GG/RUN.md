# 🚀 Quick Start Guide - LTI ATS MVP

Get the LTI Applicant Tracking System running in under 2 minutes!

## ⚡ Prerequisites

```bash
# Install Elixir & Erlang
brew install elixir  # macOS
# OR
sudo apt-get install elixir  # Ubuntu/Debian

# Install Elm
npm install -g elm elm-test elm-format  # Requires Node.js
```

## 🏃 Running the Application

### Option 1: Using Makefile (Recommended)

```bash
# 1. Navigate to project
cd LTI-GG

# 2. Setup dependencies
make setup

# 3. Start the application
make run
```

### Option 2: Manual Start

```bash
# Terminal 1: Backend
cd backend
mix deps.get
mix phx.server

# Terminal 2: Frontend
cd frontend
elm reactor
```

## 🌐 Access Points

- **Frontend**: http://localhost:8000/src/Main.elm
- **Backend API**: http://localhost:4000/api

## 🔐 Login Credentials

- **Username**: `admin`
- **Password**: `admin123`

## 🧪 Quick Functional Test

1. **Login**: Enter credentials and click "Login"
2. **Create Job**: Fill Job ID (`j1`), Title (`Software Engineer`), Description, click "Create Job"
3. **Create Application**: Fill Application ID (`a1`), Candidate ID (`candidate1`), Job ID (`j1`), click "Create Application"
4. **Verify**: Both items should appear in their respective lists
5. **Delete**: Click "Delete" buttons to test deletion functionality

## 🔧 Available Commands

```bash
make help      # Show all available commands
make setup     # Install dependencies
make run       # Start both frontend and backend
make test      # Run all tests (unit + integration)
make format    # Format all code
make clean     # Clean build artifacts
make status    # Check if servers are running
```

## 🎯 Use Cases to Test

### Quick automated testing:

```bash
# Test all three use cases automatically
make test-use-cases
```

### Manual testing in the UI:

### UC1: Register New Candidate

1. Open browser → http://localhost:8000/src/Main.elm
2. Login with admin/admin123
3. System displays dashboard with forms
4. ✅ **Success**: Login form works, dashboard loads

### UC2: Create Job Position

1. Fill "Create Job" form:
   - ID: `job-001`
   - Title: `Senior Developer`
   - Description: `Full-stack development role`
2. Click "Create Job"
3. ✅ **Success**: Job appears in jobs list

### UC3: Submit Application

1. Fill "Create Application" form:
   - ID: `app-001`
   - Candidate ID: `candidate-001`
   - Job ID: `job-001`
2. Click "Create Application"
3. ✅ **Success**: Application appears in applications list

## 📚 Additional Documentation

- **System Architecture**: See [LTI-GG.md](./LTI-GG.md)
- **Testing Guide**: See [TESTING.md](./TESTING.md)
- **Requirements Compliance**: See [COMPLIANCE.md](./COMPLIANCE.md)
- **Completion Report**: See [COMPLETION_REPORT.md](./COMPLETION_REPORT.md)

## 🆘 Troubleshooting

### Common Issues

```bash
# If ports are in use
lsof -ti:4000 | xargs kill  # Kill backend
lsof -ti:8000 | xargs kill  # Kill frontend

# If dependencies fail
make clean && make setup

# Test system status
make status
```

### Validation Commands

```bash
# Quick system test
make test

# Integration tests only
make test-integration

# Check if everything is working
make check
```

---

**Need more help?** Check [TESTING.md](./TESTING.md) for comprehensive testing or [LTI-GG.md](./LTI-GG.md) for system architecture.
