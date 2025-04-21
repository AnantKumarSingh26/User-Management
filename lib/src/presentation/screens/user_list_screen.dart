import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user.dart';
import 'add_edit_user_screen.dart';
import '../providers/user_providers.dart';

class UserListScreen extends ConsumerWidget { // Changed to ConsumerWidget
  const UserListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the *filtered* user list provider now
    final filteredListAsyncValue = ref.watch(filteredUserListProvider);
    // Get the search query state notifier for updating the query
    final searchQueryNotifier = ref.read(searchQueryProvider.notifier);
    // Get the current search query to set the text field's initial value (less crucial)
    final currentSearchQuery = ref.watch(searchQueryProvider);

    // Controller for the search TextField
    final searchController = TextEditingController(text: currentSearchQuery);
     // Ensure cursor stays at the end when text is programmatically set
    searchController.selection = TextSelection.fromPosition(
        TextPosition(offset: searchController.text.length));


    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Clear search when refreshing
              searchQueryNotifier.state = '';
              // Invalidate the main provider to trigger reload
              ref.invalidate(userListProvider);
            },
          ),
        ],
        // Add the search bar to the bottom of the AppBar
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight), // Standard toolbar height
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search by name or email...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: currentSearchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          searchController.clear(); // Clear TextField
                          searchQueryNotifier.state = ''; // Clear search state
                        },
                      )
                    : null, // No clear button if field is empty
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none, // Hide default border
                ),
                filled: true, // Need true for fillColor to apply
                fillColor: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3), // Background color
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20), // Adjust padding
              ),
              onChanged: (value) {
                // Update the search query state when the text changes
                searchQueryNotifier.state = value;
              },
            ),
          ),
        ),
      ),
      // Use the filtered list value here
      body: filteredListAsyncValue.when(
        data: (users) {
            // Determine if the original list was empty or if the *filter* resulted in empty
            final originalListState = ref.watch(userListProvider);
            bool wasInitiallyEmpty = originalListState.maybeWhen(
              data: (originalUsers) => originalUsers.isEmpty,
              orElse: () => false, // Assume not empty if loading/error
            );
            bool filterIsEmpty = users.isEmpty && currentSearchQuery.isNotEmpty;

            if (wasInitiallyEmpty) {
             return const Center(child: Text('No users found. Add one!'));
            } else if (filterIsEmpty) {
              return Center(child: Text('No users found matching "$currentSearchQuery"'));
            } else if (users.isEmpty && currentSearchQuery.isEmpty && !wasInitiallyEmpty) {
              // This case might happen briefly during refresh or state transitions
              // Or if all users were deleted. The wasInitiallyEmpty check helps.
              return const Center(child: Text('No users found. Add one!'));
            }
            else {
              // Display the filtered list
              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return ListTile(
                    title: Text(user.name),
                    subtitle: Text(user.email),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AddEditUserScreen(user: user),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _confirmDelete(context, ref, user),
                        ),
                      ],
                    ),
                     onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AddEditUserScreen(user: user),
                            ),
                          );
                        },
                  );
                },
              );
            }
        },
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error loading users: $error'),
              ElevatedButton(
                // Refresh the main list on retry
                onPressed: () => ref.invalidate(userListProvider),
                child: const Text('Retry'),
              )
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddEditUserScreen(),
            ),
          );
        },
      ),
    );
  }

  // _confirmDelete method remains the same
  Future<void> _confirmDelete(BuildContext context, WidgetRef ref, User user) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        // ... (AlertDialog code remains the same)
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: Text('Are you sure you want to delete ${user.name}?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
               style: TextButton.styleFrom(foregroundColor: Colors.red),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm == true && user.id != null) {
       ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Deleting ${user.name}...')),
       );
      // Use the main userListProvider notifier to delete
      await ref.read(userListProvider.notifier).deleteUser(user.id!);
      // No need to manually clear search here, the list update will trigger filter recalculation
    }
  }
}