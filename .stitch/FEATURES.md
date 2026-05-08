0. Onboarding & Feature Tour
Feature Highlights: A carousel of high-fidelity screens presented to new users, highlighting:
- Offline-First Tracking: Monitor usage even without internet.
- Transparent Billing: Detailed breakdowns of how every peso is calculated.
- Evidence-Based Trust: Photo attachments of actual meter readings.
- Real-time Alerts: Get notified as soon as a bill is finalized.

1. Authentication & State Management
Role-Based Access Control (RBAC):

Admin: Full read/write access to the master meter, billing configurations, and tenant submeters.

Sub-user: Read-only access to their specific submeter billing data, current bill status, and historical ledger. No write access for meter readings.

Offline-First Auth Caching: Users log in while online to acquire a secure token (e.g., JWT). The token and local profile state are cached securely on the device, allowing the user to open the app and bypass the login screen when in an offline zone.

2. The Offline-First Sync Engine
Local Ledger Database: All CRUD operations (creating a reading, setting a rate) write to a local device database first. The UI updates optimistically, ensuring zero latency.

Background Sync Queue: A service worker monitors network status. When an internet connection is detected, the app batches local changes and pushes them to the cloud REST/GraphQL API.

Conflict Resolution: Since the Admin is the sole source of truth for readings, conflict resolution focus on syncing offline Admin entries with the cloud, ensuring timestamps are preserved and any duplicate entries from multiple Admin devices are merged based on the latest valid reading.

3. Meter & Property Management
Household Setup (Admin): Ability to create a "Property," define the Master Meter, and generate unique invite codes for Sub-users to join the property.

Submeter Provisioning (Admin): Add distinct submeters, assign them a name (e.g., "Basement Apartment," "Garage Workshop"), and link them to a specific Sub-user account.

Ledger History: A paginated, scrollable history log of all past readings and finalized billing cycles, accessible offline.

4. Smart Data Entry (Admin Only)
Validated Manual Entry: An input form for the current kWh reading of any submeter. The UI validates the input locally, blocking any number lower than the previous reading.

Timestamping: The app automatically captures the exact date and time the reading was logged.

Photo Evidence Attachment: An optional feature allowing the Admin to snap a photo of the physical meter dial/screen. The image is compressed, cached locally, and uploaded during the next sync to serve as a trust artifact for tenants.

5. Guided Billing Configuration Engine (Options)
Simple Pro-Rata Module: Admin inputs Total Bill (₱) and Master Meter Usage (kWh). App calculates exact fractional share per submeter.

Base Fee Splitter: Admin adds a flat monthly fee (e.g., connection charge, garbage fee bundled in utility) and selects whether to split it equally among all users or assign it solely to the master owner.

Tiered Rate Builder: A modular UI component where the Admin can add usage brackets (e.g., "Tier 1: ₱10 up to 100 kWh", "Tier 2: ₱12 for 101+ kWh").

Configuration JSON Generator: The frontend compiles these UI selections into a standardized JSON configuration object, saving the math logic locally so the app can calculate bills without hitting the cloud.

6. Text-Driven Insights Dashboard
The Bottom Line (Current Bill): A prominent text block displaying the user's exact financial share for the active billing cycle.

Sub-user View: "Your current bill is ₱1,250.00."

Admin View: "Total Sub-user contributions: ₱3,400.00. Your remaining master balance is ₱1,100.00."

The Transparency Breakdown: A dynamic, plain-English summary of the billing math to eliminate disputes.

Example: "Your bill includes a ₱150 split base fee, plus 50 kWh calculated at the current master rate of ₱11.50/kWh."

Behavioral Trend Alerts: Simple text strings comparing current usage to historical data.

Example: "You have used 15% more electricity this week compared to last week. Expect a higher final bill."

7. Notification & Workflow System
Billing Finalization Trigger: When the Admin finalizes the monthly bill, a payload is sent to the cloud.

Cycle Alerts: Sub-users receive an online push notification stating the master bill has been processed and their exact payment is due.

Dispute/Flagging System: If a Sub-user notices an anomaly in their bill, they can tap a "Query Calculation" button, which sends a direct alert to the Admin highlighting the specific reading or rate in question.