import 'package:user_management/features/user/domain/entities/user.dart';
import 'package:user_management/features/user/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final List<User> _users = [];

  @override
  Future<void> addUser(User user) async {
    _users.add(user);
  }

  @override
  Future<void> updateUser(User user) async {
    final index = _users.indexWhere((u) => u.id == user.id);
    if (index != -1) {
      _users[index] = user;
    }
  }

  @override
  Future<void> deleteUser(String id) async {
    _users.removeWhere((user) => user.id == id);
  }

  @override
  Future<List<User>> getUsers() async {
    return _users;
  }

  @override
  Future<User?> getUserById(String id) async {
    return _users.firstWhere((user) => user.id == id, orElse: () => User(id: '', name: '', email: '', age: 0));
  }
}
