# Workflow Diagram

## Pipeline Flow

```
┌─────────────────────┐     ┌─────────────────────┐
│   Schedule Trigger  │     │  Webhook Trigger     │
│  (every 24 hours)   │     │  POST /etl/trigger   │
└────────┬────────────┘     └──────────┬───────────┘
         │                             │
         └──────────┬──────────────────┘
                    ▼
         ┌──────────────────────┐
         │  Fetch CSV from URL  │  ← GET request to remote CSV
         └──────────┬───────────┘
                    ▼
         ┌──────────────────────┐
         │      Parse CSV       │  ← Rows become JSON items
         └──────────┬───────────┘
                    ▼
         ┌──────────────────────┐
         │  Transform & Clean   │  ← Rename, parse types, enrich
         │        Data          │
         └──────────┬───────────┘
                    ▼
         ┌──────────────────────┐
         │   Validate Records   │  ← Drop bad rows, log errors
         └──────────┬───────────┘
                    ▼
         ┌──────────────────────┐
         │ Aggregate & Summarize│  ← Stats: survival rate, avg age
         └──────────┬───────────┘
                    ▼
         ┌──────────────────────┐
         │    Return Result     │  ← JSON response
         └──────────────────────┘
```

## Data Shape at Each Stage

### After Parse CSV
```json
{ "PassengerId": "1", "Survived": "0", "Pclass": "3", "Name": "Braund, Mr. Owen Harris", ... }
```

### After Transform
```json
{ "id": 1, "survived": false, "passenger_class": 3, "name": "Braund, Mr. Owen Harris", "age": 22, "embarked_from": "Southampton", "family_size": 1 }
```

### After Validate
```json
{ ...same as above, "status": "valid" }
```

### After Aggregate
```json
{
  "summary": { "total_records": 891, "survival_rate_pct": "38.4", ... },
  "records": [ ... ]
}
```
