# 🗄️📺⭐ TV Series Reviews (MySQL)

This is a MySQL mini database project for TV series reviews.  
It includes a clean schema, seed data, and useful reporting queries.

## 🔍 What It Does
- Creates a `tvseries` database with `series`, `reviewers`, and `reviews` tables  
- Stores ratings (0–10) for series reviewed by reviewers  
- Supports relational integrity with foreign keys  
- Provides analytics queries (averages, counts, min/max, unreviewed series)  
- Includes reviewer activity status (INACTIVE / ACTIVE / POWERUSER)  

## 🧰 Tech Stack
- MySQL 8.0+  
- SQL  

## 🚀 Run it yourself
    git clone https://github.com/EmreDursun2712/TVseries.git
    cd TVseries
    mysql -u root -p < 01_database.sql
    mysql -u root -p tvseries < 02_schema.sql
    mysql -u root -p tvseries < 03_seed.sql
    mysql -u root -p tvseries < 04_queries.sql

## 🧾 Example
- You run: Reviewer stats query  
- It returns: review_count, min/max/avg rating  
- Status becomes: POWERUSER if review_count >= 10 ✅  
- Unreviewed series query lists: series with no reviews instantly 📌  

### 🧑‍💻 Author
**[Emre Dursun](https://github.com/EmreDursun2712)**
