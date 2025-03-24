class User {
  final String? id;
  final String firstName;
  final String lastName;
  final String email;

  User({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
    };
  }
}
