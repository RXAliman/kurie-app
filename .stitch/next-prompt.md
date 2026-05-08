---
page: settings_profile
---
A Settings & Profile screen for the Kurie app. This screen allows users to view their profile information, manage notification preferences, and configure app settings.

**Page Structure:**
1. Profile header with avatar, name, email, and role badge (Admin/Tenant)
2. Property section showing the current property name and invite code
3. Settings groups:
   - Notifications toggle (billing alerts, reading reminders)
   - Appearance (light/dark mode — future)
   - Data & Sync section (last sync time, force sync button, clear cache)
4. Account actions (Sign out, Delete account)
5. App version footer

**Design:**
- Use `surface-container-high` for grouped setting containers
- Use `configuration-group` token for nested settings
- Role badge uses `primary` for Admin, `secondary` for Tenant
- Destructive actions use `error` palette
- Follow 8px grid and 20px outer margins
