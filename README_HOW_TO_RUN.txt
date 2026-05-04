SUBMISSION: HOSPITAL MANAGEMENT SYSTEM (HMS) DATABASE PROJECT
============================================================

Course: Database Management Systems (DBMS)
Topic: Relational Database Design and Implementation
Engine: PostgreSQL

PROJECT OVERVIEW:
-----------------
This project implements a complete database solution for a hospital. It manages patients, 
doctors, appointments, inpatient admissions, and automated billing.

FILE STRUCTURE & INSTRUCTIONS:
------------------------------
For your convenience, the project is provided in two ways:

OPTION 1: STEP-BY-STEP EXECUTION (Recommended for Review)
Execute these scripts in the Query Tool in the following order:

1. 01_schema.sql 
   - Creates the core tables, relationships (Foreign Keys), and indexes.
2. 02_sample_data.sql 
   - Populates the database with 20+ records of realistic clinical data.
3. 03_views_functions_triggers.sql 
   - Implements business logic (age calculation, auto-billing, room status automation).
4. 04_practice_queries.sql 
   - Contains 20 SQL queries demonstrating various DBMS concepts (Joins, Aggregates, Window Functions).

OPTION 2: ONE-CLICK EXECUTION (Easiest to Run)
Alternatively, you can run the following single file to setup the entire project at once:

- Master_Script_All_IN_ONE _EASY_TO RUN..sql
  (This file combines all schemas, data, and logic for a quick setup.)


KEY FEATURES IMPLEMENTED:
-------------------------
- NORMALIZATION: The database is designed in 3rd Normal Form (3NF).
- AUTOMATION: Triggers automatically manage room occupancy and bill totals.
- REPORTING: Pre-built views for daily schedules and pending balance tracking.
- INTEGRITY: Enforced via CHECK constraints, UNIQUE keys, and Foreign Key cascades.

Thank you for your time and consideration.
============================================================
