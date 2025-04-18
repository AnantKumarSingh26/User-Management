import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_provider.dart';
import '../widgets/user_form.dart';
import '../widgets/update_user_form.dart';
import '../../domain/entities/user.dart';

class UserScreen extends ConsumerStatefulWidget {
  const UserScreen({super.key});

  @override
  ConsumerState<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends ConsumerState<UserScreen> {
  final TextEditingController _searchController = TextEditingController();
  User? _searchedUser;

  @override
  Widget build(BuildContext context) {
    final users = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('User Management')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search User by ID',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () async {
                    final userId = int.tryParse(_searchController.text);
                    if (userId != null) {
                      final user = await ref.read(userProvider.notifier).getUserById(userId);
                      setState(() {
                        _searchedUser = user;
                      });
                    } else {
                      setState(() {
                        _searchedUser = null;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Invalid User ID')),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
          if (_searchedUser != null)
            Card(
              margin: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(_searchedUser!.name),
                subtitle: Text('Age: ${_searchedUser!.age}'),
              ),
            )
          else if (_searchController.text.isNotEmpty)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('No user found with the given ID.'),
            ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await ref.read(userProvider.notifier).loadUsers();
              },
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (_, index) {
                  final user = users[index];
                  return ListTile(
                    title: Text(user.name),
                    subtitle: Text('Age: ${user.age}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => showDialog(
                            context: context,
                            builder: (_) => UpdateUserForm(user: user),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            await ref.read(userProvider.notifier).deleteUser(user.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('User deleted successfully')),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (_) => const UserForm(),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
