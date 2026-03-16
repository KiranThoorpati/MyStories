Here's a step-by-step breakdown of how to implement this **WebMD File Ingestion (Optima_Health_Eligibility)** for the PSDB project:

---

## Step 1: Understand the Current Setup

- There's an **existing FTP job** that already picks up files from:
  `\\corp.ad.sentara.com\shpdfs\ga-internal\WebMD`
- The same path is currently used as both the **FTP source** and the **CSC drop location**
- Files are archived at:
  `\\corp.ad.sentara.com\shpdfs\Archive\Clinical-Flat-WebMD\WebMD Eligibility Files`

---

## Step 2: Create a New FTP Job

- **Do NOT modify** the existing CSC drop location — leave it as-is
- Create a **new FTP job** that:
  - Picks up files from: `\\corp.ad.sentara.com\shpdfs\ga-internal\WebMD`
  - Moves/copies them to a **new landing folder** (e.g., `...\LandingArea\WebMD\`)
- Schedule the job to run at **1:00 AM Daily**

---

## Step 3: File Validation on Pickup

Before ingestion, validate the incoming file:

- File must be named: `Optima_Health_Eligibility.TXT`
- File format must be: `.TXT` (Comma Separated)
- Check for:
  - Correct **headers** (per the spec in `Optima Health Eligibility.xlsx`)
  - Expected **field count** per row
  - Correct **data types** in each column
  - No **malformed or empty rows**

---

## Step 4: Ingest into Target Table

- Load strategy: **Full file / Current Day** (truncate & reload, not append)
- Target table/view: **`Optima_Health_Eligibility`**
- Business area: **Clinical / Quality - Health Plan**
- Map columns from the flat file to the target table columns per the spec sheet

---

## Step 5: Post-Ingestion Validation

After loading, perform these checks:

- **Record count** validation — compare row count in file vs. rows loaded into the table
- **Structural check** — confirm all expected columns are present and populated correctly
- **Duplicate check** if applicable per the spec

---

## Step 6: Error Handling & Logging

- If the file has **missing headers**, **malformed rows**, or **unexpected columns** → **reject the file**
- Generate an **error log** for each failed file including:
  - File name
  - Timestamp
  - Error reason (e.g., "Missing header", "Column count mismatch")
  - Row number where the error occurred (if applicable)
- Send **alerts/notifications** to the team on failure

---

## Step 7: Archival

- After successful ingestion, move the processed file to the **archival location**:
  `\\corp.ad.sentara.com\shpdfs\Archive\Clinical-Flat-WebMD\WebMD Eligibility Files`
- Consider appending a **date stamp** to the archived file name for traceability (e.g., `Optima_Health_Eligibility_20260316.TXT`)

---

## Step 8: Testing & Acceptance

Before go-live, verify all **acceptance criteria**:

| Criteria | How to Test |
|---|---|
| File received in `.TXT` format | Drop a test file and confirm pickup |
| Naming convention matches | Use correct and incorrect names to test rejection |
| Record count validation works | Compare file rows vs. DB rows |
| Malformed files are rejected | Send a file with bad headers/columns |
| Error logs are generated | Trigger an error and check log output |

---

## Open Questions to Resolve First

Before starting, get answers to:
1. What is the exact **new landing area path** for the new FTP job?
2. Should the **existing CSC drop location** continue to receive files in parallel?
3. Who owns the FTP job modification — is it Harpal Singh or Oral A. Thomas?
4. Is the spec file (`Optima Health Eligibility.xlsx`) finalized and available?

---

Would you like help drafting a comment back to the team, writing the technical spec, or building out the FTP/ingestion script logic?
