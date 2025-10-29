# Data Catalog for Gold Layer

## Overview
The Gold Layer is the business-level data representation, structured to support analytical and reporting use cases. It consists of **dimension tables** and **fact tables** for specific business metrics.

---
### 1. **gold.dim_companies**
- **Purpose:** Stores company details enriched with demographic and geographic data.
- **Columns:**

| Column Name      | Data Type     | Description                                                                                   |
|------------------|---------------|-----------------------------------------------------------------------------------------------|
| customer_key     | INT           | Surrogate key uniquely identifying each company record in the dimension table.               |
| customer_id      | INT           | Unique numerical identifier assigned to each company.                                        |
| name             | VARCHAR(255)  | The company's name.                                                     |
| country          | VARCHAR(255)  | The country of residence for the company (e.g., 'Australia').                               |

---

### 2. **gold.dim_contacts**
- **Purpose:** Stores contact details enriched with demographic and geographic data.
- **Columns:**

| Column Name      | Data Type     | Description                                                                                   |
|------------------|---------------|-----------------------------------------------------------------------------------------------|
| customer_key     | INT           | Surrogate key uniquely identifying each contact record in the dimension table.               |
| customer_id      | VARCHAR(255)  | Unique numerical identifier assigned to each contact.                                        |
| country          | VARCHAR(255)  | The country of residence for the contact (e.g., 'Australia').                                |
| create_date      | DATE          | The date when the contact record was created in the system                          |
| main_company     | INT           | The contact person's main contact company.                               |


---

### 3. **gold.dim_articles**
- **Purpose:** Provides information about the articles and their attributes.
- **Columns:**

| Column Name      | Data Type     | Description                                                                                   |
|------------------|---------------|-----------------------------------------------------------------------------------------------|
| article_key      | INT           | Surrogate key uniquely identifying each article record in the dimension table.               |
| customer_id      | VARCHAR(255)  | Unique numerical identifier assigned to each article.                                        |
| familiy          | VARCHAR(255)  | The article's family.                                                                        |

---

### 4. **gold.dim_date**
- **Purpose:** Stores date dimension table for time-based analysis and reporting.
- **Columns:**

| Column Name      | Data Type     | Description                                                                                   |
|------------------|---------------|-----------------------------------------------------------------------------------------------|
| date_key         | INT           | Surrogate key for the date dimension.                                                         |
| date             | DATE          | The actual calendar date, typically in YYYY-MM-DD format.                                     |
| year             | INT           | Four-digit year component of the date.                                                        |
| month            | INT           | Month number (1-12) representing the month of the year.                                       |
| month_name       | NVARCHAR      | Full name of the month (e.g., January, February).                                             |        
| quarter          | INT           | Quarter number (1-4) representing the business quarter.                                       |
| weekday_number   | INT           | Quarter number (1-4) representing the business quarter.                                       |
| weekday_name     | NVARCHAR      | Full name of the weekday (e.g., Monday, Tuesday).                                             |

---

### 5. **gold.fact_visits**
- **Purpose:** Stores visits data for analytical purposes.
- **Columns:**

| Column Name      | Data Type     | Description                                                                                   |
|------------------|---------------|-----------------------------------------------------------------------------------------------|
| visit_key        | INT           | Surrogate key uniquely identifying each visit record in the fact table.                       |
| visit_id         | INT           | Unique numerical identifier assigned to each visit.                                           |
| company_id       | INT           | Foreign key linking to the company dimension, identifies the visited company.                 |
| contact_id       | VARCHAAR(255) | Foreign key linking to the contact dimension, identifies the person visited.                  |                      
| date             | DATE          | Date when the sales visit occurred.                                                           |
| visit_duration   | INT           | Duration of the visit in minutes, measures engagement length.                                 |
| shortlist_article_1  | VARCHAAR(255)  | First product/article shortlisted during the visit (primary preference).                 |            
| shortlist_article_2  | VARCHAAR(255)  | Second product/article shortlisted during the visit (secondary preference).              |                  
| shortlist_article_3  | VARCHAAR(255)  | Third product/article shortlisted during the visit (tertiary preference).                |

---
