# YAPA – Yet Another Paperless-ngx App

A mobile client for [Paperless-ngx](https://docs.paperless-ngx.com/) built with Flutter.  
YAPA lets you browse, search, filter, upload, and edit your documents directly from your Android device.

---

## Features

### Login & Security
- Connects to any self-hosted Paperless-ngx instance via HTTPS (HTTP is rejected)
- Two login modes: **username + password** (fetches an API token automatically) or **direct API token** entry
- All credentials are stored securely using the Android Keystore (`flutter_secure_storage`)
- Optional support for self-signed TLS certificates (scoped to the configured hostname)

### Document List
- Paginated document list with infinite scroll
- Full-text search across all documents
- Active filter chips show the current filter state at a glance and can be removed individually
- SavedViews selector for quick access to server-side saved views (chips bar or dropdown — configurable)
- Additional filters can be applied on top of a selected SavedView
- Tapping a tag on any document card instantly adds it as a filter; tapping it again removes it

### Filter & Sorting
The filter sheet allows combining multiple criteria:
- **Tags** — select one or more tags (chips or multi-select dropdown — configurable); tag chips are coloured to match the colours configured in Paperless-ngx, with a stronger fill to indicate selection
- **Correspondent** — filter by a single correspondent
- **Document type** — filter by document type
- **Custom fields** — add one or more custom field conditions per filter:
  - *Field is present* — document has a value for this field
  - *Field is empty* — document has no value for this field
  - *Value equals* — exact match (type-appropriate input: dropdown for select fields, number keyboard for integer/decimal fields, yes/no for boolean fields)
  - Multiple custom field conditions are AND-combined
- **Sorting** — created date (newest/oldest), modified date, title (A–Z / Z–A), added date

### Document Detail
- Displays all document metadata: title, created date, correspondent, document type, storage path, tags, custom fields
- Inline PDF preview powered by Syncfusion PDF Viewer
- Download document to the device
- Navigate directly to edit or delete the document

### Document Editing
- Edit title, created date, correspondent, document type, storage path
- Add or remove tags via colour-coded chips or multi-select dropdown (configurable)
- Edit existing custom field values; remove individual fields from the document
- Supported custom field types: text, integer, decimal (float/monetary), boolean (switch), date (date picker), select (dropdown), URL

### Document Upload
- Pick a file from device storage (PDF, PNG, JPG, JPEG, TIFF, GIF, WEBP)
- Take a photo directly with the camera
- Set title, correspondent, document type, storage path, and tags before uploading (tags as colour-coded chips or multi-select dropdown — configurable)
- File name is pre-filled as the document title

### Notifications
- Shows pending Paperless-ngx task notifications (file import tasks)
- Displays only unacknowledged tasks
- Tasks can be acknowledged directly from the app

### Settings
- Displays server URL and logged-in username
- Set a default SavedView that is automatically applied on startup
- Language selector (overrides system language)
- **Display options:**
  - Tags as multi-select dropdown instead of chips (applies to filter, edit, and upload)
  - SavedViews as dropdown instead of chip bar
- App version display
- Logout

---

## Supported Languages

| Language   | Code |
|------------|------|
| Deutsch    | `de` |
| English    | `en` |
| Español    | `es` |
| Français   | `fr` |
| Italiano   | `it` |
| Polski     | `pl` |
| Português  | `pt` |
| Čeština    | `cs` |

The app follows the system language by default. A specific language can be pinned in the Settings screen.

---

## Requirements

- Android device (API level 21+)
- A running [Paperless-ngx](https://github.com/paperless-ngx/paperless-ngx) instance reachable over HTTPS

---

## Tech Stack

| Area | Library |
|---|---|
| Framework | Flutter / Dart |
| State management | Provider |
| HTTP client | Dio |
| Secure storage | flutter_secure_storage (AndroidKeyStore) |
| PDF viewer | Syncfusion Flutter PDF Viewer |
| Image caching | cached_network_image |
| File picker | file_picker |
| Camera | image_picker |
| Localisation | flutter_localizations + gen_l10n (ARB files) |

---

## Building

```bash
# Debug
flutter run

# Release APK
flutter build apk --release
```

A signed release build requires `android/key.properties` pointing to your keystore.

---

## Project Structure

```
lib/
├── l10n/               # ARB localisation files + generated Dart classes
├── models/             # Data models (Document, Tag, Correspondent, …)
├── providers/          # State management (DocumentsProvider, AuthProvider, …)
├── screens/            # UI screens
├── services/           # API service, secure storage service
└── widgets/            # Reusable widgets (DocumentCard, TagChip)
```
