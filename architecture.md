# BloodConnect Architecture

This document tracks the implementation plan and key decisions for both the Flutter frontend and the Node.js + MySQL backend.

## 1) MVP Features & Technical Constraints
- Auth: JWT (access + refresh), login/register/logout/refresh, secure persistent session
- Role-aware navigation: Donor, Recipient, BloodBankManager, Technician, Staff, Admin, MedicalStaff
- REST API with typed service layer using Dio
- Real-time urgent alerts with Socket.IO, fallback to polling
- Forms with validation + optional image upload
- Theming, responsive layout, accessibility (tap targets, contrast)
- Environment-based API base URL
- Web support (Chrome)
- Backend: Express, Sequelize, MySQL, migrations + seeders, Swagger docs, rate limiting, helmet, winston logging

## 2) Implementation Steps (Prioritized)
1. Backend scaffolding (Express, Sequelize, models, migrations, auth, roles)
2. Auth endpoints (register/login/refresh/logout), role middleware, validations
3. Core modules: requests, donations, appointments, inventory, notifications
4. Socket.IO server broadcast + REST fallback for urgent alerts
5. Seed data + SQL dump; Swagger
6. Flutter: core structure, theme, env config, ApiClient with interceptors (JWT + refresh)
7. Providers (Auth, Alerts, Requests), role-aware router guards
8. UI pages for Auth and role dashboards; forms + validation + file upload
9. Charts (fl_chart) for manager dashboard
10. Final polish: accessibility, responsiveness, animations, compile & tests

## 3) Widget Hierarchy & Component Structure
- app/
  - app_shell.dart (custom top bar + content)
  - app_router (go_router config + guards)
- features/
  - auth/ (login_page, register_page)
  - donor/ (dashboard, profile, history)
  - recipient/ (dashboard, request_form)
  - manager/ (dashboard with charts)
  - staff/ (appointments)
  - technician/ (eligibility, inventory update)
  - admin/ (approvals, audit logs)
  - medical/ (urgent requests)
- widgets/
  - buttons (PrimaryButton, SecondaryButton)
  - inputs (AppTextField, ChoiceChipX)
  - cards (StatCard, ListTileX, ImageTileX)
  - feedback (EmptyState, LoadingOverlay, Snack)

## 4) Data Models (Flutter)
- UserModel, RoleModel, RequestModel, DonationModel, AppointmentModel, InventoryUnitModel, NotificationModel, FeedbackModel, AuditLogModel
- Each with: id, createdAt, updatedAt, toJson, fromJson, copyWith

## 5) Services (Flutter)
- ApiClient (Dio, interceptors for access/refresh, 401 handling)
- AuthService, RequestService, DonationService, AppointmentService, InventoryService, NotificationService, ReportService

## 6) Business Logic
- AuthProvider maintains tokens + user + auto refresh
- Role-aware navigation guards based on role in AuthProvider
- AlertsProvider connects to Socket.IO; fallback to periodic polling
- RequestsProvider manages CRUD and optimistic UI where relevant

## 7) Maintainability & Reusability
- Feature-based folders
- Reusable components and tokens (theme.dart)
- Separate models/services/providers

## 8) Debugging
- All errors logged via debugPrint
- Compile project after all changes using analyzer

## 9) Backend Data Model (Sequelize)
- users (FK role), roles, donors, recipients, blood_banks, technicians, staff, requests, appointments, donations, inventory_units, notifications, feedback, audit_logs, reports
- Indexes on blood group and location where applicable

## 10) Security & Performance
- helmet, cors, rate limiting, express-validator, winston logs
- Parameterized queries via Sequelize

## 11) Real-time Notifications
- socket.io for urgent alerts
- REST fallback endpoint /notifications/urgent

## 12) API Docs
- Swagger (OpenAPI YAML)

This plan will be updated as features are added.