Ah—got it. That’s an **important constraint**, and thanks for calling it out 👍
Let’s reset cleanly and design this **100% within your actual architecture**, **without any Databricks code changes**.

You **can still do this**. The key is **where** the `Survey_Key` is derived.

---

# Revised Design

## Adding `Survey_Key` With **No Databricks Changes**

Since you **cannot modify Databricks notebooks or logic**, the derivation must happen in **one of these layers**:

1. **SQL / Metadata-driven load logic** (preferred in your case)
2. **View layer** (safe fallback)

We will **NOT** touch:

* Databricks notebooks
* Avro conversion logic
* Pipeline code

---

## Option 1 (Recommended): Derive `Survey_Key` in the SQL View Layer

This is the **cleanest and safest** option given your constraints.

### Why this works

* You already control view metadata
* Views are designed for business logic
* No changes to ingestion or base tables
* No SSIS required

---

## How It Fits Your Existing Workflow

### What stays the same

```
Landing → Avro → Base Table → View
```

### What changes

* `Survey_Key` is added **inside the view**
* Base tables remain unchanged

---

## Step-by-Step Workflow (Updated)

### Step 1: Metadata Setup (No Change)

* Source system metadata
* File feed metadata
* Column metadata (ONLY for physical columns)

🚫 Do **not** add `Survey_Key` as a physical column.

---

### Step 2: File Ingestion (No Change)

* File lands
* Converted to Avro
* Loaded into base tables exactly as-is

---

### Step 3: Add `Survey_Key` in View Metadata

This is the **only change**.

You update:

```sql
[dataops].[uspAddDatabricksViewMetadata]
```

### Example: Survey Questions View

```sql
SELECT
    concat(cast(Year as string), '_', QID) AS Survey_Key,
    Year,
    QID,
    Question_Text
FROM survey_base.survey_questions
```

### Example: Survey Responses View

```sql
SELECT
    concat(cast(Year as string), '_', QID) AS Survey_Key,
    Year,
    QID,
    Response_Value,
    Patient_ID
FROM survey_base.survey_responses
```

📌 Result:

* Both views expose `Survey_Key`
* Join happens at the view level

---

## Step 4: Joining Questions and Responses

```sql
SELECT
    r.Patient_ID,
    q.Question_Text,
    r.Response_Value
FROM survey_responses_vw r
JOIN survey_questions_vw q
  ON r.Survey_Key = q.Survey_Key;
```

---

## Option 2: SQL Stored Procedure Layer (If Views Are Not Allowed)

If your framework supports **SQL-based post-load transformations**, you can:

* Create a **cross-reference table**
* Populate `Survey_Key` using SQL only

Example:

```sql
INSERT INTO survey_xref
SELECT
    Year,
    QID,
    concat(cast(Year as varchar(4)), '_', QID) AS Survey_Key
FROM survey_questions;
```

This still:

* Avoids Databricks changes
* Avoids SSIS
* Keeps logic centralized

---

## Why You Still Don’t Need SSIS

Even with this constraint:

* Logic is declarative
* No row-level transformations
* SQL views handle derivation efficiently

SSIS would:

* Duplicate logic
* Increase maintenance
* Add operational overhead

---

## Decision Matrix

| Option                    | Databricks Change | Pipeline Change | Recommended |
| ------------------------- | ----------------- | --------------- | ----------- |
| Source file change        | ❌                 | ❌               | ❌           |
| Avro change               | ❌                 | ❌               | ❌           |
| Base table change         | ❌                 | ❌               | ❌           |
| **View-layer derivation** | ❌                 | ❌               | ✅           |
| SSIS                      | ❌                 | ❌               | ❌           |

---

## Final Recommendation

Given your constraints:

✅ **Derive `Survey_Key` in the view layer using metadata**
✅ **Expose it consistently in both questions and responses views**
❌ Do not modify Databricks
❌ Do not introduce SSIS

This approach is:

* Fully compliant with your architecture
* Low risk
* Review-friendly
* Easy to roll back

---

If you want next, I can:

* Rewrite this as a **formal exception / constraint note**
* Create a **design justification for auditors**
* Show how to **handle null Year/QID safely**
* Provide a **Confluence-ready summary**

Just tell me 👍
