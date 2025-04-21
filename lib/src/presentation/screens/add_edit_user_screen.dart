import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user.dart';
import '../providers/user_providers.dart';

class AddEditUserScreen extends ConsumerStatefulWidget {
  final User? user; // Null if adding, non-null if editing

  const AddEditUserScreen({super.key, this.user});

  @override
  ConsumerState<AddEditUserScreen> createState() => _AddEditUserScreenState();
}

class _AddEditUserScreenState extends ConsumerState<AddEditUserScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user?.name ?? '');
    _emailController = TextEditingController(text: widget.user?.email ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _saveUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final name = _nameController.text;
      final email = _emailController.text;
      bool success = false;
      String errorMessage = '';


      try {
         if (widget.user == null) {
          // Add new user
          final newUser = User(name: name, email: email);
          success = await ref.read(userListProvider.notifier).addUser(newUser);
        } else {
          // Update existing user
          final updatedUser = widget.user!.copyWith(name: name, email: email);
          success = await ref.read(userListProvider.notifier).updateUser(updatedUser);
        }

        if (success && mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text('User ${widget.user == null ? 'added' : 'updated'} successfully!')),
           );
           Navigator.of(context).pop(); // Go back to list screen
        }
        // Error handling is implicitly done via the provider's state or catch block below
        // If success is false, an error likely occurred and was handled/logged in the notifier


      } catch (e) {
          errorMessage = e.toString();
          print("Error saving user: $e");
      } finally {
         if (mounted) {
             setState(() => _isLoading = false);
             if (!success && errorMessage.isNotEmpty) {
                  // Show specific error from catch block if needed
                  ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(content: Text('Error: $errorMessage'), backgroundColor: Colors.red),
                  );
             } else if (!success) {
                  // Generic error if no specific message caught but operation failed
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to ${widget.user == null ? 'add' : 'update'} user. Please try again.'), backgroundColor: Colors.red),
                 );
             }
         }
      }


    }
  }

  @override
  Widget build(BuildContext context) {
    // Check for errors propagated via the provider state (e.g., unique constraint)
    ref.listen<AsyncValue<List<User>>>(userListProvider, (_, state) {
       state.whenOrNull(
         error: (error, stackTrace) {
           // Only show error if it occurred during *this* screen's operation (tricky to determine perfectly)
           // A more robust way might involve a separate provider for add/edit state/errors.
           // For simplicity, we mostly rely on the try-catch in _saveUser
           if (_isLoading) { // If error happened while we were saving
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $error'), backgroundColor: Colors.red),
              );
              // Potentially reset loading state here if not done in _saveUser finally block
              // if (mounted) setState(() => _isLoading = false);
           }
         },
       );
    });


    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user == null ? 'Add User' : 'Edit User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  if (!value.contains('@') || !value.contains('.')) {
                      return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _saveUser,
                      child: Text(widget.user == null ? 'Add User' : 'Update User'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}