Awesome 👍
Below is a **clean, architecture-review–ready document** you can directly use in a design review, Confluence page, or approval deck.
It is written in **clear, enterprise-style Markdown**, aligned exactly with **your metadata-driven ingestion framework**.

---

# Architecture Review Document

## Metadata-Driven Ingestion of Survey Questions & Responses

---

## 1. Overview

This document describes the architecture and workflow used to ingest **Survey Questions** and **Survey Responses** into the data platform using a **metadata-driven pipeline**. The design supports multi-year surveys and enables accurate joins between questions and responses using a derived **Survey_Key (Year + QID)**.

The solution leverages:

* SQL-based metadata control tables
* Stored procedures for configuration
* Databricks for processing
* Avro as the standardized intermediate format

No SSIS components are required.

**1. Overview (సారాంశం)**

ఈ document లో Survey Questions మరియు Survey Responses ను data platform లోకి ఎలా ingest చేస్తామో — architecture మరియు workflow వివరించబడింది.

ఈ process metadata-driven pipeline ఆధారంగా పనిచేస్తుంది.
ఈ design multi-year surveys ను support చేస్తుంది మరియు **Survey_Key (Year + QID)** ఉపయోగించి questions మరియు responses మధ్య accurate joins చేయడానికి సహాయపడుతుంది.

### ఈ solution లో ఉపయోగించే ముఖ్యమైన components:

* SQL ఆధారిత metadata control tables
* Configuration కోసం Stored Procedures
* Processing కోసం Databricks
* Standard intermediate format గా Avro
* SSIS components అవసరం లేదు

ఈ architecture flexible గా, scalable గా మరియు multi-year data కి suitable గా design చేయబడింది.

---

## 2. Business Requirement

* Survey questions vary by year
* Survey responses must be joined to the correct question text
* The same QID may exist across multiple years
* A reliable and scalable join mechanism is required

### Key Requirement

Create a **cross-year join key** using:

```
Survey_Key = Year + '_' + QID
```

**2. Business Requirement (వ్యాపార అవసరం)**

* Survey questions ప్రతి సంవత్సరం మారే అవకాశం ఉంది
* Survey responses సరైన question text తో తప్పకుండా join అవ్వాలి
* ఒకే QID వేర్వేరు సంవత్సరాల్లో ఉండే అవకాశం ఉంది
* అందుకే ఒక reliable మరియు scalable join mechanism అవసరం

---

### **Key Requirement (ముఖ్యమైన అవసరం)**

Cross-year join కోసం ఒక key తయారు చేయాలి:

**Survey_Key = Year + '_' + QID**

ఇలా Year మరియు QID కలిపి unique key తయారు చేస్తే, ప్రతి సంవత్సరం data సరిగా match అవుతుంది మరియు ఎలాంటి confusion ఉండదు.

---

## 3. High-Level Architecture

```
Source Files
   ↓
Landing Area
   ↓
Avro Conversion
   ↓
Processed Folder
   ↓
Metadata-Driven Pipeline
   ↓
Databricks Base Tables
   ↓
Business Views
```

---

## 4. Control Plane (Metadata Layer)

All ingestion behavior is driven by metadata stored in SQL Server and maintained via stored procedures.

### Metadata Components

| Component       | Purpose                                 |
| --------------- | --------------------------------------- |
| Source System   | Identifies data source and ownership    |
| Event Trigger   | Controls initial vs incremental loads   |
| File Feed       | Defines file patterns and load strategy |
| Column Metadata | Defines schema and data types           |
| View Metadata   | Defines business-facing views           |

📌 **No pipeline code changes are required when onboarding new files**.

**4. Control Plane (Metadata Layer) – కంట్రోల్ ప్లేన్**

అన్ని ingestion behavior, **SQL Server** లో ఉన్న metadata ద్వారా control అవుతుంది. ఈ metadata ను stored procedures ద్వారా maintain చేస్తారు.

### **Metadata Components (మెటాడేటా భాగాలు)**

| Component           | Purpose (ఉద్దేశ్యం)                                                |
| ------------------- | ------------------------------------------------------------------ |
| **Source System**   | Data ఎక్కడి నుంచి వస్తుందో మరియు ownership ఏది అనేది గుర్తిస్తుంది |
| **Event Trigger**   | Initial load లేదా incremental load ను control చేస్తుంది            |
| **File Feed**       | File pattern మరియు load strategy ను define చేస్తుంది               |
| **Column Metadata** | Table schema మరియు data types ను define చేస్తుంది                  |
| **View Metadata**   | Business users ఉపయోగించే views ను define చేస్తుంది                 |

📌 కొత్త files onboarding చేయాలంటే pipeline code మార్చాల్సిన అవసరం లేదు — metadata update చేస్తే సరిపోతుంది.

ఇది system ను flexible గా మరియు scalable గా ఉంచుతుంది.

---

## 5. Runtime Data Flow (Step-by-Step)

### Step 1: Metadata Setup (QA Environment)

* Metadata scripts are executed in QA
* Stored procedures populate control tables
* Pipeline configuration is finalized before runtime

📌 This is a **one-time or versioned activity**.

---

### Step 2: File Arrival (Landing Zone)

* Survey files are dropped into the landing folder
* Files remain unchanged (raw state)

Examples:

```
survey_questions_2024.psv
survey_responses_virtual_2024.psv
```

---

### Step 3: Landing → Avro Conversion

* Files are converted to Avro
* No transformations or derived columns are applied
* Schema matches source file structure

📌 Avro represents the **raw canonical copy**.

---

### Step 4: Pipeline Trigger & Metadata Resolution

* Pipeline detects Avro files
* Metadata is read to determine:

  * Target table
  * Load strategy
  * Schema definition

---

### Step 5: Base Table Creation (Databricks)

* Tables are created dynamically if not present
* Schema is derived entirely from column metadata
* Distribution and data types are enforced

---

### Step 6: Survey_Key Derivation (Critical Design Point)

`Survey_Key` is **not provided by the source**
`Survey_Key` is **not added during Avro conversion**

Instead:

```sql
Survey_Key = concat(cast(Year as string), '_', QID)
```

This logic is applied:

* During Databricks load
* Using standardized ingestion templates
* Consistently across questions and responses

📌 This ensures:

* Consistency
* Governance
* No duplication of logic

---

### Step 7: Data Load into Base Tables

* Raw data is loaded
* Derived column `Survey_Key` is populated
* Load strategy applied:

  * Initial: truncate + load
  * Incremental: append

---

### Step 8: Business View Creation

* Views are created using metadata-defined SQL
* Views expose clean, consumer-ready data

Example:

```sql
SELECT
  Survey_Key,
  Year,
  QID,
  Question_Text
FROM survey_base.survey_questions;
```

---

## 6. Survey Questions & Responses Integration

### Survey Questions Table

* Year
* QID
* Question_Text
* Survey_Key (derived)

### Survey Responses Table

* Year
* QID
* Response_Value
* Patient_ID
* Survey_Key (derived)

### Join Condition

```sql
responses.Survey_Key = questions.Survey_Key
```

📌 Join is:

* Deterministic
* Year-aware
* Future-proof

---

## 7. Why SSIS Is Not Required

SSIS is **not used** because:

* Processing is set-based and scalable
* Databricks handles transformations efficiently
* Metadata-driven design replaces SSIS packages
* No row-by-row logic is required

| Capability        | Provided By     |
| ----------------- | --------------- |
| Schema management | Metadata tables |
| File ingestion    | Pipelines       |
| Transformations   | Databricks      |
| Orchestration     | Event triggers  |

---

## 8. Key Design Decisions

| Decision               | Rationale                       |
| ---------------------- | ------------------------------- |
| Derived Survey_Key     | Prevents ambiguity across years |
| Metadata-driven schema | Reduces manual effort           |
| Avro as intermediate   | Ensures schema stability        |
| No source-side logic   | Centralized governance          |
| No SSIS                | Simplified architecture         |

---

## 9. Risks & Mitigations

| Risk                    | Mitigation                    |
| ----------------------- | ----------------------------- |
| Missing Year or QID     | Metadata validation           |
| Inconsistent key format | Centralized derivation logic  |
| Schema drift            | Schema versioning in metadata |

---

## 10. Benefits

* Scalable across years
* No pipeline code changes
* Clean separation of raw vs derived data
* Easy onboarding of new survey files
* Audit-ready and review-friendly

---

## 11. Conclusion

This architecture provides a **robust, metadata-driven, and scalable solution** for ingesting survey data and enabling accurate joins between questions and responses. The derived `Survey_Key` ensures consistency while keeping the ingestion framework clean and governed.
