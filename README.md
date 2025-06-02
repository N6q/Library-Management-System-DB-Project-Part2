# 📚 Library Management System – DB Project Part 2

A full-featured SQL Server database project simulating a library system with real-world backend logic, automation, and reporting.

---

## 📦 Features

- ✅ Schema with relationships between Members, Books, Loans, Reviews, and Libraries
- ⚙️ Stored procedures for automated backend tasks
- 🔁 Triggers for real-time data validation and automation
- 📊 Views to support frontend dashboards and analytics
- 📈 Complex aggregations and reporting logic
- 🔐 Transactions to ensure consistency and rollback safety

---

## 🗂️ Folder Structure

```
📁 sql/
├── schema.sql
├── functions.sql
├── procedures.sql
├── triggers.sql
├── views.sql
├── transactions.sql
```

---

## 🔧 Setup Instructions

1. Create a new database in SQL Server (e.g. `LibraryDB`)
2. Run `schema.sql` to create all tables and constraints
3. Run `functions.sql`, `procedures.sql`, `triggers.sql`, and `views.sql` in order
4. Use `transactions.sql` to simulate realistic workflows (borrow, return, pay, etc.)

---

## 🧪 Sample Use Cases

- `GET /books/popular` → via `ViewPopularBooks`
- `POST /borrow` → insert loan + mark book unavailable (transaction)
- `POST /return` → update return date + mark book available
- `GET /library/occupancy` → via `ViewLibraryOccupancyDashboard`

---

## 🧠 Developer Reflection

### What part was hardest and why?
Ensuring transaction safety and building smart triggers that don’t break insert logic.

### What helped you think like a backend developer?
Creating stored procedures and reusable views. I focused on reusability, performance, and validation.

### How would you test this in a real app?
- Test all stored procs + triggers with valid & invalid data
- Confirm views return accurate reports
- Simulate full flows: borrow → return → pay

---

## 📊 Reporting Highlights

- 🔍 Most active members & libraries
- 💰 Total fines and library revenue
- ⭐ Top-rated books and most borrowed genres
- 📉 Occupancy and availability tracking

---

## ✅ Completed Sections

- [x] Indexing Strategy  
- [x] Views for frontend  
- [x] Functions for logic reuse  
- [x] Stored Procedures  
- [x] Triggers  
- [x] Dashboard Aggregations  
- [x] Transactions  
- [x] Reflection Report

---

