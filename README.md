# 🔄 n8n CSV-to-JSON ETL Pipeline

A beginner-friendly **Extract → Transform → Load** data pipeline built with [n8n](https://n8n.io). It fetches a CSV file from a URL, cleans and transforms the data, validates each record, aggregates statistics, and returns a structured JSON output.

---

## 📦 What's Inside

```
n8n-etl-pipeline/
├── workflows/
│   └── csv-to-json-etl.json     # The n8n workflow (import this)
├── data/
│   └── sample/
│       └── titanic_sample.csv   # Sample data for testing
├── scripts/
│   └── import-workflow.sh       # Auto-import script
├── docs/
│   └── workflow-diagram.md      # Visual overview of the pipeline
├── docker-compose.yml           # Run n8n locally with Docker
└── README.md
```

---

## 🏗️ Pipeline Architecture

```
[Schedule / Webhook Trigger]
          │
          ▼
[Fetch CSV from URL]          ← Extract
          │
          ▼
[Parse CSV]                   ← Extract
          │
          ▼
[Transform & Clean Data]      ← Transform
          │
          ▼
[Validate Records]            ← Transform
          │
          ▼
[Aggregate & Summarize]       ← Load (in-memory)
          │
          ▼
[Return JSON Result]          ← Output
```

### Node Descriptions

| Node | Role | What it does |
|---|---|---|
| Schedule Trigger | Extract | Runs the pipeline every 24 hours |
| Webhook Trigger | Extract | Lets you trigger manually via HTTP POST |
| Fetch CSV from URL | Extract | Downloads raw CSV from a remote URL |
| Parse CSV | Extract | Converts CSV text into structured rows |
| Transform & Clean Data | Transform | Renames fields, parses types, enriches data |
| Validate Records | Transform | Filters out invalid/incomplete rows |
| Aggregate & Summarize | Load | Computes survival rate, avg age, class counts |
| Return Result | Output | Sends final JSON back to the webhook caller |

---

## 🚀 Getting Started

### Prerequisites
- [Docker](https://docs.docker.com/get-docker/) & Docker Compose
- OR [n8n installed globally](https://docs.n8n.io/hosting/installation/npm/) via npm

---

### Option A: Run with Docker (Recommended)

```bash
# 1. Clone the repo
git clone https://github.com/YOUR_USERNAME/n8n-etl-pipeline.git
cd n8n-etl-pipeline

# 2. Start n8n
docker-compose up -d

# 3. Import the workflow
chmod +x scripts/import-workflow.sh
./scripts/import-workflow.sh

# 4. Open n8n in your browser
open http://localhost:5678
# Login: admin / changeme123
```

---

### Option B: Run with n8n CLI

```bash
# Install n8n globally
npm install -g n8n

# Start n8n
n8n start

# Open http://localhost:5678 and import the workflow manually
# Go to: Workflows → Import from File → select workflows/csv-to-json-etl.json
```

---

## ▶️ Running the Pipeline

### Trigger manually via Webhook

```bash
curl -X POST http://localhost:5678/webhook/etl/trigger
```

### Trigger via n8n UI

1. Open the workflow in n8n
2. Click **"Execute Workflow"** (▶ button)

---

## 📊 Sample Output

```json
{
  "summary": {
    "total_records": 891,
    "survived": 342,
    "did_not_survive": 549,
    "survival_rate_pct": "38.4",
    "average_age": "29.7",
    "passengers_by_class": { "1": 216, "2": 184, "3": 491 },
    "generated_at": "2026-05-04T10:30:00.000Z"
  },
  "records": [
    {
      "id": 1,
      "survived": false,
      "passenger_class": 3,
      "name": "Braund, Mr. Owen Harris",
      "gender": "male",
      "age": 22,
      "fare": "7.25",
      "embarked_from": "Southampton",
      "family_size": 1,
      "status": "valid",
      "processed_at": "2026-05-04T10:30:00.000Z"
    }
  ]
}
```

---

## 🔧 Customization Ideas

| What to change | Where |
|---|---|
| Use your own CSV URL | `Fetch CSV from URL` node → URL field |
| Add more transformations | `Transform & Clean Data` node → JS code |
| Save to a database | Add a **Postgres / MySQL / MongoDB** node after Validate |
| Send results to Slack | Add a **Slack** node at the end |
| Change schedule | `Schedule Trigger` node → interval settings |

---

## 📚 Learning Resources

- [n8n Documentation](https://docs.n8n.io)
- [n8n Community Forum](https://community.n8n.io)
- [n8n YouTube Channel](https://www.youtube.com/@n8n-io)

---

## 📄 License

MIT — free to use, modify, and share.
