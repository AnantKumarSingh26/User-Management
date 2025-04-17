import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/user_repository_impl.dart';
import '../../domain/entities/user.dart';

final userRepositoryProvider = Provider((ref) => UserRepositoryImpl());

final usersProvider = StateNotifierProvider<UserNotifier, List<User>>((ref) {
  final repo = ref.watch(userRepositoryProvider);
  return UserNotifier(repo);
});

class UserNotifier extends StateNotifier<List<User>> {
  final UserRepositoryImpl repo;

  UserNotifier(this.repo) : super([]) {
    loadUsers();
  }

  Future<void> loadUsers() async {
    state = await repo.getUsers();
  }

  Future<void> addUser(User user) async {
    await repo.addUser(user);
    await loadUsers();
  }

  Future<void> updateUser(User user) async {
    await repo.updateUser(user);
    await loadUsers();
  }

  Future<void> deleteUser(String id) async {
    await repo.deleteUser(id);
    await loadUsers();
  }
}
