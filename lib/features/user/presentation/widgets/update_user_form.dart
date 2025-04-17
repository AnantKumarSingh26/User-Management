import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user.dart';
import '../providers/user_provider.dart';

class UpdateUserForm extends ConsumerStatefulWidget {
  final User user;

  const UpdateUserForm({required this.user, super.key});

  @override
  ConsumerState<UpdateUserForm> createState() => _UpdateUserFormState();
}

class _UpdateUserFormState extends ConsumerState<UpdateUserForm> {
  late TextEditingController _nameController;
  late TextEditingController _ageController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _ageController = TextEditingController(text: widget.user.age.toString());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Update User'),
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
            final updatedUser = User(
              id: widget.user.id,
              name: _nameController.text,
              email: widget.user.email, // Keep the email unchanged
              age: int.tryParse(_ageController.text) ?? widget.user.age,
            );
            ref.read(usersProvider.notifier).updateUser(updatedUser);
            Navigator.pop(context);
          },
          child: const Text('Update'),
        ),
      ],
    );
  }
}