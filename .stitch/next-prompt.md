---
page: notification_center
---
A Notification Center screen for the Kurie app. This screen displays alerts for both Admins and Tenants.

**Page Structure:**
1. Header: Title \"Notifications\" with a \"Mark all as read\" action.
2. Tab switcher: \"All\" and \"Urgent\".
3. Notification List:
   - Items use the `card-data` style but with more vertical density.
   - Each item includes:
     - Icon (e.g., `receipt_long` for bills, `speed` for readings, `warning` for alerts).
     - Title (e.g., \"New Bill Available\", \"Reading Due Tomorrow\").
     - Description (e.g., \"Your bill for October has been finalized.\").
     - Time stamp (e.g., \"2h ago\").
     - Unread indicator (Neon Blue dot).
4. Empty State:
   - Illustration (utility-chic style) and text \"You're all caught up!\".

**Design:**
- High-contrast minimalism.
- Use `tertiary-amber` for urgent alerts.
- Smooth slide-to-dismiss animations (implied for Flutter).
- Follow the 8px grid and 4px rounding rules.
