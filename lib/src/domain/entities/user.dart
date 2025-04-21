import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int? id; // Nullable for creation before DB assigns ID
  final String name;
  final String email;

  const User({
    this.id,
    required this.name,
    required this.email,
  });

  // Helper factory for creating User from Map (e.g., from DB)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int?, // Cast might be needed depending on DB return type
      name: map['name'] as String,
      email: map['email'] as String,
    );
  }

  // Helper method to convert User to Map (e.g., for DB insertion/update)
  Map<String, dynamic> toMap() {
    // Don't include ID if it's null (for insertion)
    return {
      if (id != null) 'id': id,
      'name': name,
      'email': email,
    };
  }

   // Helper method for updates (creates a copy with new values)
  User copyWith({
    int? id,
    String? name,
    String? email,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }


  @override
  List<Object?> get props => [id, name, email];

  @override
  bool get stringify => true; // Optional: for easier debugging print
}