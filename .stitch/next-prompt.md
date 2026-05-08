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

**Design:**
- No new UI screens for this iteration, but ensure the UI reacts to empty states and loading states correctly using the established utility-chic aesthetic.
