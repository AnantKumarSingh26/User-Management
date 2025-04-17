import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user.dart';
import '../providers/user_provider.dart';
import 'package:uuid/uuid.dart';

class UserForm extends ConsumerStatefulWidget {
  const UserForm({super.key});

  @override
  ConsumerState<UserForm> createState() => _UserFormState();
}

class _UserFormState extends ConsumerState<UserForm> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add User'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Name')),
          TextField(controller: _ageController, decoration: const InputDecoration(labelText: 'Age'), keyboardType: TextInputType.number),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            final user = User(
              id: const Uuid().v4(),
              name: _nameController.text,
              email: 'example@example.com', // Temporary placeholder for email
              age: int.tryParse(_ageController.text) ?? 0,
            );
            ref.read(usersProvider.notifier).addUser(user);
            Navigator.pop(context);
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}
