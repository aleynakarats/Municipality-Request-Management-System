# Municipality Request Management System

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-blue?logo=postgresql)
![SQL](https://img.shields.io/badge/SQL-Database-blue)
![PLpgSQL](https://img.shields.io/badge/PL%2FpgSQL-Functions-success)
![Git](https://img.shields.io/badge/Git-Version%20Control-orange?logo=git)
![GitHub](https://img.shields.io/badge/GitHub-Portfolio-black?logo=github)


A PostgreSQL-based Municipality Request Management System developed during my Database Internship.

--

# Project Overview
This project is a relational database system designed to manage municipality service requests submitted by citizens.
The system simulates a real municipality workflow where requests are created by citizens, assigned to employees, managed by department managers, and monitored by database administrators.
The project was developed using PostgreSQL and includes advanced database concepts such as triggers, transactions, indexing, RBAC security, backup & restore, monitoring, and performance optimization.

--

# Features:
- Citizen Request Management
- Department & Category Management
- Employee Assignment
- Request Status Tracking
- Request History
- Notification System
- Audit Logging
- Database Triggers
- PL/pgSQL Functions
- Transaction Management
- Role-Based Access Control (RBAC)
- Backup & Restore
- Performance Optimization
- Database Monitoring

--

# Technologies
- PostgreSQL
- PL/pgSQL
- pgAdmin 4
- SQL
- Git
- Github

--
# Project Structure

Municipality-Request-Management-System
├── Backup_Restore
│	├── municipality.backup
│	├── schema_only.backup
│	└── data_only.backup
├── create_tables.sql
├── deadlock.sql
├── index_performance_report.sql
├── indexes.sql
├── monitoring.sql
├── monitoring_queries.sql
├── security.sql
├── seed_data.sql
├── seed_data_function.sql
├── transaction.sql
├── trigger.sql
├── views.sql
└── README.md

--

# Database Modules

- Database Design

- Relational Model

- Third Normal Form (3NF)

- Constraints

- Views

- PL/pgSQL Functions

- Triggers

- Transactions

- Savepoints

- Lock & Deadlock

- Role Based Access Control

- Audit Logging

- Notification System

- Backup & Restore

- Performance Optimization

- Monitoring

--

# Municipality Workflow

Citizen
    │
    ▼
Create Request
    │
    ▼
Department Manager
    │
Assign Employee
    │
    ▼
Employee
    │
Process Request
    │
    ▼
Request Status Updated
    │
    ├──────────────┐
    ▼              ▼
Notification    Audit Log
    │              │
    ▼              ▼
Request History Created


--

# Security

Available roles:
-Citizen
-Employee
-Manager
-ReadOnly
-DBA

Permissions were managed using:
-CREATE ROLE
-GRANT
-REVOKE
-ALTER ROLE
-SECURITY DEFINER

--

#Trigger System

Implemented automatic database automation using PostgreSQL Triggers.

## Request History Trigger

Automatically records every request status change.

## Notification Trigger

Automatically sends notifications to:

- Managers
- Employees
- Citizens

depending on request status.

## Audit Log Trigger

Stores:

- INSERT
- UPDATE
- DELETE

operations into the audit_logs table.

--

# Performance Optimization

Implemented:
-Single Column Indexes
-Composite Indexes
-Partial Indexes
-EXPLAIN
-EXPLAIN ANALYZE

Performance improvements were verified using PostgreSQL execution plans.

--

# Backup & Restore

Implemented backup strategies using PostgreSQL tools.

-Full Backup
-Schema Backup
-Data Backup
-Restore Operations

--

# Monitoring

The project includes PostgreSQL monitoring queries for analyzing database health and performance.

Implemented monitoring queries include:

- Active Database Sessions (`pg_stat_activity`)
- Blocking Sessions Detection (`pg_blocking_pids`)
- Lock & Wait Analysis
- Database Statistics (`pg_stat_database`)
- Cache Hit Ratio Analysis
- Sequential Scan vs Index Scan Statistics
- Index Usage Statistics (`pg_stat_user_indexes`)
- Database Index Information (`pg_indexes`)
- Table Size Analysis (`pg_relation_size`)
- Total Relation Size Analysis (`pg_total_relation_size`)

--

# Concepts Practices

- Database Design
- Normalization
- Constraints
- Views
- PL/pgSQL
- Functions
- Triggers
- Transactions
- Savepoints
- Lock
- Deadlock
- RBAC
- Security Definer
- Backup
- Restore
- Monitoring
- Indexes
- Performance Optimization
- VACUUM
- EXPLAIN ANALYZE

--

# Screenshots

- ER Diagram
- pgAdmin Tables
- Trigger Demonstration
- Audit Logs
- Notifications
- Security Tests
- EXPLAIN ANALYZE Results

--

# Future Improvements

- REST API Integration
- Docker Support
- PostgreSQL Partitioning
- CI/CD Pipeline
- Web Application Integration

#Author

Aleyna Karataş

PostgreSQL | SQL | PL/pgSQL | Database Design
























