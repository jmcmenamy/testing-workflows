# Testing Workflows Repository

This repository is set up to test GitHub Actions workflow_dispatch functionality with required checks and proper branch attribution.

## Purpose

- Test workflow_dispatch triggers
- Verify required checks for main branch protection
- Ensure workflows are correctly attributed to the branch where PRs are created

## Structure

- `.github/workflows/` - Contains GitHub Actions workflows
- `scripts/` - Helper scripts for testing
- `docs/` - Documentation for setup and testing procedures

## Testing Workflow

1. The workflow can be triggered via workflow_dispatch
2. It creates a new branch and PR
3. It serves as a required check for merging to main
4. Branch attribution is properly maintained

## Setup Instructions

See `docs/setup.md` for detailed setup instructions.
