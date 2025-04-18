import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:user_management/features/user/data/user_repository.dart';

final userProvider = StateNotifierProvider<UserNotifier, List<Map<String, dynamic>>>((ref) {
  return UserNotifier(UserRepository());
});

class UserNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  final UserRepository _repository;

  UserNotifier(this._repository) : super([]) {
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    state = await _repository.getUsers();
  }

  Future<void> addUser(Map<String, dynamic> user) async {
    await _repository.addUser(user);
    _loadUsers();
  }

  Future<void> updateUser(int id, Map<String, dynamic> user) async {
    await _repository.updateUser(id, user);
    _loadUsers();
  }

  Future<void> deleteUser(int id) async {
    await _repository.deleteUser(id);
    _loadUsers();
  }
}
