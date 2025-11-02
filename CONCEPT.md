# Gym Membership Management App - Concept Document

## 1. Executive Summary

**Gym2** is a comprehensive gym membership management mobile application designed to streamline the administration of gym members, subscriptions, and related operations. The app provides gym owners and administrators with powerful tools to track memberships, manage subscriptions, monitor expiration dates, and maintain detailed member records—all in a user-friendly, bilingual interface supporting both Arabic (RTL) and English languages.

### 1.1 App Overview
- **Platform**: Cross-platform mobile application (iOS & Android)
- **Framework**: Flutter
- **Primary Language**: Arabic with RTL support, English secondary
- **Data Storage**: Local SQLite database with backup/restore functionality
- **Target Users**: Gym owners, administrators, and staff

---

## 2. Core Features

### 2.1 Dashboard & Statistics
The main dashboard provides a comprehensive overview of gym operations:

- **Statistics Cards**:
  - Total Memberships: Total count of all registered members
  - Active Subscriptions: Members with currently valid subscriptions
  - Expired Subscriptions: Members with expired memberships
  - New Subscriptions: Subscriptions created in the last 7 days

- **Member Search**: Real-time name-based filtering of members
- **View Toggle**: Switch between List view and Grid/Card view
- **Quick Actions**: Floating action button for adding new members
- **Notifications Badge**: Visual indicator showing count of pending notifications

### 2.2 Member Management

#### Add Member
A comprehensive form for registering new gym members with the following fields:

**Required Fields**:
- Name (text input)
- Age (numeric input)
- Gender (dropdown: Male/Female)
- Phone Number (text input with validation)
- Subscription Type (selection)
- Subscription Duration (selection in days)

**Optional Fields**:
- Email Address
- Photo (capture from camera or select from gallery)

**Features**:
- Form validation for required fields
- Image compression for optimized storage
- Automatic subscription date calculation

#### Edit Member
- Update existing member information
- Modify subscription details
- Change member photo

#### Delete Member
- Remove member records with confirmation dialog
- Cascading deletion of associated subscriptions

### 2.3 Member Details Screen
Comprehensive view of individual member information:

- **Personal Information**:
  - Member photo
  - Name, age, gender
  - Contact information (phone, email)

- **Subscription Management**:
  - Current active subscriptions display
  - Historical subscription records
  - Subscription timeline visualization

- **Actions**:
  - Edit member information
  - Delete member (with confirmation)
  - Renew subscription (create new subscription)

### 2.4 Notifications System

- **Notification Center**: Dedicated screen showing all expiry-related notifications
- **Automatic Alerts**: System-generated notifications for expired subscriptions
- **Notification Features**:
  - Badge counter showing unread notifications
  - Tap to view member details
  - Mark as read functionality
  - Local notification support for background alerts

### 2.5 Settings & Customization

- **Theme Settings**:
  - Light/Dark mode toggle
  - System theme detection

- **Display Preferences**:
  - Default view mode (List/Card)
  - Sorting options:
    - Newest first
    - Oldest first
    - Alphabetical (A-Z)
    - Alphabetical (Z-A)

- **Color Scheme**: Predefined color palette selection for app theming

- **Data Management**:
  - Backup functionality: Export database to file
  - Restore functionality: Import database from backup file

---

## 3. Technical Architecture

### 3.1 Data Models

#### Member Model
```dart
{
  id: Integer (Primary Key)
  name: String (Required)
  age: Integer (Required)
  gender: String (Required - "Male"/"Female")
  phone: String (Required)
  email: String (Optional)
  photoPath: String (Optional - file path)
  subscriptions: List<Subscription>
}
```

#### Subscription Model
```dart
{
  id: Integer (Primary Key)
  memberId: Integer (Foreign Key)
  type: String (Required - subscription type)
  duration: Integer (Required - in days)
  startDate: DateTime (Required)
  endDate: DateTime (Required)
  isActive: Boolean (Required)
}
```

### 3.2 Database Schema

**Members Table**:
- Primary key: `id`
- Fields: name, age, gender, phone, email, photoPath
- Relationships: One-to-many with subscriptions

**Subscriptions Table**:
- Primary key: `id`
- Foreign key: `memberId` (references members.id)
- Fields: type, duration, startDate, endDate, isActive
- Cascade delete: Subscriptions deleted when member is deleted

### 3.3 State Management
- Provider pattern for state management across the app
- Local state management for UI-specific components

---

## 4. User Interface Design

### 4.1 Design Principles
- **Clean & Modern**: Material Design principles with custom theming
- **Bilingual Support**: Full Arabic (RTL) and English (LTR) language support
- **Responsive**: Adapts to different screen sizes
- **Intuitive Navigation**: Clear navigation flow between screens
- **Accessibility**: Proper contrast ratios and touch target sizes

### 4.2 Screen Structure

1. **Dashboard Screen**: Statistics + Member List/Grid
2. **Add Member Screen**: Multi-field form with validation
3. **Member Details Screen**: Comprehensive member view with actions
4. **Notifications Screen**: List of expiry notifications
5. **Settings Screen**: Theme, display, and data management options

### 4.3 Key UI Components
- **Stat Cards**: Display key metrics with icons
- **Member List Item**: Compact member info for list view
- **Member Card**: Rich member card for grid view
- **Search Bar**: Real-time filtering interface
- **Floating Action Button**: Quick access to add member

---

## 5. Technical Stack

### 5.1 Core Technologies
- **Flutter SDK**: Cross-platform framework
- **Dart**: Programming language (SDK >=2.19.0 <3.0.0)

### 5.2 Key Dependencies

**State Management**:
- `provider: ^6.0.5` - State management solution

**Database**:
- `sqflite: ^2.2.8+4` - SQLite database for Flutter
- `path_provider: ^2.0.15` - File system paths

**Image Handling**:
- `image_picker: ^0.8.7+5` - Camera/gallery image selection
- `flutter_image_compress: ^2.0.4` - Image compression

**Notifications**:
- `flutter_local_notifications: ^17.2.1` - Local push notifications

**UI Components**:
- `badges: ^3.1.1` - Notification badges
- `cupertino_icons: ^1.0.8` - iOS-style icons

**Localization**:
- `flutter_localizations` - Arabic RTL support
- `intl: ^0.20.2` - Internationalization and date formatting

**Preferences**:
- `shared_preferences: ^2.1.2` - App settings storage

---

## 6. User Flows

### 6.1 Adding a New Member
1. User taps FAB on Dashboard
2. Navigate to Add Member Screen
3. Fill required fields (name, age, gender, phone, subscription type/duration)
4. Optionally add photo and email
5. Submit form (validation occurs)
6. Member added to database
7. Return to Dashboard (refreshed with new member)

### 6.2 Viewing Member Details
1. User taps on member from Dashboard list/grid
2. Navigate to Member Details Screen
3. View complete member information
4. View subscription history
5. Available actions: Edit, Delete, Renew

### 6.3 Managing Expired Subscriptions
1. System checks subscription end dates
2. Generates notifications for expired subscriptions
3. Badge appears on notification icon
4. User taps notification icon
5. View notifications list
6. Tap notification to view member details
7. Option to renew subscription

### 6.4 Backup & Restore
1. Navigate to Settings
2. Select Backup option
3. Database exported to file
4. File saved to device storage
5. Restore: Select backup file
6. Database restored from backup

---

## 7. Data Validation & Security

### 7.1 Validation Rules
- **Name**: Required, non-empty string
- **Age**: Required, positive integer
- **Gender**: Required, must be from predefined options
- **Phone**: Required, valid phone number format
- **Email**: Optional, valid email format if provided
- **Subscription Type**: Required selection
- **Subscription Duration**: Required, positive integer

### 7.2 Data Security
- Local database storage (no cloud dependency)
- User-controlled backup/restore
- No external data transmission
- Photo storage optimized with compression

---

## 8. Performance Considerations

### 8.1 Optimization Strategies
- Image compression to reduce storage footprint
- Efficient database queries with proper indexing
- Lazy loading for member lists
- Caching of statistics calculations
- Debounced search functionality

### 8.2 Scalability
- Database structure supports large member bases
- Efficient filtering and searching algorithms
- Optimized list rendering for large datasets

---

## 9. Future Enhancements (Roadmap)

### 9.1 Potential Features
- **Payment Tracking**: Record and track membership payments
- **Check-in System**: QR code or manual check-in for members
- **Reports & Analytics**: 
  - Revenue reports
  - Member retention statistics
  - Attendance tracking
- **Cloud Sync**: Optional cloud backup/sync
- **Multi-location Support**: Manage multiple gym locations
- **Membership Plans**: Predefined subscription packages
- **Communication**: SMS/Email notifications to members
- **Calendar Integration**: Subscription expiry calendar view
- **Export Data**: CSV/PDF export for reporting
- **Barcode Generation**: Member ID cards with barcodes

### 9.2 Technical Improvements
- Offline-first architecture
- Enhanced search with filters (age, gender, subscription type)
- Advanced sorting options
- Bulk operations (bulk delete, bulk renewal)
- Data import from CSV/Excel

---

## 10. Use Cases

### 10.1 Gym Owner
- Daily overview of gym operations
- Track active vs expired memberships
- Identify members needing renewal
- Quick access to member information

### 10.2 Gym Administrator
- Register new members efficiently
- Update member information
- Manage subscription renewals
- Generate backup files for data safety

### 10.3 Staff Member
- Search for member information quickly
- View member subscription status
- Access member contact details

---

## 11. Success Metrics

### 11.1 Key Performance Indicators
- Number of active subscriptions
- Member retention rate
- Time saved on administrative tasks
- Accuracy of subscription tracking
- User satisfaction with interface

### 11.2 Goals
- Reduce manual paperwork
- Eliminate subscription tracking errors
- Improve member management efficiency
- Provide instant access to member information
- Streamline renewal process

---

## 12. Conclusion

The Gym Membership Management App (Gym2) provides a comprehensive solution for gym owners and administrators to efficiently manage members, track subscriptions, and maintain organized membership records. With its bilingual support, intuitive interface, and robust local data management, the app serves as a reliable tool for day-to-day gym operations while maintaining data security and user control.

The app's architecture supports future enhancements and scalability, making it a solid foundation for evolving gym management needs.

---

**Document Version**: 1.0  
**Last Updated**: 2024  
**Maintained By**: Development Team
