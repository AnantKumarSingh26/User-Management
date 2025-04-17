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
    final users = ref.watch(usersProvider);

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
                    final user = await ref.read(usersProvider.notifier).repo.getUserById(_searchController.text);
                    setState(() {
                      _searchedUser = user;
                    });
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
            ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                ref.read(usersProvider.notifier).loadUsers();
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
                          onPressed: () => ref.read(usersProvider.notifier).deleteUser(user.id),
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
