---
page: property_management
---
A Property Management screen for the Kurie app. This screen allows Admins to view all active submeters, add new ones, and edit existing tenant assignments.

**Page Structure:**
1. Header with property name (Eastwood Residences) and "Add Submeter" primary button.
2. Search/Filter bar for submeter names or tenant names.
3. List of Submeters:
   - Each item shows submeter name (e.g., "Unit 4B"), assigned tenant, and "Last Reading" date.
   - Status tag (Active/Inactive).
   - "Manage" button for each item.
4. "Add Submeter" Modal/Form fields:
   - Submeter Name
   - Initial Reading (kWh)
   - Tenant Assignment (Dropdown)
   - Property Location details

**Design:**
- Use `card-data` style for submeter items.
- Status tags use `primary-fixed` (Active) or `outline-variant` (Inactive).
- Form inputs follow `input-field` system tokens.
- Follow the high-contrast, utility-chic aesthetic.
