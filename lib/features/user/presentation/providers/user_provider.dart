import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user.dart';
import '../../data/user_repository.dart';

final userProvider = StateNotifierProvider<UserNotifier, List<User>>((ref) {
  return UserNotifier(UserRepository());
});

class UserNotifier extends StateNotifier<List<User>> {
  final UserRepository _repository;

  UserNotifier(this._repository) : super([]);

  Future<void> loadUsers() async {
    state = await _repository.getUsers();
  }

  Future<User?> getUserById(int id) async {
    return state.firstWhere((user) => user.id == id, orElse: () => null);
  }

  Future<void> updateUser(User updatedUser) async {
    await _repository.updateUser(updatedUser);
    state = state.map((user) => user.id == updatedUser.id ? updatedUser : user).toList();
  }

  Future<void> deleteUser(int id) async {
    await _repository.deleteUser(id);
    state = state.where((user) => user.id != id).toList();
  }
}
