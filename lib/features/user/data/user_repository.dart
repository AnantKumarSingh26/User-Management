import 'package:user_management/core/database_helper.dart';

class UserRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> addUser(Map<String, dynamic> user) async {
    return await _dbHelper.insertUser(user);
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    return await _dbHelper.getUsers();
  }

  Future<int> updateUser(int id, Map<String, dynamic> user) async {
    return await _dbHelper.updateUser(id, user);
  }

  Future<int> deleteUser(int id) async {
    return await _dbHelper.deleteUser(id);
  }
}
