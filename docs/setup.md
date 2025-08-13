# Repository Setup for Testing workflow_dispatch

## 1. Setting up Required Checks for Merging to Main

To configure required checks for the main branch, follow these steps:

### Via GitHub Web Interface:

1. **Navigate to Repository Settings**
   - Go to your repository on GitHub
   - Click on the "Settings" tab
   - Select "Branches" from the left sidebar

2. **Add Branch Protection Rule**
   - Click "Add rule" or "Add branch protection rule"
   - In "Branch name pattern", enter: `main`

3. **Configure Protection Settings**
   - ✅ Check "Require a pull request before merging"
   - ✅ Check "Require status checks to pass before merging"
   - ✅ Check "Require branches to be up to date before merging"
   - In the search box under "Status checks", type: `required-check`
   - Select the `required-check` job from the dropdown
   - ✅ Check "Require conversation resolution before merging" (optional but recommended)
   - ✅ Check "Include administrators" (optional, enforces rules on admins too)

4. **Save the Rule**
   - Click "Create" or "Save changes"

### Via GitHub CLI (Alternative):

```bash
# Enable branch protection with required checks
gh api repos/:owner/:repo/branches/main/protection \
  --method PUT \
  --field required_status_checks='{"strict":true,"contexts":["required-check"]}' \
  --field enforce_admins=true \
  --field required_pull_request_reviews='{"required_approving_review_count":1}' \
  --field restrictions=null
```

## 2. Workflow Overview

The `required-check.yml` workflow has two jobs:

### `create-pr-and-test` Job
- **Trigger**: `workflow_dispatch` only
- **Purpose**: Creates a new branch and PR to test the required check
- **Actions**:
  - Creates a new branch with timestamp or custom name
  - Makes a test commit
  - Pushes the branch
  - Creates a PR targeting main

### `required-check` Job
- **Trigger**: `pull_request` and `push` events
- **Purpose**: Acts as the required status check
- **Actions**:
  - Runs validation tests
  - Simulates test work (10-second delay)
  - Validates branch attribution for PRs

## 3. Testing the Setup

### Step 1: Push to Repository
```bash
git add .
git commit -m "Initial setup for workflow_dispatch testing"
git push origin main
```

### Step 2: Trigger workflow_dispatch
See the testing instructions in `../scripts/trigger-workflow.md`

### Step 3: Verify Required Check
1. The workflow should create a new PR
2. The PR should show the "required-check" status
3. The PR should not be mergeable until the check passes
4. Branch attribution should be correctly maintained

## 4. Expected Behavior

1. **workflow_dispatch Trigger**: Creates a new branch and PR
2. **PR Creation**: Automatically triggers the required-check job
3. **Status Check**: Shows as pending, then passes after ~10 seconds
4. **Branch Protection**: PR cannot be merged until check passes
5. **Attribution**: All actions are correctly attributed to the source branch

## 5. Troubleshooting

### Common Issues:

1. **Status check not appearing**: 
   - Ensure the job name matches exactly in branch protection settings
   - Check that the workflow has run at least once

2. **Permission errors**:
   - Ensure `GITHUB_TOKEN` has sufficient permissions
   - Check repository settings for Actions permissions

3. **Branch protection not working**:
   - Verify the branch name pattern is exactly `main`
   - Ensure required status checks are properly configured

### Verification Commands:

```bash
# Check branch protection status
gh api repos/:owner/:repo/branches/main/protection

# List recent workflow runs
gh run list --workflow=required-check.yml

# View specific workflow run
gh run view <run-id>
```
