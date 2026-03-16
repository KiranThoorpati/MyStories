# FTP / SFTP Job Setup — Process Reference Guide
> Data Engineering & Platform Team | Internal Documentation

---

## Table of Contents
1. [Purpose & Overview](#1-purpose--overview)
2. [When to Submit an FTP Request](#2-when-to-submit-an-ftp-request)
3. [Information to Gather Before You Start](#3-information-to-gather-before-you-start)
4. [Step-by-Step: Submitting the FTP Request](#4-step-by-step-submitting-the-ftp-request)
5. [After Submission — What to Expect](#5-after-submission--what-to-expect)
6. [Common Mistakes & How to Avoid Them](#6-common-mistakes--how-to-avoid-them)
7. [Quick Reference Card](#7-quick-reference-card)
8. [Checklist Before You Submit](#8-checklist-before-you-submit)

---

## 1. Purpose & Overview

This guide documents the end-to-end process for submitting an FTP/SFTP job request. It is intended as a reference for any analyst or engineer setting up a new file transfer automation, including first-timers.

Use this document whenever you need to:
- Set up a new FTP/SFTP job (**Create**)
- Update an existing job — e.g., new file, schedule change, path change (**Update**)
- Shut down a job that is no longer needed (**Disable**)

---

## 2. When to Submit an FTP Request

| Scenario | Action |
|---|---|
| New file/automation for the first time | Submit with **Request Type = CREATE** |
| Same file, updated schedule or path | Submit with **Request Type = UPDATE** |
| Shutting down an existing job | Submit with **Request Type = DISABLE** |
| Annual recurring file (e.g. Admin Cost file) | CREATE first time; UPDATE if path/schedule changes in future years |

> **Note:** For most day-to-day work, you will only use **CREATE** or **UPDATE**. DISABLE is rare.

---

## 3. Information to Gather Before You Start

Before opening the SFTP request form, confirm you have the following details from your analyst or business stakeholder:

| Item | How to Get It |
|---|---|
| **Business Entity** | Check the data — SHP = Sentara Health Plans, OHP = Optima, AFMED = AFMED. Ask analyst if unsure. |
| **File Name & Pattern** | Get exact name from analyst. Year/date must follow format: `YYYYMMDD` (e.g., `admin_cost_ytd_20250201.xlsx`) |
| **File Pickup Location** | Full server path where the source file will be placed. Get from business/vendor. |
| **File Drop-off Location** | EDP production landing area path. Get from your story or analyst. |
| **Archive Location** | Path to store the file after successful transfer. Provided in the story. |
| **Transfer Frequency** | How often the file is expected. If exact date is unknown, use **Daily**. |
| **Inbound or Outbound** | Inbound = file coming IN to EDP. Outbound = file going OUT. |
| **Enhancement / Idea Number** | Found in your Jira story details. Optional field. |
| **Email for Notifications** | ADP FTP Ops group email + any business contacts who need alerts. |
| **Vendor (if external)** | Name of the external vendor. If internal transfer, mark as **No**. |

> **Note:** Always ask the analyst for the **exact file path and naming convention**. Incomplete paths will cause the job to fail silently.

---

## 4. Step-by-Step: Submitting the FTP Request

### Step 1 — Open the Request Portal

Use the link shared by your team to access the FTP/SFTP request portal. There are three resources available:

- **Link 1:** Overview of the FTP process *(read when you have time)*
- **Link 2:** Field definitions — explains every field in the form
- **Link 3:** The actual SFTP request form to submit ← *bookmark this*

---

### Step 2 — Fill in the SFTP Request Form (Online Portal)

Complete all mandatory fields (marked with a red asterisk `*`):

| Field | Required? | Guidance |
|---|---|---|
| Your Name | ✅ Yes | Your full name |
| Email | ✅ Yes | Your work email |
| Phone Number | ✅ Yes | Your contact number |
| Request Type | ✅ Yes | `CREATE` / `UPDATE` / `DISABLE` |
| Business Entity | ✅ Yes | Usually **Sentara Health Plans**. Check data for SHP/OHP/AFMED. |
| Service / Enhancement | Optional | Enhancement or Idea number from your Jira story (if available) |
| New Vendor? | ✅ Yes | **No** for most internal transfers |
| New File with Vendor? | ✅ Yes | **No** if the same file has run before, even if the year in the name changes |
| Internal File Transfer? | ✅ Yes | **Yes** for internal paths with no external vendor |
| Due Date | ✅ Yes | Auto-populates to 2 business weeks. Leave as is. |
| Transfer Method | ✅ Yes | Pick the first option if internal. The FTP team will confirm details with you. |
| Protocol | ✅ Yes | **Network Share** for internal. **SFTP** for external vendor. |
| Special Instructions | Optional | Add notes for the FTP developer. E.g., *"Second row is the production job."* |
| Part of a Project? | ✅ Yes | Yes → provide project number. No → leave blank. |

---

### Step 3 — Fill in the SFTP Excel Attachment

In addition to the online form, you must fill out the **SFTP Excel file** and attach it to the request.

> **Always create two rows — one for TEST and one for PRODUCTION.**

| Field | Required? | Guidance |
|---|---|---|
| File Name | ✅ Yes | Use `*` for variable parts — e.g., `admin_cost_ytd_*.xlsx` |
| Inbound / Outbound | ✅ Yes | Inbound = arriving at EDP. Outbound = leaving EDP. |
| Zipped? | ✅ Yes | Excel files → `N/A`. Zipped bundles → `Yes` |
| File Pickup Location | ✅ Yes | Full server path where file will be picked up |
| File Drop-off Location | ✅ Yes | EDP landing area path (fill for both test and production rows) |
| File Content Category | ✅ Yes | `Finance`, `Health Plan`, `Commercial`, etc. — based on file data |
| Frequency & Time | ✅ Yes | Daily at `2:00 PM` if no specific date is given |
| Post-Trans Delete — TEST | ✅ Yes | **NO** — keep file available for re-testing |
| Post-Trans Delete — PROD | ✅ Yes | **YES** — delete after successful production transfer |
| Archive Location | ✅ Yes | From your story. Production row only. Leave blank for test. |
| Success/Failure Email | ✅ Yes | ADP FTP Ops group email + business stakeholder emails |

#### Test vs. Production Settings at a Glance

| Setting | TEST Job | PRODUCTION Job |
|---|---|---|
| Post-Trans Delete Source | **NO** | **YES** |
| Archive File? | **NO** | **YES** |
| Archive Location | Leave blank | Paste from story |

---

### Step 4 — Attach & Submit

1. Click **"Add Attachments"** in the portal
2. Attach the filled SFTP Excel file
3. Click **Submit**
4. Note down the **RITM number** generated after submission
5. Paste the RITM number into your **Jira story** so the analyst can track it

> **Tip:** Save the filled Excel form to your **OneDrive** or attach it to your Jira story. It is much easier to update an existing form than to redo it from scratch next time.

---

## 5. After Submission — What to Expect

| Event | What to Do |
|---|---|
| FTP developer tags you in the request | You'll get an email notification. Reply in the portal or via Teams. |
| Developer asks for more information | Provide file paths, schedule, or business contacts as needed. |
| Test job is set up | Verify a test run. Once confirmed, ask the developer to promote to Production. |
| Business needs a one-time manual run | Direct them to contact the FTP team for a **"run once" ticket**. Do not do this yourself. |
| Job is live in Production | Monitor the success/failure email notifications. |

---

## 6. Common Mistakes & How to Avoid Them

| Mistake | How to Avoid It |
|---|---|
| File name has only the year (e.g. `_2024.xlsx`) | Must use `YYYYMMDD` format: `_20250201.xlsx` — remind business/CLE team to update the file name. |
| Incomplete file path submitted | Always use the **full server path**. Partial paths cause the job to sweep and miss the file. |
| Only one row in the Excel (no test/prod split) | Always create **separate rows** for TEST and PRODUCTION jobs. |
| Post-transmission delete set to YES for test | Set **DELETE = NO** for test, **YES** for production only. |
| Treating a year-changed file as a "new file" | If the file name pattern is the same (just the year changes), it's the **same file** — answer `No` to the "new file" question. |
| Not noting RITM in Jira story | Always paste the RITM number in your story so the analyst can track status. |

---

## 7. Quick Reference Card

### Business Entity Lookup

| Code in Data | Business Entity to Select |
|---|---|
| `SHP` | Sentara Health Plans |
| `OHP` | Optima Health Plans |
| `AFMED` | AFMED |
| Virginia Premier / Commercial | Sentara Health Plans *(confirm with analyst)* |

> **Rule of thumb:** ~95% of the time it will be **Sentara Health Plans**.

---

### Key Contacts

| Role | Contact |
|---|---|
| FTP Operations Team | **ADP FTP Ops** — add this group email to all success/failure notifications |
| Internal SME (Process) | **Bhargavi / Shana** — reach out via Teams for any process questions |
| Story / Business Details | Your assigned analyst (e.g., Klee or project analyst) |

---

## 8. Checklist Before You Submit

- [ ] Confirmed business entity (SHP / OHP / AFMED)
- [ ] File name uses wildcard for variable part (e.g., `admin_cost_ytd_*.xlsx`)
- [ ] File name date format confirmed as `YYYYMMDD` with business/CLE team
- [ ] Full server paths obtained for pickup, drop-off, and archive locations
- [ ] Excel attachment has **two rows**: TEST and PRODUCTION
- [ ] Post-trans delete: **NO** for test, **YES** for production
- [ ] Email notifications filled: ADP FTP Ops + business stakeholder
- [ ] RITM number noted and added to Jira story after submission
- [ ] Filled Excel form saved to OneDrive / Jira attachment

---

*Document prepared from FTP onboarding training session — For internal use only*
