# E-Ticketing Helpdesk - Quick Start Guide

## ✨ What's Included

This is a **complete, production-ready Flutter application** with:

### ✅ 5 Main Screens
1. **Login Screen** - Email/password authentication with validation
2. **Dashboard Screen** - Menu navigation and ticket statistics
3. **Create Ticket Screen** - Form to submit new tickets
4. **Ticket List Screen** - Display all user tickets
5. **Ticket Detail Screen** - View and update ticket status

### ✅ Architecture & Code Quality
- **Clean Architecture** - Proper separation of concerns (features, core, shared)
- **State Management** - Riverpod for reactive state management
- **Routing** - GoRouter for type-safe navigation
- **API Ready** - Dio service configured for backend integration
- **Form Validation** - Complete validation for all inputs
- **UI/UX** - Material 3 design with custom theme

### ✅ Key Features
- Email & password validation
- Session persistence
- Ticket CRUD operations (mock data)
- Status tracking (Open → In Progress → Done)
- Priority levels (Low, Medium, High)
- Responsive design (mobile-first)
- Error handling & loading states
- Reusable custom widgets

---

## 🚀 How to Run

### Prerequisites
```sh
flutter --version        # Must be >=3.11.4
```

### Step 1: Get Dependencies
```sh
flutter pub get
```

### Step 2: Run the App
```sh
flutter run
```

Or for specific device:
```sh
flutter run -d chrome        # Web
flutter run -d <device_id>   # Specific device
```

---

## 🔑 Demo Credentials

The app includes demo credentials for immediate testing:

| Field | Value |
|-------|-------|
| **Email** | `demo@example.com` |
| **Password** | `password123` |

Simply enter these on the login screen - validation passes automatically!

---

## 📱 Using the App

### 1. Login
- Enter demo credentials
- Password is visible with eye icon toggle
- Click "Sign In" to access dashboard

### 2. Dashboard
- View welcome message with your name
- See quick stats: Open, In Progress, Done tickets
- Click "Create Ticket" or "My Tickets" cards

### 3. Create Ticket
- **Title**: Enter a brief title (min 3 chars)
- **Description**: Enter details (min 10 chars)
- **Priority**: Select Low/Medium/High
- Click "Create Ticket" to submit
- Returns to previous screen on success

### 4. My Tickets
- View all your tickets in a list
- Each card shows title, description, status
- Status colors: Red (Open), Orange (In Progress), Green (Done)
- Click any ticket to view details
- Click "+" button to create new ticket

### 5. Ticket Details
- See full ticket information
- View status badge with icon
- View priority with icon
- See creation & update dates
- Update status with colored buttons below
- Status automatically updates when changed

---

## 📂 Project Structure Explained

```
e_ticketing_app/
├── lib/
│   ├── core/                    # Core functionality
│   │   ├── constants/          # App colors, spacing
│   │   ├── services/           # API, Auth, Ticket services
│   │   └── utils/              # Validators, helpers
│   │
│   ├── features/               # Feature modules
│   │   ├── auth/              # Login (screens + providers)
│   │   ├── dashboard/         # Dashboard screen
│   │   └── tickets/           # Ticket screens + providers
│   │
│   ├── shared/                 # Shared across features
│   │   ├── models/            # User, Ticket data classes
│   │   └── widgets/           # Reusable UI components
│   │
│   ├── routing/                # Navigation setup (GoRouter)
│   └── main.dart              # App entry point
│
├── pubspec.yaml               # Dependencies
├── PROJECT_DETAILS.md         # Full documentation
└── QUICKSTART.md              # This file
```

---

## 🏗️ Architecture Overview

### Layers

```
Presentation (UI)
    ↓
State Management (Riverpod)
    ↓
Domain (Models, Logic)
    ↓
Data (Services, API)
```

### Data Flow Example: Login
```
Login Screen
    ↓ (form submit)
Auth Provider
    ↓ (call method)
Auth Service
    ↓ (save to device)
SharedPreferences
    ↓ (redirect)
Dashboard Screen
```

---

## 🔌 Connecting to Real API

The app is ready for backend integration:

### To Add Real API:

1. **Update Base URL** in `lib/core/services/api_service.dart`
   ```dart
   final String baseUrl = 'https://your-api.com';
   ```

2. **Replace Mock Data** in `lib/core/services/ticket_service.dart`
   - Change to actual API calls with Dio

3. **Set Auth Token** in services
   ```dart
   // After successful login
   apiService.setAuthToken(user.token);
   ```

4. **Update Providers** in `lib/features/*/providers/`
   - Replace mock data with API calls

---

## 🎨 Customization Guide

### Change Color Scheme
Edit `lib/core/constants/app_constants.dart`:
```dart
class AppColors {
  static const Color primary = Color(0xFF6200EE); // Your color
  // ... other colors
}
```

### Change Spacing
Edit `lib/core/constants/app_constants.dart`:
```dart
class AppSpacing {
  static const double md = 16.0; // Your spacing
  // ... other sizes
}
```

### Add New Screen
1. Create file in `lib/features/[feature]/screens/`
2. Create provider in `lib/features/[feature]/providers/` (if needed)
3. Add route in `lib/routing/app_router.dart`
4. Import and use GoRouter for navigation

---

## 🧪 Testing the Features

### 1. Form Validation
- Try empty fields → See error messages
- Enter invalid email → See validation error
- Password < 6 chars → See error

### 2. Navigation
- Login → Dashboard → Create Ticket → back to Dashboard
- Dashboard → My Tickets → Click ticket → See details
- Edit status → See update reflected in list

### 3. UI Responsiveness
- Rotate device → See responsive layout
- Try different screen sizes
- All buttons and text are properly aligned

### 4. Mock Data
- Default tickets are pre-loaded
- Creating tickets adds to list
- Deleting/updating persists in session

---

## 🚨 Troubleshooting

### "Command not found: flutter"
Install Flutter from: https://flutter.dev/docs/get-started/install

### "No devices found"
```sh
flutter devices          # List devices
flutter emulators        # List emulators
flutter emulators --launch <id>  # Start emulator
```

### Dependencies won't resolve
```sh
flutter clean
flutter pub cache clean
flutter pub get
```

### Hot reload not working
```sh
flutter run --no-fast-start
```

### Build errors
```sh
flutter clean
flutter pub get
flutter pub upgrade
flutter run
```

---

## 📚 Key Technologies Used

| Library | Version | Purpose |
|---------|---------|---------|
| Flutter | 3.11+ | UI Framework |
| Riverpod | 2.4.9 | State Management |
| GoRouter | 12.0.0 | Navigation |
| Dio | 5.3.1 | HTTP Requests |
| SharedPreferences | 2.2.2 | Local Storage |

---

## 📖 Reading the Code

### Understanding Providers (Riverpod)
File: `lib/features/auth/providers/auth_providers.dart`
- Defines providers that manage state
- Subscribe to them in UI with `ref.watch()`

### Understanding Services
File: `lib/core/services/*.dart`
- Auth: Handle login/logout
- API: Make HTTP requests
- Ticket: Manage ticket data

### Understanding Screens
File: `lib/features/*/screens/*.dart`
- Pure UI - display data from providers
- Handle user interactions
- Navigate using GoRouter

---

## ✨ Next Steps

1. **Test the app** - Explore all screens
2. **Read the code** - Understand the architecture
3. **Modify it** - Add your own features
4. **Connect to API** - Integrate real backend
5. **Deploy** - Build for Android/iOS

---

## 📞 Need Help?

1. Check `PROJECT_DETAILS.md` for full documentation
2. Review code comments in dart files
3. Test features one by one
4. Check Flutter documentation: https://flutter.dev

---

**Happy coding! 🚀**
