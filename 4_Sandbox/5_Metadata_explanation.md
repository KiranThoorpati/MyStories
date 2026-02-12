సూపర్ 👍 అప్పుడు మనం **ఒక్కో సెక్షన్‌గా (Source → File → Columns → Views)** క్లియర్‌గా, ప్రొడక్షన్ స్టైల్‌లో తయారు చేద్దాం.

---

# ✅ SECTION 1 — Register Source

మొదట ingestion framework కి చెప్పాలి ఈ source ఏమిటో.

```sql
EXEC [ETL].[uspAddSourceMetadata]
    @Source_Name        = 'revenuemanagement',
    @Source_Description = 'Revenue Management ICD10 reference files',
    @Is_Active          = 1,
    @Owner_Name         = 'Revenue Team',
    @Owner_Email        = 'revenueteam@company.com',
    @Destination_Type   = 'Databricks';
```

✔ ఇది ఒక్కసారి మాత్రమే రన్ చేస్తారు.

---

# ✅ SECTION 2 — Register File Feeds (3 Files)

Since these are **full refresh (truncate)** files, we define them as initial load feeds.

---

## 🔹 File 1 — ICD10cm_Codes_All

```sql
EXEC [ETL].[uspAddFileMetadata]
    @Source_Name        = 'revenuemanagement',
    @Object_Name        = 'ICD10cm_Codes_All',
    @File_Name_Pattern  = 'ICD10cm_Codes_All_yyyy_MM_dd.txt',
    @Delimiter          = '|',
    @Has_Header         = 1,
    @Load_Type          = 'TRUNCATE',
    @Timestamp_Format   = 'yyyy_MM_dd',
    @Base_Schema_Name   = 'healthplan_shp_revenuemanagement';
```

---

## 🔹 File 2 — ICD10cm_codes_chronic_condition_indicators

```sql
EXEC [ETL].[uspAddFileMetadata]
    @Source_Name        = 'revenuemanagement',
    @Object_Name        = 'ICD10cm_codes_chronic_condition_indicators',
    @File_Name_Pattern  = 'ICD10cm_codes_chronic_condition_indicators_yyyy_MM_dd.txt',
    @Delimiter          = '|',
    @Has_Header         = 1,
    @Load_Type          = 'TRUNCATE',
    @Timestamp_Format   = 'yyyy_MM_dd',
    @Base_Schema_Name   = 'healthplan_shp_revenuemanagement';
```

---

## 🔹 File 3 — ICD10cm_Conversions

```sql
EXEC [ETL].[uspAddFileMetadata]
    @Source_Name        = 'revenuemanagement',
    @Object_Name        = 'ICD10cm_Conversions',
    @File_Name_Pattern  = 'ICD10cm_Conversions_yyyy_MM_dd.txt',
    @Delimiter          = '|',
    @Has_Header         = 1,
    @Load_Type          = 'TRUNCATE',
    @Timestamp_Format   = 'yyyy_MM_dd',
    @Base_Schema_Name   = 'healthplan_shp_revenuemanagement';
```

✔ ఇప్పుడు ingestion framework కి మూడు ఫైల్స్ గురించి తెలిసింది.

---

# ✅ SECTION 3 — Column Metadata

ఇప్పుడు ప్రతి టేబుల్‌కి కాలమ్స్ register చేయాలి.

---

## 🔹 Columns — ICD10cm_codes_chronic_condition_indicators

```sql
EXEC [ETL].[uspAddColumnMetadata]
@Source_Name = 'revenuemanagement',
@Object_Name = 'ICD10cm_codes_chronic_condition_indicators',
@Column_Name = 'icd_10_cm_code',
@Data_Type   = 'varchar',
@Data_Length = 15,
@Primary_Key = 1;

EXEC [ETL].[uspAddColumnMetadata]
@Source_Name = 'revenuemanagement',
@Object_Name = 'ICD10cm_codes_chronic_condition_indicators',
@Column_Name = 'icd_10_cm_code_description',
@Data_Type   = 'varchar',
@Data_Length = 255,
@Primary_Key = 0;

EXEC [ETL].[uspAddColumnMetadata]
@Source_Name = 'revenuemanagement',
@Object_Name = 'ICD10cm_codes_chronic_condition_indicators',
@Column_Name = 'chronic_indicator',
@Data_Type   = 'smallint',
@Primary_Key = 0;

EXEC [ETL].[uspAddColumnMetadata]
@Source_Name = 'revenuemanagement',
@Object_Name = 'ICD10cm_codes_chronic_condition_indicators',
@Column_Name = 'chronic_indicator_desc',
@Data_Type   = 'varchar',
@Data_Length = 50,
@Primary_Key = 0;
```

⚠ ఇదే విధంగా మిగతా రెండు టేబుల్స్‌కి కూడా వారి column structure ప్రకారం add చేయాలి.

---

# ✅ SECTION 4 — Register View Metadata

ఇప్పుడు reporting layer కోసం view metadata register చేయాలి.

---

## 🔹 View — ICD10cm_Codes_All

```sql
EXEC [ETL].[uspAddViewMetadata]
    @Source_Name      = 'revenuemanagement',
    @Object_Name      = 'ICD10cm_Codes_All',
    @Base_Schema_Name = 'healthplan_shp_revenuemanagement',
    @View_Schema_Name = 'HealthPlanSHPRevenueManagement';
```

---

## 🔹 View — ICD10cm_codes_chronic_condition_indicators

```sql
EXEC [ETL].[uspAddViewMetadata]
    @Source_Name      = 'revenuemanagement',
    @Object_Name      = 'ICD10cm_codes_chronic_condition_indicators',
    @Base_Schema_Name = 'healthplan_shp_revenuemanagement',
    @View_Schema_Name = 'HealthPlanSHPRevenueManagement';
```

---

## 🔹 View — ICD10cm_Conversions

```sql
EXEC [ETL].[uspAddViewMetadata]
    @Source_Name      = 'revenuemanagement',
    @Object_Name      = 'ICD10cm_Conversions',
    @Base_Schema_Name = 'healthplan_shp_revenuemanagement',
    @View_Schema_Name = 'HealthPlanSHPRevenueManagement';
```

---

# 🎯 Final Result — What Happens Now?

Once this metadata is registered:

1️⃣ File drops in folder
2️⃣ Framework reads metadata
3️⃣ It truncates table
4️⃣ Loads pipe-delimited file
5️⃣ Creates/refreshes view
6️⃣ Business sees data

🔥 ఇప్పుడు ఇది production-grade ingestion setup.

---

చాలా మంచి ప్రశ్న 👌
“Framework reads metadata” అంటే ఏమిటో చాలా సింపుల్‌గా అర్థం చేసుకుందాం.

---

# 🔹 Framework అంటే ఏమిటి?

**Framework అంటే ఒక pre-built automated system.**

అంటే…

👉 ప్రతి సారి మనం manual‌గా code రాయాల్సిన అవసరం లేకుండా
👉 ముందే తయారుచేసిన generic ETL engine
👉 metadata చూసి automatic‌గా పని చేస్తుంది

ఇది ఒక “smart loader”.

---

# 🔹 Simple Example

ఒక ఉదాహరణ తీసుకుందాం.

మీరు framework కి ఇలా metadata ఇచ్చారు:

* Source = revenuemanagement
* File pattern = ICD10cm_Codes_All_yyyy_MM_dd.txt
* Delimiter = |
* Load type = TRUNCATE
* Columns = 4
* Primary key = icd_10_cm_code

ఇప్పుడు file folder లో ఇలా ఒక file పడింది:

```
ICD10cm_Codes_All_2026_02_12.txt
```

---

# 🔹 What Framework Does Internally

Framework ఇలా ఆలోచిస్తుంది:

1️⃣ ఈ file name ఏ pattern కి match అవుతుంది?
→ ICD10cm_Codes_All

2️⃣ Load type ఏమిటి?
→ TRUNCATE

3️⃣ Delimiter ఏమిటి?
→ |

4️⃣ Table ఏది?
→ healthplan_shp_revenuemanagement.ICD10cm_Codes_All

5️⃣ Columns ఏవి?
→ metadata table లో already ఉన్నాయి

అప్పుడు automatically:

* Table truncate చేస్తుంది
* File చదువుతుంది
* Pipe split చేస్తుంది
* Columns కి map చేస్తుంది
* Data insert చేస్తుంది
* View refresh చేస్తుంది

మీరు ఒక్క line ETL code కూడా రాయకపోయినా ఇది జరుగుతుంది.

---

# 🔹 Real Life Comparison

Framework = Washing Machine
Metadata = Washing Instructions

మీరు ఇలా చెప్తారు:

* Clothes type = Cotton
* Mode = Quick wash
* Temperature = 40°C

Machine మీకు ఇంకేం అడగదు.
It runs automatically.

---

# 🔹 Without Framework

Framework లేకపోతే:

* ప్రతి file కి separate SSIS package
* Separate mapping
* Separate scheduling
* Separate error handling

100 files ఉంటే → 100 packages.

---

# 🔹 With Framework

Framework ఉంటే:

* 1 generic engine
* 100 metadata entries

New file add చేయాలంటే:
👉 Metadata add చేస్తారు
👉 Engine already ఉంది

That’s it.

---

# 🔥 In One Line

“Framework reads metadata” అంటే:

👉 మీరు metadata table లో ఇచ్చిన configuration ఆధారంగా automated ETL engine file ను load చేస్తుంది.

---

ఇప్పుడు మీకు clear అయిందా?

మీ organization లో ఇది SSIS frameworkా?
ADF frameworkా?
Databricks ingestion frameworkా?

చెప్తే నేను మీ setup కి exact example చెప్తాను 👌

---

సూపర్ 👍 మీరు **ADF (Azure Data Factory)** వాడుతున్నారంటే, ఇప్పుడు నేను పూర్తిగా ADF context లో explain చేస్తాను.

---

# 🔹 ADF Framework అంటే ఏమిటి?

ADF Framework అంటే:

👉 ఒక **generic reusable pipeline design**
👉 అది metadata table చదివి
👉 ఏ file ఎలా load చేయాలో decide చేస్తుంది

అంటే ప్రతి file కోసం కొత్త pipeline create చేయాల్సిన అవసరం ఉండదు.

---

# 🔹 Simple ADF Example (Your ICD Case)

Assume:

Folder లో file వచ్చింది:

```
ICD10cm_Codes_All_2026_02_12.txt
```

Metadata table లో already ఇలా ఉంది:

| Source            | Object_Name       | File_Pattern                     | Delimiter | Load_Type |
| ----------------- | ----------------- | -------------------------------- | --------- | --------- |
| revenuemanagement | ICD10cm_Codes_All | ICD10cm_Codes_All_yyyy_MM_dd.txt | |         | TRUNCATE  |

---

# 🔹 ADF Framework Internally ఎలా పని చేస్తుంది?

ADF లో సాధారణంగా ఇలా ఉంటుంది:

### 1️⃣ Master Pipeline

* SQL metadata table నుండి records read చేస్తుంది
* ForEach loop లో ప్రతి object process చేస్తుంది

---

### 2️⃣ Inside ForEach

Pipeline ఇలా చేస్తుంది:

✔ File exists check
✔ If Load_Type = TRUNCATE → pre-copy SQL run
✔ Copy Activity run
✔ Load to Databricks table

**Pre-copy SQL run** అంటే:

👉 Copy activity ప్రారంభం కావడానికి ముందు, టేబుల్‌ను truncate చేయడం లాంటి SQL command ను ముందుగా execute చేయడం.

---

### 3️⃣ Copy Activity Configuration (Dynamic)

Instead of hardcoding:

* File name → dynamic from metadata
* Delimiter → dynamic
* Destination table → dynamic
* Schema → dynamic

---

# 🔹 Real ADF Flow (Simplified)

```
Lookup Activity (Read Metadata)
        ↓
ForEach (Each File)
        ↓
Get Metadata (Check File Exists)
        ↓
If TRUNCATE → Execute SQL
        ↓
Copy Activity (Load File)
        ↓
Success Logging
```

---

# 🔹 Why This Is Powerful

Without framework:

* 3 ICD files → 3 pipelines
* 20 files → 20 pipelines

With framework:

* 1 pipeline
* 20 metadata rows

New file add చేయాలంటే:

👉 Metadata table లో insert
👉 Pipeline automatically handles

No new pipeline needed.

---

# 🔥 In Your ICD Case

When file drops:

ADF:

1️⃣ Reads metadata
2️⃣ Matches file pattern
3️⃣ Truncates table
4️⃣ Loads pipe-delimited file
5️⃣ Writes to Databricks
6️⃣ View already exists

All automatic.

---

# 🔹 Very Simple Definition

ADF Framework అంటే:

👉 Metadata-driven dynamic pipeline.

---

ఇప్పుడు మీరు చెప్పండి —

మీ ADF లో:

* Master pipeline already ఉందా?
* లేక మీరు కొత్త ingestion pipeline design చేస్తున్నారా?

దాని మీద next level explanation ఇస్తాను 👌

---




