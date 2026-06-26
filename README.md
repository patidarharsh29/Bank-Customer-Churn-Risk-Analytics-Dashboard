# 🏦 Customer Churn & Risk Analytics Dashboard

A full end-to-end data project that predicts which bank customers are likely to leave, segments them by churn risk, and visualizes everything in an interactive Power BI dashboard.

---

## Short Description

This project pulls raw customer and account data from a PostgreSQL database, cleans it with Python, runs it through multiple ML models to generate churn probability scores, and pushes the final predictions back to the database for Power BI to consume. The goal was to go beyond basic churn prediction and actually tell a business *who* to focus on and *why*.

---

## Tech Stack

| Layer | Tool |
|---|---|
| Database | PostgreSQL (custom `bank_churn` schema) |
| Data Processing | Python (pandas, numpy, sqlalchemy) |
| Machine Learning | scikit-learn (Logistic Regression, Decision Tree, Random Forest, Gradient Boosting) |
| Visualization | Power BI Desktop |
| File Format | `.pbix` for the dashboard, `.ipynb` for the ML pipeline, `.sql` for DB setup |

---

## Data Source

Two relational tables were created and loaded in PostgreSQL:

- **`customer_info`** — CustomerId, Name, CreditScore, Geography, Gender, Age, Tenure, EstimatedSalary
- **`account_info`** — CustomerId, Balance, NumOfProducts, HasCrCard, IsActiveMember, Exited

Both tables were joined on `CustomerId` to build the full feature set for modeling.

---

## Project Pipeline

### 1. Database Setup (`postgre_file.sql`)

Created the `bank_churn` schema with two normalized tables and loaded the CSVs using PostgreSQL's `COPY` command.

```sql
SET search_path TO bank_churn;

-- Tables: customer_info and account_info
-- Joined on CustomerId for analysis
```

### 2. Data Cleaning & ML Pipeline (`data_cleaning.ipynb`)

Connected to PostgreSQL via SQLAlchemy, pulled the joined dataset, and ran the full cleaning + modeling flow:

- Removed currency symbols (`€`, `,`) from `Balance` and `EstimatedSalary` and cast to float
- Encoded `HasCrCard` and `IsActiveMember` from Yes/No to 1/0
- Dropped duplicate `CustomerId` rows
- Created a `zero_balance` binary feature flag
- Filled missing numerical values with column medians
- Applied `StandardScaler` to numerical columns and `OneHotEncoder` to `country` and `gender`

**Models compared:**
- Logistic Regression
- Decision Tree
- Random Forest
- Gradient Boosting

Best model was selected automatically by accuracy. It was then retrained on the full dataset to generate `churn_probability` (0–100%) for every customer.

**Risk segmentation logic:**
```python
if prob >= 70:   return 'High Risk'
elif prob >= 40: return 'Medium Risk'
else:            return 'Low Risk'
```

Final predictions were written back to PostgreSQL as `bank_churn.final_bank_churn_predictions`.

### 3. Power BI Dashboard (`Customer_Churn___Risk_Analytics_Dashboard.pbix`)

Connected Power BI directly to the PostgreSQL predictions table. The dashboard includes:

- **KPI cards** — Total customers, churn rate, high/medium/low risk counts
- **Churn by Geography** — Which countries have the highest exit rates
- **Risk Segment Breakdown** — Distribution of High / Medium / Low risk customers
- **Customer-level drilldown** — Filter by country, gender, activity status
- **Probability distribution charts** — Spread of churn scores across the customer base

---

## Features / Highlights

**Business Problem**

Banks lose significant revenue when customers close accounts, and most traditional reports only show *who already left*. This project shifts the focus to *who is likely to leave next* so the retention team can act before the churn happens.

**Goal**

Build a pipeline that takes raw transactional data, runs it through a machine learning model, and delivers actionable risk scores through a dashboard that any business user can navigate without touching code.

**Key Insights the Dashboard Surfaces**

- Customers with zero balance and low activity scores cluster heavily in the High Risk segment
- Geography plays a noticeable role in churn patterns across the three regions in the dataset
- Credit score alone is a weak churn predictor — product count and activity status matter more

**Business Impact**

Retention teams can filter the dashboard to pull a list of High Risk customers by country or product type, prioritize outreach, and track whether interventions actually move customers from High to Medium risk over time.

---

## How to Run This Project

### Prerequisites
- PostgreSQL installed and running
- Python 3.8+
- Power BI Desktop

### Steps

1. **Set up the database**
   ```bash
   psql -U postgres -d projects -f postgre_file.sql
   ```

2. **Install Python dependencies**
   ```bash
   pip install pandas numpy sqlalchemy scikit-learn psycopg2-binary
   ```

3. **Run the notebook**

   Open `data_cleaning.ipynb` in Jupyter and run all cells. Update the DB connection string if needed:
   ```python
   engine = ("postgresql://postgres:<your_password>@localhost:5432/projects")
   ```

4. **Open the dashboard**

   Launch `Customer_Churn___Risk_Analytics_Dashboard.pbix` in Power BI Desktop and refresh the data source connection to point to your PostgreSQL instance.

---

## Project Structure

```
customer-churn-analytics/
│
├── postgre_file.sql                            # DB schema + data load
├── data_cleaning.ipynb                         # Cleaning + ML pipeline
├── Customer_Churn___Risk_Analytics_Dashboard.pbix  # Power BI dashboard
└── README.md
```

---

## Author

**Harsh**
B.Tech (ECE), SATI Vidisha — 2026
Aspiring Data Analyst

[LinkedIn](#) | [GitHub](#)
