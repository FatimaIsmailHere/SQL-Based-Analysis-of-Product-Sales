# 🎵 Chinook Music Store Analysis — SQL Project

This project uses a simulated music store database (Chinook) to analyze sales, customer behavior, and product performance using PostgreSQL.


## 📁 Contents

- ✅ Database Schema: 11 normalized tables including `Customer`, `Invoice`, `Track`, `Album`, `Genre`, and more.
- 📊 SQL Queries: Analytical queries written to answer key business questions using JOINs and window functions.


## 🏗️ Database Schema Overview

### Main Tables:
- `Artist` – stores artist information
- `Album` – links albums to artists
- `Track` – product catalog of songs
- `Genre`, `MediaType` – categorization
- `Invoice`, `InvoiceLine` – sales data
- `Customer`, `Employee` – user and support data
- `Playlist`, `PlaylistTrack` – playlists

---

## 📈 Business Questions Answered

### Revenue
- Total revenue generated
- Revenue by country
- Top 5 revenue-generating customers

### Product Sales
- Top 10 tracks by revenue
- Top albums by units sold
- Top-selling track per genre using `RANK()`

🧠 Tech Used
Database: PostgreSQL
Tools: pgAdmin, Excel (for CSV cleaning)
Concepts:
SQL DDL (CREATE TABLE)
SQL JOINs (INNER JOIN)
Aggregation (SUM, COUNT)
Window Functions (RANK(), ROW_NUMBER())

Created by Fatima Ismail
Chinook-based music sales analysis project using SQL and PostgreSQL.
