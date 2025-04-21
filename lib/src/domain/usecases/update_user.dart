import '../entities/user.dart';
import '../repositories/user_repository.dart';

class UpdateUserUseCase {
  final UserRepository repository;

  UpdateUserUseCase(this.repository);

  Future<void> call(User user) async {
     if (user.id == null) {
       throw ArgumentError('User ID must not be null for update');
     }
     if (user.name.isEmpty || user.email.isEmpty || !user.email.contains('@')) {
       throw ArgumentError('Invalid user data');
    }
    await repository.updateUser(user);
  }
}