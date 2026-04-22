enum UserRole { admin, helpdesk, user }

class User {
  final String id;
  final String email;
  final String name;
  final String token;
  final UserRole role;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.token,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      token: json['token'] as String,
      role: UserRole.values.firstWhere(
        (e) => e.name == (json['role'] as String? ?? 'user'),
        orElse: () => UserRole.user,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'token': token,
      'role': role.name,
    };
  }
}
