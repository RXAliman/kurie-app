---
feature: data_persistence
---
Integrate Hive or SQLite for local data persistence in the Kurie app. Currently, all data is hardcoded in screen state.

**Task:**
1. Define data models for:
   - `Submeter` (id, name, unit, tenantId, lastReading, status).
   - `Reading` (id, submeterId, value, timestamp, imageUrl).
   - `Bill` (id, month, amount, kwh, status, timestamp).
   - `Notification` (id, title, description, type, timestamp, isRead).
2. Set up a local storage service (e.g., `LocalDatabaseService`).
3. Replace hardcoded lists in `PropertyManagementScreen`, `NotificationCenterScreen`, and `AdminDashboardScreen` with data fetched from the local store.
4. Ensure the \"Add Submeter\" and \"Log Reading\" forms actually save data to the store.

# Next Task: Billing PDF Generation

The persistence layer is now robust and uses **Hive CE**. The next feature is to implement the **Billing PDF Generation** module.

## Requirements:
1. **PdfService**: Implement a service using `pdf` and `printing` packages.
2. **Individual Bill Report**: 
   - A single-paged, high-fidelity bill statement for a specific tenant.
   - Include company logo, billing period, submeter details, and a breakdown of costs.
3. **All-Tenant Cuttable Report**:
   - A summary document designed for printing and cutting.
   - Layout: 2x4 grid (or similar) of small slips.
   - Each slip must contain: Date, Tenant Name, Current Reading, Previous Reading, kWh Usage, Rate, and Total Cost (₱).
4. **UI Integration**:
   - Add a "Download Statement" button to `BillDetailsScreen` for individual reports.
   - Add a "Generate Summary Report" button to `AdminDashboardScreen` or `PropertyManagementScreen` for the cuttable report.

## Baton:
- Data Persistence: **Complete** (using Hive CE)
- Next Feature: **Billing PDF Generation** (Individual & Cuttable Slips)
- Design: Maintain the "utility-chic" aesthetic with clean typography and consistent spacing. Use `tabularFigures` for numerical alignment in reports.
