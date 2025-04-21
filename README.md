# 👤 User Management App

A Flutter-based user management application that allows users to perform CRUD (Create, Read, Update, Delete) operations on a list of users. The app uses **Riverpod** for state management and **Sqflite** for local database storage.

---

## ✨ Features

- Add new users with name and email  
- View a list of all users  
- Search users by name or email  
- Edit user details  
- Delete users  
- Local database storage using **Sqflite**  
- State management using **Riverpod**

---

## 🧱 Project Structure

The project follows **Clean Architecture**, separating the code into three core layers:

### 📦 1. Data Layer
Responsible for data retrieval and persistence.

- **Datasources**
  - `database_helper.dart`: Manages SQLite database operations.
- **Models**
  - `user_model.dart`: Defines the data model used for storage.
- **Repositories**
  - `user_repository_impl.dart`: Implements the data access logic based on the abstract repository.

### 🧠 2. Domain Layer
Contains the core business logic and abstracts dependencies.

- **Entities**
  - `user.dart`: Defines the core user entity used throughout the app.
- **Repositories**
  - `user_repository.dart`: Abstract class defining data access methods.
- **Use Cases**
  - `add_user.dart`: Logic for adding a user  
  - `get_all_users.dart`: Logic for retrieving all users  
  - `get_user.dart`: Logic for retrieving a user by ID  
  - `update_user.dart`: Logic for updating a user  
  - `delete_user.dart`: Logic for deleting a user  

### 🎨 3. Presentation Layer
Handles UI and user interaction.

- **Providers**
  - `user_providers.dart`: Manages app state using Riverpod.
- **Screens**
  - `user_list_screen.dart`: Displays the list of users with search functionality  
  - `add_edit_user_screen.dart`: UI to add or edit a user  

---

## 🏛️ Folder Structure (`lib/`)

```
lib/
│   main.dart                         # App entry point
│
└───src/
    ├───data/
    │   ├───datasources/
    │   │   └───local/
    │   │       └───database_helper.dart
    │   ├───models/
    │   │   └───user_model.dart
    │   └───repositories/
    │       └───user_repository_impl.dart
    │
    ├───domain/
    │   ├───entities/
    │   │   └───user.dart
    │   ├───repositories/
    │   │   └───user_repository.dart
    │   └───usecases/
    │       ├───add_user.dart
    │       ├───delete_user.dart
    │       ├───get_all_users.dart
    │       ├───get_user.dart
    │       └───update_user.dart
    │
    └───presentation/
        ├───providers/
        │   └───user_providers.dart
        └───screens/
            ├───add_edit_user_screen.dart
            └───user_list_screen.dart
```

---

## 🛠️ Installation

### Prerequisites

- Flutter SDK installed  
- Android Studio or VS Code  
- A physical device or emulator  

### Setup Instructions

```bash
# Clone the repository
git clone https://github.com/AnantKumarSingh26/User-Management.git
cd user-management-app

# Get dependencies
flutter pub get

# Run the app
flutter run
```

---



## 👨‍💻 Author

**Anant Kumar Singh**  
GitHub: https://github.com/AnantKumarSingh26  
Email: anantsingh.code@gmail.com

---

