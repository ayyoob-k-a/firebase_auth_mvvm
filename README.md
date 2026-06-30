# FIRE AUTH (Test App)

A production-ready Flutter application demonstrating a complete, secure authentication and user onboarding flow using Firebase Authentication and Cloud Firestore.

## 🌟 Features

* **Secure Authentication**: Full email/password sign-up and sign-in flows using `firebase_auth`.
* **Enforced Onboarding**: Intelligent navigation ensures new users are forced to complete their profile in Firestore before accessing the app.
* **Real-time Synchronization**: The Home Dashboard leverages a real-time stream from `cloud_firestore` to instantly reflect backend changes without manual refreshes.
* **Premium UI/UX**: 
  * Typewriter animation on Splash Screen.
  * Custom dynamic styling using Google Fonts (`DM Serif Display` and `Outfit`).
  * Reusable, highly polished components (e.g., custom dropdowns, animated gender selection radios).
* **Logout Confirmation**: Safe sign-out flow with an elegant confirmation dialog.

## 🏗 Architecture

This project strictly adheres to **Clean Architecture** principles combined with the **MVVM (Model-View-ViewModel)** design pattern. State management is handled entirely by the **BLoC** (Business Logic Component) pattern.

### Layer Separation
1. **Domain Layer (Core Business Logic)**
   * **Entities**: Pure Dart objects (`UserEntity`, `UserProfileEntity`) with zero Flutter/Firebase dependencies.
   * **Repositories Contract**: Abstract interfaces defining the data operations.
   * **Use Cases**: Single-responsibility classes (`SignInUseCase`, `SaveProfileUseCase`, etc.) encapsulating specific business rules.

2. **Data Layer (External Communication)**
   * **Models**: Extensions of domain entities handling serialization/deserialization (`UserProfileModel` parsing Firestore documents).
   * **Remote Data Sources**: Centralized Firebase SDK integrations (`AuthRemoteDataSource`, `ProfileRemoteDataSource`).
   * **Repository Implementations**: Concrete classes fulfilling the Domain contracts, orchestrating data sources, and handling exception-to-failure conversions.

3. **Presentation Layer (UI & ViewModels)**
   * **Views (Pages)**: Dumb UI widgets reflecting the current state.
   * **ViewModels (BLoCs)**: Manages UI state, reacts to user events, and communicates with Use Cases.

## 📁 Folder Structure

```text
lib/
├── core/
│   ├── constants/        # Centralized lists (e.g., app_lists.dart)
│   ├── errors/           # Exceptions and Failures
│   ├── theme/            # AppColors and global themes
│   └── utils/            # AppResult (Success/Failure wrappers)
├── data/
│   ├── datasources/      # Firebase Auth & Firestore implementations
│   ├── models/           # Data models (toFirestore/fromFirestore)
│   └── repositories/     # Repository implementations
├── domain/
│   ├── entities/         # Pure Dart entities
│   ├── repositories/     # Abstract repository contracts
│   └── usecases/         # Business logic use cases
├── features/             # Presentation layer organized by feature
│   ├── complete_profile/ # Onboarding form (BLoC + UI)
│   ├── home/             # Real-time dashboard (Cubit + UI)
│   ├── login/            # Sign in flow (BLoC + UI)
│   ├── signup/           # Registration flow (BLoC + UI)
│   └── splash/           # Entry & Auth-check routing (BLoC + UI)
├── shared/               # Reusable UI components
│   └── widgets/          # AppTextField, PrimaryButton, Dropdowns, etc.
└── main.dart             # Application entry point
```

## 🛠 Tech Stack

* **Framework:** [Flutter](https://flutter.dev/)
* **State Management:** [flutter_bloc](https://pub.dev/packages/flutter_bloc)
* **Backend:** [Firebase Authentication](https://firebase.google.com/docs/auth), [Cloud Firestore](https://firebase.google.com/docs/firestore)
* **Utilities:** [equatable](https://pub.dev/packages/equatable) (for value equality), [google_fonts](https://pub.dev/packages/google_fonts)

## 🚀 Getting Started

### Prerequisites
* Flutter SDK (v3.12.2 or higher)
* A Firebase Project with **Authentication** (Email/Password) and **Firestore Database** enabled.

### Setup Instructions

1. **Clone the repository.**
2. **Install dependencies:**
   ```bash
   flutter pub get
   ```
3. **Configure Firebase:**
   Ensure your `firebase_options.dart` is correctly set up for your project using the FlutterFire CLI:
   ```bash
   flutterfire configure
   ```
4. **Update Firestore Security Rules:**
   To allow users to create and read their own profiles, deploy the following rules in your Firebase Console:
   ```javascript
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /users/{userId} {
         allow read, write: if request.auth != null && request.auth.uid == userId;
       }
     }
   }
   ```
5. **Run the App:**
   ```bash
   flutter run
   ```

---
*Developed with a focus on clean, scalable architecture and premium user experience.*
