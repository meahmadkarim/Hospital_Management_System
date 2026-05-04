
# Hospital Management System (HMS)

## Overview

This project is a PostgreSQL-based Hospital Management System designed to manage core hospital operations including patients, doctors, appointments, medical records, admissions, rooms, and billing. The system demonstrates relational database design principles, normalization, and advanced SQL features such as views, triggers, functions, and analytical queries.

## Features

The system includes patient registration and management, doctor and department management, appointment scheduling, medical records and prescription tracking, room allocation and admission handling, and a complete billing system with detailed bill items. It also includes automation using triggers and reporting using SQL views and queries.

## Database Structure

The database consists of the following main tables: departments, doctors, patients, rooms, appointments, medical_records, prescriptions, admissions, billing, and bill_items. All tables are connected through properly defined primary and foreign key relationships to ensure data integrity and consistency.

## Advanced SQL Features

The project includes SQL views for reporting such as patient profiles, doctor schedules, and pending bills. It also includes functions for reusable logic like age calculation, doctor availability checks, and billing calculations. Triggers are implemented to automate tasks such as room status updates and automatic bill calculation. Additionally, complex SQL queries are used for analysis and reporting.

## Technologies Used

PostgreSQL, SQL (DDL, DML, DQL), and pgAdmin are used for the implementation of this project.

## Sample Data

The system includes realistic sample data consisting of 20 patients, 10 doctors, multiple appointments and admissions, and complete billing and prescription records to demonstrate real-world functionality.

## How to Run

To run the project, first create a PostgreSQL database named hospital_db. Then execute the provided SQL files in the following order: schema file, sample data file, and views/functions/triggers file. After setup, sample queries can be executed to test and analyze the system.

## Documentation

For complete details of the project, including schema design, ERD, relationships, and screenshots, please refer to the file Final_HMS_Project_Report.docx included in the repository.

## Learning Outcomes

This project demonstrates strong understanding of relational database design, normalization, entity-relationship modeling, advanced SQL programming, and real-world system implementation.

## Author

Ahmad Karim
University of Central Asia
