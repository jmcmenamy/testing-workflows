# Triggering the workflow_dispatch

There are several ways to trigger the `workflow_dispatch` event for testing:

## Method 1: GitHub Web Interface (Easiest)

1. **Navigate to Actions Tab**
   - Go to your repository on GitHub
   - Click on the "Actions" tab
   - Select "Required Check Workflow" from the left sidebar

2. **Trigger the Workflow**
   - Click "Run workflow" button (top right)
   - Choose the branch (usually `main`)
   - Optionally fill in the inputs:
     - **branch_name**: Custom name for the new branch (leave empty for auto-generated)
     - **pr_title**: Custom title for the PR (leave empty for default)
   - Click "Run workflow"

3. **Monitor the Run**
   - The workflow will appear in the runs list
   - Click on the run to see detailed logs
   - Watch for the PR creation step

## Method 2: GitHub CLI

### Prerequisites
```bash
# Install GitHub CLI if not already installed
# macOS: brew install gh
# Windows: winget install GitHub.cli
# Linux: See https://github.com/cli/cli#installation

# Authenticate with GitHub
gh auth login
```

### Basic Trigger
```bash
# Trigger with default values
gh workflow run "Required Check Workflow"

# Or using the filename
gh workflow run .github/workflows/required-check.yml
```

### Trigger with Custom Inputs
```bash
# With custom branch name and PR title
gh workflow run "Required Check Workflow" \
  -f branch_name="my-test-branch" \
  -f pr_title="My Custom PR Title"

# With just custom branch name
gh workflow run "Required Check Workflow" \
  -f branch_name="feature-test-$(date +%Y%m%d)"
```

### Monitor the Run
```bash
# List recent runs
gh run list --workflow="Required Check Workflow"

# Watch a specific run (replace RUN_ID)
gh run watch <RUN_ID>

# View run details
gh run view <RUN_ID>
```

## Method 3: REST API

### Using curl
```bash
# Set your variables
OWNER="your-username"
REPO="your-repo-name"
TOKEN="your-github-token"

# Basic trigger
curl -X POST \
  -H "Accept: application/vnd.github.v3+json" \
  -H "Authorization: token $TOKEN" \
  https://api.github.com/repos/$OWNER/$REPO/actions/workflows/required-check.yml/dispatches \
  -d '{"ref":"main"}'

# With custom inputs
curl -X POST \
  -H "Accept: application/vnd.github.v3+json" \
  -H "Authorization: token $TOKEN" \
  https://api.github.com/repos/$OWNER/$REPO/actions/workflows/required-check.yml/dispatches \
  -d '{
    "ref":"main",
    "inputs":{
      "branch_name":"api-test-branch",
      "pr_title":"PR created via API"
    }
  }'
```

## Method 4: Automated Testing Script

Create a bash script for repeated testing:

```bash
#!/bin/bash
# File: scripts/test-workflow.sh

set -e

echo "🚀 Triggering workflow_dispatch test..."

# Generate unique branch name
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
BRANCH_NAME="test-$TIMESTAMP"
PR_TITLE="Automated Test PR - $TIMESTAMP"

echo "📝 Branch: $BRANCH_NAME"
echo "📝 PR Title: $PR_TITLE"

# Trigger the workflow
gh workflow run "Required Check Workflow" \
  -f branch_name="$BRANCH_NAME" \
  -f pr_title="$PR_TITLE"

echo "✅ Workflow triggered successfully!"
echo "🔍 Monitor progress with: gh run list --workflow='Required Check Workflow'"

# Wait a moment and show the latest run
sleep 3
echo ""
echo "📊 Latest runs:"
gh run list --workflow="Required Check Workflow" --limit 3
```

Make it executable:
```bash
chmod +x scripts/test-workflow.sh
./scripts/test-workflow.sh
```

## Expected Results

After triggering the workflow, you should see:

1. **Workflow Run**: A new run appears in the Actions tab
2. **New Branch**: A new branch is created (visible in branches list)
3. **New PR**: A PR is automatically created targeting `main`
4. **Status Check**: The PR shows the "required-check" status
5. **Protection**: The PR cannot be merged until the check passes

## Verification Steps

1. **Check the PR**:
   ```bash
   gh pr list
   gh pr view <PR_NUMBER>
   ```

2. **Verify Branch Attribution**:
   - The PR should show the correct source branch
   - Commits should be attributed to the workflow branch
   - Status checks should run on the PR branch

3. **Test Required Check**:
   - Try to merge the PR before the check completes (should be blocked)
   - Wait for the check to pass (~10 seconds)
   - Verify the PR becomes mergeable

4. **Clean Up** (optional):
   ```bash
   # Close and delete the test PR and branch
   gh pr close <PR_NUMBER> --delete-branch
   ```
