import '../entities/user.dart';
import '../repositories/user_repository.dart';

class GetAllUsers {
  final UserRepository repository;

  GetAllUsers(this.repository);

  Future<List<User>> call() => repository.getUsers();
}
