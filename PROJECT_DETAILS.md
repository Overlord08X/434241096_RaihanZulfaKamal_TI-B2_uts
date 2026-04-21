# E-Ticketing Helpdesk Flutter App

A professional, production-ready Flutter application built with clean architecture following Material 3 design guidelines. This app demonstrates best practices in Flutter development including state management, routing, form validation, and responsive UI design.

## 🎯 Features

### Authentication
- ✅ Email and password login with validation
- ✅ Demo credentials built-in for testing
- ✅ Session persistence using SharedPreferences
- ✅ Automatic redirect to login on session expiration

### Dashboard
- ✅ Welcome message with user name
- ✅ Quick action cards for navigation
- ✅ Ticket statistics display
- ✅ Logout functionality

### Ticket Management
- ✅ **Create Ticket**: Submit tickets with title, description, and priority level
- ✅ **View Tickets**: List of all user tickets with status indicators
- ✅ **Ticket Details**: Full ticket information with update capabilities
- ✅ **Status Updates**: Change ticket status (Open → In Progress → Done)
- ✅ **Priority Levels**: Low, Medium, High with color coding

### UI/UX
- ✅ Material 3 design system
- ✅ Custom themed colors and spacing
- ✅ Reusable widget components
- ✅ Responsive design (mobile-first)
- ✅ Status and priority badges with icons
- ✅ Loading and error states
- ✅ Form validation with helpful messages

## 🏗️ Project Structure

```
lib/
├── core/
│   ├── constants/
│   │   └── app_constants.dart       # Colors, spacing, radius constants
│   ├── services/
│   │   ├── api_service.dart         # Dio HTTP client configuration
│   │   ├── auth_service.dart        # Authentication logic
│   │   └── ticket_service.dart      # Ticket operations (mock data)
│   └── utils/
│       └── utils.dart               # Helper functions and validators
├── features/
│   ├── auth/
│   │   ├── screens/
│   │   │   └── login_screen.dart
│   │   └── providers/
│   │       └── auth_providers.dart  # Riverpod auth state
│   ├── dashboard/
│   │   └── screens/
│   │       └── dashboard_screen.dart
│   └── tickets/
│       ├── screens/
│       │   ├── create_ticket_screen.dart
│       │   ├── ticket_list_screen.dart
│       │   └── ticket_detail_screen.dart
│       └── providers/
│           └── ticket_providers.dart # Riverpod ticket state
├── shared/
│   ├── models/
│   │   ├── user_model.dart          # User data model
│   │   └── ticket_model.dart        # Ticket data model
│   └── widgets/
│       └── custom_widgets.dart      # Reusable UI components
├── routing/
│   └── app_router.dart              # GoRouter configuration
└── main.dart                        # App entry point
```

## 🛠️ Technology Stack

| Technology | Version | Purpose |
|-----------|---------|---------|
| Flutter | >=3.11.4 | UI Framework |
| Dart | Latest | Programming Language |
| Riverpod | ^2.4.9 | State Management |
| GoRouter | ^12.0.0 | Navigation & Routing |
| Dio | ^5.3.1 | HTTP Client |
| SharedPreferences | ^2.2.2 | Local Storage |

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.11.4)
- Dart (included with Flutter)
- Android Studio / Xcode (for emulators)

### Installation

1. **Clone the repository**
   ```bash
   cd e_ticketing_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Demo Credentials
- **Email**: `demo@example.com`
- **Password**: `password123`

## 📱 Screens Overview

### 1. Login Screen
- Email and password input fields
- Form validation
- Demo credentials display
- Eye icon to toggle password visibility
- Navigation to dashboard on successful login

### 2. Dashboard Screen
- User welcome message
- Quick action cards (Create Ticket, My Tickets)
- Ticket statistics (Open, In Progress, Done)
- Logout button

### 3. Create Ticket Screen
- Title input field (min 3 characters)
- Description text area (min 10 characters)
- Priority dropdown (Low/Medium/High)
- Priority preview card
- Submit and cancel buttons
- Form validation

### 4. Ticket List Screen
- List of user tickets
- Ticket cards with status badges
- Color-coded status indicators
- Click to view details
- Add new ticket button
- Empty state handling

### 5. Ticket Detail Screen
- Ticket ID and title
- Status and priority information
- Created and updated dates
- Full description
- Status update buttons
- Responsive layout

## 🎨 Design System

### Colors
- **Primary**: `#6200EE` (Purple)
- **Secondary**: `#03DAC6` (Teal)
- **Status Open**: `#FF6B6B` (Red)
- **Status In Progress**: `#FFA500` (Orange)
- **Status Done**: `#51CF66` (Green)
- **Priority Low**: `#4CAF50` (Green)
- **Priority Medium**: `#FFC107` (Yellow)
- **Priority High**: `#FF5252` (Red)

### Spacing System
- xs: 4px
- sm: 8px
- md: 16px
- lg: 24px
- xl: 32px
- xxl: 48px

### Border Radius
- sm: 8px
- md: 12px
- lg: 16px
- xl: 24px
- full: 50px

## 🔄 State Management (Riverpod)

### Providers Used:
```dart
// Service Providers
final sharedPreferencesProvider      // SharedPreferences instance
final authServiceProvider            // Auth service
final apiServiceProvider             // API service
final ticketServiceProvider          // Ticket service

// Auth State
final currentUserProvider            // Current logged-in user
final isLoggedInProvider             // Authentication status

// Ticket State
final userTicketsProvider            // User's tickets list
final ticketDetailProvider           // Single ticket details
final createTicketProvider           // Create new ticket
```

## 🧭 Routing

Routes are managed via GoRouter with automatic authentication redirect:

```
/login              → Login Screen
/dashboard          → Dashboard Screen
/tickets            → Ticket List Screen
/create-ticket      → Create Ticket Screen
/ticket/:ticketId   → Ticket Detail Screen
```

## ✅ Form Validation

### Email Validation
- Required
- Valid email format

### Password Validation
- Required
- Minimum 6 characters

### Ticket Title Validation
- Required
- Minimum 3 characters

### Ticket Description Validation
- Required
- Minimum 10 characters

## 📝 Mock Data

The app includes mock data for immediate testing:
- Pre-populated user tickets
- Mock ticket service with CRUD operations
- Simulated API delays for realistic UX

## 🔌 API Integration

The `ApiService` is ready for backend integration:
- Configurable base URL
- Request/response interceptors
- Error handling
- Token-based authentication support

To integrate real API:
1. Update `baseUrl` in `ApiService`
2. Implement actual API calls in services
3. Replace mock data with API responses

## 🧪 Testing

### Test the App:
1. Open login screen - verify Material 3 design
2. Enter demo credentials and click login
3. See dashboard with statistics and menu
4. Create a ticket with all validations
5. View ticket list with status colors
6. Click ticket to view details
7. Update ticket status and see changes
8. Logout and verify redirect to login

## 🚧 Future Enhancements

- [ ] Real API integration instead of mock data
- [ ] JWT authentication
- [ ] User profile management
- [ ] Ticket filtering and search
- [ ] Image upload for tickets
- [ ] Comments and activity log
- [ ] Push notifications
- [ ] Offline synchronization
- [ ] Admin dashboard
- [ ] Advanced analytics

## 📚 Code Quality

- ✅ Null safety enabled
- ✅ Clean architecture principles
- ✅ Separation of concerns
- ✅ Reusable components
- ✅ Proper error handling
- ✅ Form validation
- ✅ Loading states
- ✅ Material 3 design system

## 🐛 Troubleshooting

### Dependencies not resolving?
```bash
flutter pub get
flutter pub upgrade
```

### App won't run?
```bash
flutter clean
flutter pub get
flutter run
```

### Build issues?
```bash
flutter clean
flutter pub cache clean
flutter pub get
flutter run
```

## 📄 License

This project is provided as an educational example.

## 👨‍💻 Architecture Notes

### Clean Architecture Layers:
1. **Presentation Layer** (screens, widgets)
2. **State Management Layer** (Riverpod providers)
3. **Domain Layer** (models, business logic)
4. **Data Layer** (services, API integration)

### Design Patterns Used:
- MVC (Model-View-Controller)
- Provider Pattern (Riverpod)
- Singleton Pattern (Services)
- Repository Pattern (Services)
- Builder Pattern (Custom widgets)

## 🤝 Contributing

This is a complete example project. Feel free to fork and extend it!

## 📞 Support

For issues or questions, review the code structure and comments throughout the project.

---

**Built with ❤️ using Flutter and Dart**
