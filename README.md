# Municipality Request Management System

A PostgreSQL-based Municipality Request Management System developed during my Database Internship.

--

# Project Overview
This project is a relational database system designed to manage municipality service requests submitted by citizens.
The system simulates a real municipality workflow where requests are created by citizens, assigned to employees, managed by department managers, and monitored by database administrators.
The project was developed using PostgreSQL and includes advanced database concepts such as triggers, transactions, indexing, RBAC security, backup & restore, monitoring, and performance optimization.

--

# The system includes:
-Citizen Request Management
-Employee Assignment
-Department Management
-Request Tracking
-Request History
-Audit Logging
-Notification System
-Security(RBAC)
-Transaction Management
-Backup & Restore
-Performance Optimization
-Database Monitoring

--

# Technologies
-PostgreSQL
-PL/pgSQL
-pgAdmin 4
-SQL
-Git
-Github

--
# Project Structure

Municipality-Request-Management-System
├── Backup_Restore
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
└── views.sql

--

# Database Modules

-Database Design
-Normalization(3NF)
-Constraints
-Views
-PL/pgSQL Functions
-Triggers
-Transactions
-Security(RBAC)
-Indexes
-Performance Optimization
-Monitoring
-Backup & Restore

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

# Performance Optimization

Implemented:
-Single Column Indexes
-Composite Indexes
-Partial Indexes
-EXPLAIN
-EXPLAIN ANALYZE

--

# Backup % Restore

Implemented backup strategies using PostgreSQL tools.

-Full Backup
-Schema Backup
-Data Backup
-Restore Operations

--

#Author

Aleyna Karataş

























