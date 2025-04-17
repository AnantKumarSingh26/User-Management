import '../entities/user.dart';
import '../repositories/user_repository.dart';

class CreateUser {
  final UserRepository repository;

  CreateUser(this.repository);

  Future<void> call(User user) => repository.addUser(user);
}
