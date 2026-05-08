---
name: Kurie App Theme
colors:
  surface: '#f2fbfc'
  surface-dim: '#d3dcdd'
  surface-bright: '#f2fbfc'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#edf5f6'
  surface-container: '#e7eff0'
  surface-container-high: '#e1eaeb'
  surface-container-highest: '#dce4e5'
  on-surface: '#151d1e'
  on-surface-variant: '#3b494c'
  inverse-surface: '#2a3233'
  inverse-on-surface: '#eaf2f3'
  outline: '#6b7a7d'
  outline-variant: '#bac9cc'
  surface-tint: '#006875'
  primary: '#006875'
  on-primary: '#ffffff'
  primary-container: '#00e5ff'
  on-primary-container: '#00626e'
  inverse-primary: '#00daf3'
  secondary: '#545f73'
  on-secondary: '#ffffff'
  secondary-container: '#d5e0f8'
  on-secondary-container: '#586377'
  tertiary: '#7d5700'
  on-tertiary: '#ffffff'
  tertiary-container: '#ffc865'
  on-tertiary-container: '#765300'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#9cf0ff'
  primary-fixed-dim: '#00daf3'
  on-primary-fixed: '#001f24'
  on-primary-fixed-variant: '#004f58'
  secondary-fixed: '#d8e3fa'
  secondary-fixed-dim: '#bcc7de'
  on-secondary-fixed: '#111c2d'
  on-secondary-fixed-variant: '#3c475a'
  tertiary-fixed: '#ffdea9'
  tertiary-fixed-dim: '#ffba2a'
  on-tertiary-fixed: '#271900'
  on-tertiary-fixed-variant: '#5f4100'
  background: '#f2fbfc'
  on-background: '#151d1e'
  surface-variant: '#dce4e5'
typography:
  display-data:
    fontFamily: Inter
    fontSize: 48px
    fontWeight: '700'
    lineHeight: 56px
    letterSpacing: -0.02em
  display-currency:
    fontFamily: Inter
    fontSize: 40px
    fontWeight: '600'
    lineHeight: 48px
    letterSpacing: -0.02em
    fontFeatureSettings: '"tnum" on'
  headline-lg:
    fontFamily: Inter
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.01em
  headline-md:
    fontFamily: Inter
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
  body-lg:
    fontFamily: Inter
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 28px
  body-md:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  label-bold:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '700'
    lineHeight: 20px
  label-sm:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
rounded:
  sm: 0.125rem
  DEFAULT: 0.25rem
  md: 0.375rem
  lg: 0.5rem
  xl: 0.75rem
  full: 9999px
spacing:
  base: 8px
  xs: 4px
  sm: 12px
  md: 24px
  lg: 40px
  margin-mobile: 20px
  gutter: 16px
components:
  button-primary:
    backgroundColor: "{colors.primary}"
    textColor: "{colors.on-primary}"
    typography: "{typography.label-bold}"
    rounded: "{rounded.DEFAULT}"
    height: 48px
    padding: 0 24px
  button-alert:
    backgroundColor: "{colors.error}"
    textColor: "{colors.on-error}"
    typography: "{typography.label-bold}"
    rounded: "{rounded.DEFAULT}"
    height: 48px
    padding: 0 24px
  card-data:
    backgroundColor: "{colors.surface-container-lowest}"
    borderColor: "{colors.outline-variant}"
    borderWidth: 1px
    rounded: "{rounded.sm}"
    padding: "{spacing.md}"
  input-field:
    backgroundColor: "{colors.surface-container-lowest}"
    borderColor: "{colors.outline-variant}"
    borderWidth: 1px
    textColor: "{colors.on-surface}"
    typography: "{typography.body-md}"
    rounded: "{rounded.sm}"
    height: 48px
    padding: 0 16px
  insight-text:
    textColor: "{colors.on-surface}"
    typography: "{typography.body-lg}"
  insight-text-alert:
    textColor: "{colors.tertiary}"
    typography: "{typography.body-md}"
  configuration-group:
    backgroundColor: "{colors.surface-container-high}"
    borderColor: "{colors.outline-variant}"
    borderWidth: 1px
    rounded: "{rounded.md}"
    padding: "{spacing.sm}"
  status-indicator-sync:
    backgroundColor: "{colors.primary-fixed}"
    rounded: "{rounded.full}"
    width: 8px
    height: 8px
  photo-attachment-zone:
    backgroundColor: "{colors.surface-container}"
    borderColor: "{colors.outline-variant}"
    borderWidth: 1px
    borderStyle: dashed
    rounded: "{rounded.md}"
    padding: "{spacing.md}"
  onboarding-dot:
    backgroundColor: "{colors.outline-variant}"
    activeColor: "{colors.primary}"
    rounded: "{rounded.full}"
    width: 8px
    height: 8px
  onboarding-image-container:
    backgroundColor: "{colors.surface-container-low}"
    rounded: "{rounded.lg}"
    aspectRatio: "1/1"
---

## Brand & Style

This design system is engineered for precision and clarity, catering to users who value data-driven insights into their energy consumption. The "utility-chic" aesthetic merges the raw efficiency of an industrial control panel with the refined elegance of modern premium software.

The style is defined by **High-Contrast Minimalism**. It eschews decorative flourishes in favor of functional density, utilizing "ink-trap" inspired typography and vibrant technical accents to guide the eye toward critical metrics. In this light-mode execution, the interface feels like a professional laboratory instrument—clean, authoritative, and surgically precise.

## Colors

The palette is anchored by a **Technical White Background**, providing a clean, high-clarity environment that mimics professional documentation and medical-grade interfaces.

- **Primary Neon Blue:** Reserved for the most critical actions, active states, and positive data trends. On a light background, it acts as a sharp, high-visibility signal for "power" and "flow."
- **Tertiary Amber:** An energetic, high-visibility yellow-orange used for critical warnings, alert states, and high-priority status indicators to provide immediate visual contrast.
- **Deep Carbon Neutral:** Used for primary data and headings to ensure maximum legibility against the light surface.
- **Subtle Slate/Gray Accents:** These define the skeletal structure of the UI, used for borders and secondary metadata to maintain a clear visual hierarchy.

## Typography

The design system utilizes **Inter** for its neutral, systematic character. The typographic scale prioritizes data visualization:

- **Data-First:** The `display-data` style is the hero of the screen, used for real-time kilowatt readings.
- **Financial Precision:** The `display-currency` style ensures monetary values are slightly smaller than the data hero, with tabular numbers (`tnum`) active to align vertically in ledgers.
- **Insights & Narratives:** The `body-lg` style is used for "The Bottom Line" and plain-English billing transparency text to make it conversational and accessible.
- **Weights:** Heavy use of Bold (700) and Semi-Bold (600) for headings and metrics to create an "at-a-glance" information architecture.
- **Labels:** Small labels use uppercase and slightly increased letter spacing to mimic technical blueprints and utility meters.

## Layout & Spacing

This design system employs a **8px grid system** to maintain mathematical rigor. 

- **Grid Model:** A fluid grid with fixed 20px outer margins. 
- **Touch Targets:** All interactive elements (buttons, toggles, list items) maintain a minimum height of 48px to ensure ease of use while moving.
- **Visual Rhythm:** Generous vertical padding (`lg`) is used between major data sections to prevent the interface from feeling cluttered, despite the high density of information.

## Elevation & Depth

To maintain a "utility" feel, the system avoids traditional soft shadows. Instead, depth is communicated through **Tonal Layering** and **Low-Contrast Outlines**:

1.  **Level 0 (Base):** Clean Technical White (#f7fafb) for the main canvas.
2.  **Level 1 (Surface):** Elevated containers for cards and modules, defined by a 1px solid slate border rather than a shadow.
3.  **Level 2 (Active/Overlay):** Glassmorphism is used sparingly for bottom sheets or modals, using a subtle backdrop blur and light tint to maintain context of the data underneath.

## Shapes

The shape language is "Soft-Industrial." Elements use a **0.25rem (4px) base radius** to appear modern but disciplined.

- **Standard Containers:** Use `rounded-sm` for a sharp, technical look.
- **Interactive Elements:** Buttons and input fields follow the same subtle rounding. 
- **Data Visuals:** Bar charts and progress indicators use flat ends (0px) or minimal rounding to emphasize the "meter" aesthetic.

## Components

### Buttons & Actions
Primary buttons are high-impact: Background in **Neon Blue**, Text in **White Bold**. They should appear crisp and energetic. High-priority alerts and dispute actions (like the **Query Calculation** button) utilize the **Error** or **Tertiary Amber** palette for specialized action buttons.

### Data & Insight Cards
Cards are the primary vessel for information. They feature a 1px border and house a combination of a `label-bold` header and `display-data` metrics. 
- **Text-Driven Insights:** Cards dedicated to the "Transparency Breakdown" omit large numbers in favor of structured `body-lg` text highlighting exact financial shares.
- **Behavioral Trend Alerts:** For warnings like "Expect a higher final bill," the system uses standard text blocks rendered in the `tertiary` color (Amber) via the `insight-text-alert` token to command attention without needing heavy banners.

### Onboarding Carousel
The first-time user experience utilizes a high-clarity carousel. Each slide features an `onboarding-image-container` for feature illustrations and a `headline-lg` title. Progress is tracked via `onboarding-dot` indicators at the bottom.

### Smart Data Entry & Media (Admin)
- **Inputs:** Used exclusively by the Admin for meter reading submissions. They feature a light fill with a Deep Carbon cursor and 1px active border in Neon Blue.
- **Photo Evidence Attachment:** An Admin-only utility marked by a dashed outline (`outline-variant`) for capturing "Evidence-Based Trust" artifacts.

### Visualizations & Sync
- **Sparklines:** Neon Blue paths with a subtle light-blue gradient fill. Warning sparklines use **Tertiary Amber**.
- **Active Indicators:** A small pulsing Neon Blue dot signals real-time connectivity or active tracking. When offline, this changes to a muted slate color. 
- **Guided Configuration Modules:** Complex configurations like the "Tiered Rate Builder" and "Base Fee Splitter" utilize the `configuration-group` token. These are nested containers with a slightly darker surface (`surface-container-high`) to visually group related form fields and toggles, creating structure within the main card.

### Utility Navigation
A fixed bottom navigation bar with a heavy blur effect. Icons are stroke-based (2px weight) to match the technical precision of the typography, rendered in Deep Carbon.