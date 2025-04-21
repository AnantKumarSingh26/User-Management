import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/local/database_helper.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/usecases/add_user.dart';
import '../../domain/usecases/delete_user.dart';
import '../../domain/usecases/get_all_users.dart';
import '../../domain/usecases/update_user.dart';

// --- Data Layer Providers ---

// Provider for the DatabaseHelper instance
final databaseHelperProvider = Provider<DatabaseHelper>((ref) {
  return DatabaseHelper.instance;
});

// Provider for the UserRepository implementation
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final dbHelper = ref.watch(databaseHelperProvider);
  return UserRepositoryImpl(dbHelper);
});

// --- Domain Layer (Use Case) Providers ---

final addUserUseCaseProvider = Provider<AddUserUseCase>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return AddUserUseCase(repository);
});

final getAllUsersUseCaseProvider = Provider<GetAllUsersUseCase>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return GetAllUsersUseCase(repository);
});

final updateUserUseCaseProvider = Provider<UpdateUserUseCase>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return UpdateUserUseCase(repository);
});

final deleteUserUseCaseProvider = Provider<DeleteUserUseCase>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return DeleteUserUseCase(repository);
});

// --- Presentation Layer (State Notifier) Provider ---

// Provider for the search query
final searchQueryProvider = StateProvider<String>((ref) => '');

// Provider for the filtered user list
final filteredUserListProvider = Provider<AsyncValue<List<User>>>((ref) {
  final searchQuery = ref.watch(searchQueryProvider).toLowerCase();
  final userList = ref.watch(userListProvider);

  return userList.whenData((users) {
    if (searchQuery.isEmpty) {
      return users;
    }
    return users.where((user) {
      return user.name.toLowerCase().contains(searchQuery) ||
          user.email.toLowerCase().contains(searchQuery);
    }).toList();
  });
});

// StateNotifier for managing the list of users
class UserListNotifier extends StateNotifier<AsyncValue<List<User>>> {
  final GetAllUsersUseCase _getAllUsersUseCase;
  final AddUserUseCase _addUserUseCase;
  final UpdateUserUseCase _updateUserUseCase;
  final DeleteUserUseCase _deleteUserUseCase;

  UserListNotifier(
    this._getAllUsersUseCase,
    this._addUserUseCase,
    this._updateUserUseCase,
    this._deleteUserUseCase,
  ) : super(const AsyncValue.loading()) {
    // Load initial users when the notifier is created
    loadUsers();
  }

  // Method to load/refresh users
  Future<void> loadUsers() async {
    state = const AsyncValue.loading();
    try {
      final users = await _getAllUsersUseCase();
      state = AsyncValue.data(users);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      print("Error loading users: $e \n $stackTrace");
    }
  }

  // Method to add a user
  Future<bool> addUser(User user) async {
    state = const AsyncValue.loading(); // Indicate loading while adding
    try {
      await _addUserUseCase(user);
      await loadUsers(); // Refresh the list
      return true; // Indicate success
    } catch (e, stackTrace) {
      print("Error adding user: $e");
      // Keep the old data or show error state
      // Revert to previous state on error if possible, or reload
      await loadUsers(); // Attempt to reload to show current state
      state = AsyncValue.error(e, stackTrace); // Optionally show error in UI
      return false; // Indicate failure
    }
  }

  // Method to update a user
  Future<bool> updateUser(User user) async {
    state = const AsyncValue.loading();
    try {
      await _updateUserUseCase(user);
      await loadUsers(); // Refresh
      return true;
    } catch (e, stackTrace) {
      print("Error updating user: $e");
      await loadUsers(); // Attempt to reload
      state = AsyncValue.error(e, stackTrace);
      return false;
    }
  }

  // Method to delete a user
  Future<void> deleteUser(int id) async {
    state = const AsyncValue.loading();
    try {
      await _deleteUserUseCase(id);
      await loadUsers(); // Refresh
    } catch (e, stackTrace) {
      print("Error deleting user: $e");
      await loadUsers(); // Attempt to reload
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

// The StateNotifierProvider for the UserListNotifier
final userListProvider =
    StateNotifierProvider<UserListNotifier, AsyncValue<List<User>>>((ref) {
      final getAllUsers = ref.watch(getAllUsersUseCaseProvider);
      final addUser = ref.watch(addUserUseCaseProvider);
      final updateUser = ref.watch(updateUserUseCaseProvider);
      final deleteUser = ref.watch(deleteUserUseCaseProvider);
      return UserListNotifier(getAllUsers, addUser, updateUser, deleteUser);
    });
