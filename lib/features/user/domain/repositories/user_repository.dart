import '../entities/user.dart';

abstract class UserRepository {
  Future<void> addUser(User user);
  Future<void> updateUser(User user);
  Future<void> deleteUser(String id);
  Future<List<User>> getUsers();
  Future<User?> getUserById(String id);
}
