Sure thing 👍 Here’s a clean, clear **Markdown version** of your description, structured so it’s easy to read and drop into documentation or a ticket.

---

## Description

### Request

To support the requirement of joining survey questions with patient responses, survey questions must be standardized and ingested in a consistent format by year, including **QID** and **Question Text**.

Annual survey question files will be ingested to enable accurate joins between survey questions and patient responses. The join will be performed using a **concatenated key composed of Year and QID**, ensuring that each response is mapped to the correct question.

This process will be used to build a **cross-reference table** that enables joins between survey responses and survey questions across different years.

ఈ requirement అంటే ఏమిటంటే:

Survey questions ను patient responses తో join చేయడానికి, ప్రతి సంవత్సరం survey questions ను ఒకే format లో standard గా load చేయాలి. అందులో **Year**, **QID**, మరియు **Question Text** తప్పనిసరిగా ఉండాలి.

ప్రతి సంవత్సరం వచ్చే survey question files ను system లో load చేస్తాం. తర్వాత survey questions మరియు patient responses ని join చేయడానికి **Year + QID** ని కలిపి ఒక key తయారు చేస్తాం.

అలా చేయడం వల్ల ప్రతి patient response సరైన question కి match అవుతుంది.

ఈ process ద్వారా ఒక cross-reference table తయారు చేస్తాం. ఇది వేర్వేరు సంవత్సరాల survey questions మరియు responses ని సరిగ్గా join చేయడానికి ఉపయోగపడుతుంది.

---

## Survey Questions

* Maintained in the same format for each year
* Includes:

  * **Year**
  * **QID**
  * **Question Text**

---

## Key Logic

* A **concatenated key (Year + QID)** will be used to:

  * Join the appropriate question to the answer received
  * Ensure uniqueness of each question-response mapping

---

## File Details

* **File Format:** Pipe (`|`) delimited
* **Frequency:** Annual files

---

## Additional Information

* Mark Anderson will produce a model to support ingestion of:

  * **In-Person survey response files**
  * **Virtual survey response files**
* Survey response files will be broken down by components.
* The concatenated **Year + QID** key will be used to join each response to the corresponding survey question at a unique record level.

---

Got it 👍
Here’s a **Technical Design Document** version, clean and implementation-ready, written in **Markdown**.

---

# Technical Design Document

## Survey Questions & Responses Integration

---

## 1. Purpose

The purpose of this design is to enable accurate and scalable joins between **survey questions** and **patient survey responses** across multiple years. This will be achieved by ingesting annual survey question files and creating a **cross-reference structure** that supports joining responses to their corresponding questions using a **concatenated key (Year + QID)**.

---

## 2. Scope

This design covers:

* Ingestion of **annual survey question files**
* Standardization of survey question data across years
* Creation of a **cross-reference table**
* Join logic between:

  * Survey Questions
  * In-Person Survey Responses
  * Virtual Survey Responses

Out of scope:

* Survey distribution logic
* Data visualization or reporting layer

---

## 3. Data Sources

### 3.1 Survey Questions Files

* **Frequency:** Annual
* **Format:** Pipe (`|`) delimited
* **Content:** Survey questions for a specific year

#### Required Fields

| Field Name    | Description                |
| ------------- | -------------------------- |
| Year          | Survey year                |
| QID           | Unique question identifier |
| Question_Text | Full survey question text  |

---

### 3.2 Survey Response Files

* **Types:**

  * In-Person Survey Responses
  * Virtual Survey Responses
* **Produced By:** Mark Anderson ingestion model
* **Structure:** Broken down by logical components

#### Required Fields (minimum)

| Field Name     | Description               |
| -------------- | ------------------------- |
| Year           | Survey year               |
| QID            | Question identifier       |
| Response_Value | Patient’s response        |
| Patient_ID     | Unique patient identifier |
| Response_Date  | Date of response          |

---

## 4. File Format Specification

### 4.1 Survey Questions File (Pipe Delimited)

```
Year|QID|Question_Text
2023|Q01|How satisfied were you with your visit?
2023|Q02|Would you recommend our service to others?
```

---

## 5. Key Design Concept

### 5.1 Concatenated Key

A **concatenated key** will be created using:

```
Survey_Key = Year + '_' + QID
```

Example:

```
2023_Q01
```

This key will be used consistently across:

* Survey Questions
* Survey Responses
* Cross-reference tables

---

## 6. Data Model Design

### 6.1 Survey Questions Table

| Column Name   | Data Type | Description           |
| ------------- | --------- | --------------------- |
| Year          | Integer   | Survey year           |
| QID           | String    | Question identifier   |
| Question_Text | String    | Question text         |
| Survey_Key    | String    | Concatenated Year_QID |

---

### 6.2 Survey Responses Table

| Column Name    | Data Type | Description               |
| -------------- | --------- | ------------------------- |
| Patient_ID     | String    | Unique patient identifier |
| Year           | Integer   | Survey year               |
| QID            | String    | Question identifier       |
| Response_Value | String    | Patient response          |
| Response_Date  | Date      | Date of response          |
| Survey_Key     | String    | Concatenated Year_QID     |

---

### 6.3 Cross-Reference Table

This table enables consistent joins between responses and questions.

| Column Name   | Description         |
| ------------- | ------------------- |
| Survey_Key    | Year + QID          |
| Year          | Survey year         |
| QID           | Question identifier |
| Question_Text | Survey question     |

---

## 7. Join Logic

Survey responses will be joined to survey questions using the **Survey_Key**.

### Join Condition

```sql
responses.Survey_Key = questions.Survey_Key
```

This ensures:

* Correct question is linked to each response
* Year-specific question wording is preserved
* No ambiguity across survey years

---

## 8. Ingestion & Processing Flow

1. Ingest annual **Survey Questions** file
2. Validate required fields (Year, QID, Question_Text)
3. Generate `Survey_Key`
4. Load into Survey Questions table
5. Ingest Survey Responses (In-Person & Virtual)
6. Generate `Survey_Key` in response data
7. Join responses to questions using cross-reference table

---

## 9. Assumptions & Constraints

### Assumptions

* QID is unique **within a year**
* Survey questions may change year-to-year
* Year + QID uniquely identifies a question

### Constraints

* Missing Year or QID will prevent joins
* Pipe-delimited format must be consistent
* Survey_Key must be generated identically across all datasets

---

## 10. Benefits of This Design

* Supports multi-year survey analysis
* Ensures accurate question-to-response mapping
* Scalable for new survey years
* Simplifies downstream analytics and reporting

---



