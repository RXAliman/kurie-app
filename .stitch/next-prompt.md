---
page: dispute_resolution
---
A Dispute Resolution / Query screen for the Kurie app. This screen allows Tenants to flag issues with their bills and Admins to resolve them.

**Page Structure:**
1. Header: Title \"Query Calculation\" or \"Dispute Resolution\".
2. Context Card:
   - Summary of the disputed bill (Month, Amount, kWh).
   - Status tag (e.g., \"Pending Review\", \"Resolved\").
3. Message Thread:
   - A minimalist chat/log interface.
   - Tenant's initial query (e.g., \"My usage seems too high for this month.\").
   - Admin's response field.
4. Action Bar (Admin only):
   - \"Adjust Reading\" (re-opens the reading logger with current values).
   - \"Mark as Resolved\".
5. Metadata:
   - Linked submeter and tenant name.

**Design:**
- Use `tertiary-amber` for the pending status and alert icons.
- Follow the \"utility-chic\" aesthetic—crisp, high-contrast, no shadows.
- 8px grid, 4px rounding.
