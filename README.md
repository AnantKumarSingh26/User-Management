# User-Management
# Flutter User Management App

A simple Flutter application for managing users, built with clean architecture principles and in-memory data storage. This app demonstrates basic CRUD (Create, Read, Update, Delete) operations using `Riverpod` for state management and the `Repository` pattern for code structure.

## 🧱 Features

- Add, edit, and delete users
- View list of users in a structured UI
- Form validation
- Clean architecture (presentation, domain, data layers)
- State management using Riverpod
- Data stored in memory (no Firebase or external backend)

## 🛠️ Architecture

The project follows a clean architecture with three core layers:

- **Presentation Layer**: UI components and widgets.
- **Domain Layer**: Business logic, entities, and repository interfaces.
- **Data Layer**: In-memory data source and repository implementation.

## 📂 Project Structure

```bash
lib/
├── core/
├── features/
│   └── user/
│       ├── data/          
│       ├── domain/          
│       ├── presentation/    
│           ├── screens/
│           ├── widgets/
│           └── providers/
└── main.dart
```

