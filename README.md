

**X Ten** is a Flutter mobile application designed to connect **influencers, advertisers, brands, clients, and freelancers** through a modern Arabic-first marketplace.

The application focuses on influencer discovery, promotional campaigns, collaboration opportunities, campaign management, and professional communication between content creators and advertisers.

> **Main idea:** make it easier for brands and advertisers to discover suitable influencers, review their profiles and statistics, and create structured promotional campaigns.

---

## ✨ Main Features

### 🔐 Authentication
- Login and sign-up screens
- Arabic RTL interface
- Form validation
- Password visibility controls
- Loading states
- Social login UI
- Forgot-password flow ready for backend integration

### 🏠 Dashboard
- Modern dark interface
- Gold accent theme
- Responsive RTL layout
- Interactive dashboard cards
- Notifications
- Messages
- Profile access
- Quick navigation to platform services

### 👥 Influencer Discovery
- View a complete list of influencers
- Search influencers by name, category, or city
- View influencer availability
- View influencer ratings
- View follower statistics across:
  - Facebook
  - Instagram
  - TikTok
  - YouTube
- Open detailed influencer profiles

### 🗂️ Influencers by Category
Users can browse influencers by professional area, such as:

- Art
- Cooking
- Sports
- Technology
- E-commerce
- Beauty
- Fashion
- Travel
- Tourism

Available sorting options include:

- Newest members
- Highest rated
- Most followed

### 👤 Influencer Profile Details
Each influencer profile can contain:

- Profile photo
- Name
- Category
- City
- Rating
- Join date
- Biography
- Platform ambassador status
- Follower statistics
- Profile views
- Interested advertisers
- Featured work
- Advertising availability

### 📢 Campaign Creation
Advertisers can create campaigns associated with an influencer.

Campaign information can include:

- Campaign title
- Description
- Social platform
- Content type
- Budget
- Start date
- End date
- Influencer selection

### 📈 On-Demand Promotion
The **ترويج حسب الطلب** feature allows users to submit custom promotional requests.

Users can:

- Describe their marketing requirement
- Specify campaign objectives
- Enter a budget
- Add attachments
- Submit the request for review

### 📋 My Promotion Requests
Users can track their submitted promotional requests.

Supported statuses:

- Pending
- Under review
- Accepted
- Rejected

### 🤝 Contracts & Agreements
The app structure includes support for:

- Active agreements
- Legal agreements
- Authorization and securing flows
- Pending confirmations
- Publishing approval
- Notification approval

### 💬 Communication
- Conversations
- Notifications
- Contact flow
- Creator profile access

### 💳 Account & Financial Information
- Financial information screen
- Saved items
- Account-related services

---

## 🎨 UI / UX

X Ten uses a professional Arabic-first design system.

### Theme

| Element | Value |
|---|---|
| Background | `#0A0A0A` |
| Gold Accent | `#E5C158` |
| Main Surface | `#151515` / `#1B1B1B` |
| Primary Text | White |
| Secondary Text | White with reduced opacity |

### Design Principles

- RTL-first layout
- Responsive Flutter widgets
- `Expanded` and `Flexible` to avoid overflow
- Rounded cards
- Subtle gradients
- Gold accent borders
- InkWell ripple effects
- Press animations
- Loading indicators
- Responsive Arabic text wrapping
- Mobile-first user experience

---

## 🧱 Suggested Project Structure

```text
lib/
├── features/
│   ├── auth/
│   │   └── presentation/
│   │       └── pages/
│   │           ├── login_screen.dart
│   │           └── signup_screen.dart
│   │
│   ├── dashboard/
│   │   └── presentation/
│   │       └── pages/
│   │           └── home_menu_screen.dart
│   │
│   ├── influencers/
│   │   ├── data/
│   │   │   └── influencers_demo_data.dart
│   │   ├── domain/
│   │   │   └── models/
│   │   │       ├── influencer.dart
│   │   │       └── influencer_category.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       │   ├── influencers_list_screen.dart
│   │       │   ├── influencer_categories_screen.dart
│   │       │   ├── category_influencers_screen.dart
│   │       │   └── influencer_details_screen.dart
│   │       └── widgets/
│   │           ├── influencer_card.dart
│   │           └── category_card.dart
│   │
│   ├── campaigns/
│   │   └── presentation/
│   │       └── pages/
│   │           └── campaign_creation_screen.dart
│   │
│   ├── work_management/
│   │   ├── domain/
│   │   │   └── models/
│   │   │       └── promotion_request.dart
│   │   ├── data/
│   │   │   └── promotion_requests_demo_data.dart
│   │   └── presentation/
│   │       └── pages/
│   │           ├── on_demand_promotion_screen.dart
│   │           └── my_promotion_requests_screen.dart
│   │
│   ├── contracts_agreements/
│   └── settings_security/
│
└── main.dart
```

---

## 🔄 Main User Flow

```text
Login / Sign Up
      ↓
Dashboard
      ↓
Influencer Discovery
      ↓
Influencer Details
      ↓
Create Advertising Campaign
      ↓
Submit
      ↓
Campaign / Promotion Management
```

Category-based discovery:

```text
Dashboard
      ↓
Influencers by Category
      ↓
Choose Category
      ↓
Search / Filter / Sort
      ↓
Influencer Details
      ↓
Start Advertising
```

On-demand promotion:

```text
Dashboard
      ↓
On-Demand Promotion
      ↓
Describe Request
      ↓
Add Attachments
      ↓
Set Budget
      ↓
Submit Request
      ↓
My Promotion Requests
```

---

## 🛠️ Tech Stack

- **Flutter**
- **Dart**
- **Material Design**
- **Font Awesome Flutter**
- **File Picker**
- RTL Arabic support

Planned or optional backend technologies:

- Firebase
- Supabase
- REST API
- Node.js
- PostgreSQL
- Laravel / PHP backend

---

## 📦 Dependencies

Example dependencies:

```yaml
dependencies:
  flutter:
    sdk: flutter

  cupertino_icons: ^1.0.8
  font_awesome_flutter: ^10.8.0
  file_picker: ^8.1.2
```

Run:

```bash
flutter pub get
```

---

## 🚀 Getting Started

### 1. Clone the project

```bash
git clone <your-repository-url>
```

### 2. Open the project folder

```bash
cd x_ten
```

### 3. Install dependencies

```bash
flutter pub get
```

### 4. Check your Flutter environment

```bash
flutter doctor
```

### 5. Run the application

```bash
flutter run
```

---

## 🖥️ Recommended Environment

The project can be developed with:

- Flutter SDK
- Dart SDK
- Android Studio
- Visual Studio Code
- Android Emulator or physical Android device
- JDK 21 or a Flutter-compatible JDK

---

## 🌍 RTL & Arabic Support

The application uses Arabic RTL layouts.

Typical screen configuration:

```dart
Directionality(
  textDirection: TextDirection.rtl,
  child: Scaffold(
    // ...
  ),
)
```

For reusable components, prefer:

```dart
EdgeInsetsDirectional
AlignmentDirectional
PositionedDirectional
```

instead of hard-coded `left` and `right` values.

---

## 🔐 Authentication Integration

The current UI can be connected to:

- Firebase Authentication
- Supabase Auth
- Custom REST API

Recommended architecture:

```text
UI
 ↓
Controller / Provider / Bloc
 ↓
Repository
 ↓
API / Firebase / Supabase
```

Avoid placing network requests directly inside UI widgets for the final production version.

---

## 🗃️ Data Model Overview

### Influencer

```text
Influencer
├── id
├── name
├── category
├── categoryId
├── imageUrl
├── city
├── rating
├── joinDate
├── bio
├── availability
├── follower statistics
├── profile views
├── interested advertisers
└── featured work
```

### Promotion Request

```text
PromotionRequest
├── id
├── title
├── description
├── budget
├── createdAt
├── status
└── attachmentsCount
```

### Campaign

```text
Campaign
├── title
├── description
├── influencer
├── platform
├── contentType
├── budget
├── startDate
├── endDate
└── status
```

---

## 🧪 Current Development Status

The application is currently under active development.

### Implemented / In Progress

- [x] Login UI
- [x] Sign-up navigation
- [x] Main dashboard
- [x] Responsive dashboard menu cards
- [x] Influencer list concept
- [x] Influencer categories
- [x] Category filtering
- [x] Influencer details
- [x] On-demand promotion form
- [x] Promotion request tracking UI
- [x] Campaign creation UI
- [x] Contracts and workflow screen integration
- [ ] Real backend authentication
- [ ] Database integration
- [ ] Real influencer data
- [ ] File upload backend
- [ ] Campaign persistence
- [ ] Push notifications
- [ ] Real-time messaging
- [ ] Payments
- [ ] Admin dashboard
- [ ] Production analytics

---

## 🔮 Planned Improvements

Future versions may include:

- Real-time chat between influencers and advertisers
- Campaign negotiation
- Influencer verification
- Brand verification
- Reviews and ratings
- Recommendation engine
- Advanced category filtering
- Location-based influencer search
- Campaign analytics
- Audience demographics
- Engagement-rate statistics
- Contracts and digital signatures
- Invoice management
- Payment integration
- Push notifications
- Saved influencers
- Campaign history
- Admin moderation tools
- AI-assisted influencer matching

---

## 📱 Platforms

Target platforms:

- Android
- iOS

Possible future support:

- Web
- Desktop

---

## 📚 Flutter Resources

If you are new to Flutter:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)
- [Flutter documentation](https://docs.flutter.dev/)

---

## 🤝 Contribution

This project is currently under development.

Recommended contribution workflow:

```bash
git checkout -b feature/your-feature
git add .
git commit -m "Add your feature"
git push origin feature/your-feature
```

Then create a pull request.

---

## ⚠️ Development Note

Demo influencer profiles, follower numbers, images, campaign requests, and other sample information used during development should be treated as placeholder data.

Before production release:

- connect screens to a real backend;
- replace demo data with database records;
- secure authentication tokens;
- validate requests server-side;
- secure uploaded files;
- add privacy and data-protection policies;
- configure production API environments.

---

## 📄 License

A license has not yet been defined for this project.

Add a `LICENSE` file before distributing the application publicly.

---

## X Ten

**Connecting influence with opportunity.**

> منصة تربط المؤثرين بالمعلنين والعلامات التجارية بطريقة احترافية، سهلة وآمنة.
"""
