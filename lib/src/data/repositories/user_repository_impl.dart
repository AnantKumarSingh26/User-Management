import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/local/database_helper.dart';

class UserRepositoryImpl implements UserRepository {
  final DatabaseHelper databaseHelper;

  UserRepositoryImpl(this.databaseHelper);

  @override
  Future<void> createUser(User user) async {
    try {
      await databaseHelper.insert(user.toMap());
    } catch (e) {
      // Log error or re-throw specific domain exception
      print("UserRepositoryImpl: Error creating user - $e");
      rethrow; // Re-throw to be caught by use case or presentation layer
    }
  }

   @override
  Future<User?> getUser(int id) async {
    final map = await databaseHelper.queryUser(id);
    if (map != null) {
      return User.fromMap(map);
    }
    return null;
  }


  @override
  Future<List<User>> getAllUsers() async {
     try {
        final maps = await databaseHelper.queryAllUsers();
        return maps.map((map) => User.fromMap(map)).toList();
     } catch (e) {
         print("UserRepositoryImpl: Error getting all users - $e");
         // Return empty list or throw an exception based on requirements
         return [];
     }
  }

  @override
  Future<void> updateUser(User user) async {
    try {
       final count = await databaseHelper.update(user.toMap());
       if (count == 0) {
           // Optional: Throw an error if the user to update wasn't found
           throw Exception('User with ID ${user.id} not found for update.');
       }
    } catch (e) {
         print("UserRepositoryImpl: Error updating user - $e");
         rethrow;
    }
  }

  @override
  Future<void> deleteUser(int id) async {
    try {
       final count = await databaseHelper.delete(id);
       if (count == 0) {
           // Optional: Throw an error if the user to delete wasn't found
           print('UserRepositoryImpl: User with ID $id not found for deletion.');
           // Depending on requirements, you might not want to throw here
       }
    } catch (e) {
         print("UserRepositoryImpl: Error deleting user - $e");
         rethrow;
    }
  }
}