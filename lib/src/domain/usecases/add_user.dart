import '../entities/user.dart';
import '../repositories/user_repository.dart';

class AddUserUseCase {
  final UserRepository repository;

  AddUserUseCase(this.repository);

  Future<void> call(User user) async {
    // Basic validation (could be more complex)
    if (user.name.isEmpty || user.email.isEmpty || !user.email.contains('@')) {
       throw ArgumentError('Invalid user data');
    }
    // Add more business logic here if needed
    await repository.createUser(user);
  }
}