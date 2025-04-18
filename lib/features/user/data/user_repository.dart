import 'package:user_management/core/database_helper.dart';
import '../../domain/entities/user.dart';

class UserRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> addUser(User user) async {
    return await _dbHelper.insertUser({
      'id': user.id,
      'name': user.name,
      'email': user.email,
      'age': user.age,
    });
  }

  Future<List<User>> getUsers() async {
    final userMaps = await _dbHelper.getUsers();
    return userMaps.map((map) => User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      age: map['age'],
    )).toList();
  }

  Future<void> updateUser(User updatedUser) async {
    await _dbHelper.updateUser(updatedUser.id, {
      'name': updatedUser.name,
      'email': updatedUser.email,
      'age': updatedUser.age,
    });
  }

  Future<void> deleteUser(int id) async {
    await _dbHelper.deleteUser(id);
  }
}
