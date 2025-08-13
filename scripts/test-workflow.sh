#!/bin/bash
# Automated testing script for workflow_dispatch

set -e

echo "🚀 Triggering workflow_dispatch test..."

# Generate unique branch name
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
BRANCH_NAME="test-$TIMESTAMP"
PR_TITLE="Automated Test PR - $TIMESTAMP"

echo "📝 Branch: $BRANCH_NAME"
echo "📝 PR Title: $PR_TITLE"

# Check if gh CLI is available
if ! command -v gh &> /dev/null; then
    echo "❌ GitHub CLI (gh) is not installed. Please install it first."
    echo "   Visit: https://github.com/cli/cli#installation"
    exit 1
fi

# Check if authenticated
if ! gh auth status &> /dev/null; then
    echo "❌ Not authenticated with GitHub CLI. Please run: gh auth login"
    exit 1
fi

# Trigger the workflow
echo "🔄 Triggering workflow..."
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

echo ""
echo "🎯 Next steps:"
echo "1. Wait for the workflow to complete (~30 seconds)"
echo "2. Check for the new PR: gh pr list"
echo "3. Verify the required check status"
echo "4. Test merging (should be blocked until check passes)"
