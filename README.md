# Hospital Management Database

A PostgreSQL coursework project modelling departments, doctors, patients, appointments, admissions, prescriptions and billing. This is a database demonstration, not a production hospital application.

## Run locally

Install PostgreSQL and use an empty local database. From the repository root:

```sh
createdb hospital_demo
psql -v ON_ERROR_STOP=1 -d hospital_demo -f 01_schema.sql
psql -v ON_ERROR_STOP=1 -d hospital_demo -f 02_sample_data.sql
psql -v ON_ERROR_STOP=1 -d hospital_demo -f 03_views_functions_triggers.sql
psql -v ON_ERROR_STOP=1 -d hospital_demo -f 04_practice_queries.sql
psql -v ON_ERROR_STOP=1 -d hospital_demo -f tests/billing_view.sql
```

Add your own `-h`, `-p` and `-U` connection arguments if required. Never run setup against a database containing valuable records. Setup is not a repeatable migration; use a fresh database. The all-in-one script is an alternative, not an additional setup step.

## Implemented

- Ten related tables with primary keys, foreign keys and selected checks/indexes.
- Patient profiles, doctor schedules, available rooms, balances and medical-history views.
- SQL functions for age, availability and bills; triggers for room status and bill totals.
- Practice queries and existing project report.

The patient profile aggregates appointments and bills independently so multiple appointments cannot multiply bill totals. `tests/billing_view.sql` checks this regression in a transaction that rolls back.

## Verification and scope

The modular setup and billing regression were run successfully on PostgreSQL 18 during AI-assisted maintenance. The supplied demonstration records are for local coursework only; do not enter or publish real patient information.

There is no web interface, authentication, permission model or clinical workflow validation. Room allocation and appointment checks are educational examples, not a concurrency-safe hospital scheduling system. The sample data loads before triggers are created, preserving the original demonstration values. Bill items are not automatically reconciled with billing subtotals.

Author: Ahmad Karim. Maintenance fixes and documentation were prepared with AI assistance. Original report and source history are retained.
