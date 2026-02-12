చాలా మంచి ప్రశ్న 👍

ఇందులో ఉన్నవి:

```
@Ingest_Load_strategy = 'truncate',
@Sdw_Load_strategy    = 'truncate'
```

వీటిని చాలా సింపుల్‌గా అర్థం చేసుకుందాం.

---

# 🔹 1️⃣ @Ingest_Load_strategy = 'truncate'

👉 ఇది **Ingestion layer (landing / raw layer)** లో ఎలా లోడ్ చేయాలో చెప్తుంది.

`truncate` అంటే:

* కొత్త ఫైల్ వచ్చినప్పుడు
* ముందున్న డేటా మొత్తం delete (truncate) చేస్తుంది
* కొత్త ఫైల్ డేటా మాత్రమే insert చేస్తుంది

అంటే table లో ఎప్పుడూ **latest file data మాత్రమే ఉంటుంది.**

---

# 🔹 2️⃣ @Sdw_Load_strategy = 'truncate'

👉 ఇది **SDW / curated / warehouse layer** లో ఎలా లోడ్ చేయాలో చెప్తుంది.

ఇది కూడా `truncate` అయితే:

* Warehouse table కూడా truncate అవుతుంది
* Fresh data reload అవుతుంది

---

# 🔹 Impact ఏమిటి?

Since రెండూ `truncate`:

Every time file comes:

1️⃣ Raw table truncate
2️⃣ Raw load
3️⃣ SDW table truncate
4️⃣ SDW load

👉 Old data retain కాదు
👉 Only latest full snapshot ఉంటుంది

---

# 🔹 Real Example (Your ICD Case)

Assume:

Yesterday file had → 10,000 ICD codes
Today file has → 10,200 ICD codes

With truncate:

* 10,000 delete
* 10,200 insert

Final table → 10,200 rows only

No duplicates
No history

---

# 🔥 If It Was 'append' Instead?

Then:

* Old 10,000 remain
* New 10,200 add
* Total = 20,200 rows

Duplicates వచ్చే అవకాశం ఉంది.

---

# 🎯 One Line Meaning

👉 `Ingest_Load_strategy` = Raw layer లో ఎలా లోడ్ చేయాలి
👉 `Sdw_Load_strategy` = Warehouse layer లో ఎలా లోడ్ చేయాలి
👉 `truncate` అంటే ప్రతి సారి full refresh చేయడం

---

ICD reference files కి truncate strategy usually correct 👍
