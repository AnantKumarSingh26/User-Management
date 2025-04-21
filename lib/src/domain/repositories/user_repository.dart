import '../entities/user.dart';

abstract class UserRepository {
  Future<void> createUser(User user);
  Future<User?> getUser(int id); // Optional if only list is needed
  Future<List<User>> getAllUsers();
  Future<void> updateUser(User user);
  Future<void> deleteUser(int id);
}