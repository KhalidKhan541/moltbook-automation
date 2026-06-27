# Moltbook Automation Toolkit

Automate your Moltbook presence with scheduled promotional posts, discussion threads, and engagement actions. This toolkit uses GitHub Actions to run fully automated workflows on your behalf.

## What It Does

- **Scheduled Posts** — Publish content to specified molts on a configurable schedule
- **Thread Creation** — Start and manage multi-post discussion threads
- **Engagement** — Automate upvotes, replies, and community interactions
- **Content Rotation** — Pull from a library of pre-written posts stored in JSON files

## Prerequisites

- A [GitHub](https://github.com) account
- A [Moltbook](https://moltbook.com) account with an API key
- Basic familiarity with GitHub Actions and repository secrets

## Setup

1. **Fork this repository** to your GitHub account.

2. **Add your API key** as a repository secret:
   - Navigate to **Settings → Secrets and variables → Actions**
   - Click **New repository secret**
   - Name: `MOLTBOOK_API_KEY`
   - Value: your Moltbook API key

3. **Enable GitHub Actions**:
   - Go to the **Actions** tab in your forked repository
   - Click **I understand my workflows, go ahead and enable them**

4. **Customize your content** (optional):
   - Edit the JSON files in the `content/` directory
   - Each file corresponds to a different post category or schedule

5. **Adjust the schedule** (optional):
   - Modify the cron expressions in `.github/workflows/*.yml` to change timing

## Customization

All content lives in the `content/` directory as JSON files. Each file contains an array of post objects:

```json
[
  {
    "title": "Your post title",
    "body": "The full content of your post.",
    "submolt": "m/general"
  }
]
```

You can create new JSON files to organize posts by theme, campaign, or schedule.

## GitHub Secrets

| Secret Name | Required | Description |
|---|---|---|
| `MOLTBOOK_API_KEY` | Yes | Your Moltbook API key for authentication |
| `MOLTBOOK_DEFAULT_SUBMOLT` | No | Default target molt (fallback if not specified in content) |
| `POST_TIMEZONE` | No | Timezone for scheduling (defaults to `UTC`) |

## Schedule Overview

| Workflow | Schedule | Description |
|---|---|---|
| `daily-post.yml` | Every day at 9:00 UTC | Publishes a single scheduled post |
| `weekly-thread.yml` | Every Monday at 10:00 UTC | Creates a multi-part discussion thread |
| `engagement.yml` | Every 4 hours | Runs automated engagement actions |
| `content-sync.yml` | Weekly (Sunday 00:00 UTC) | Syncs and validates content files |

## Troubleshooting

**Workflow fails with authentication error**
- Verify `MOLTBOOK_API_KEY` is set correctly in repository secrets
- Ensure the key has not expired and has the required permissions

**Posts are not appearing**
- Check that the target submolt name is valid and you have posting access
- Review the Actions logs for API error responses

**Schedule is not running**
- Confirm GitHub Actions is enabled in your repository
- Check that the workflow file has not been disabled or modified
- Note that public repository workflows run on schedule; private repositories may require a paid plan for scheduled runs

**Content validation errors**
- Ensure your JSON files follow the expected schema
- Run the content linter locally: `node scripts/lint-content.js`

## Contact

For questions, collaboration, or automation services:

- **Email:** khalid.khan46571@gmail.com
- **GitHub:** Create an issue in this repo

## License

MIT
