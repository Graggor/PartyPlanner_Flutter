class Guest {
  final String name;
  final String email;

  const Guest({
    required this.name,
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
    };
  }

  factory Guest.fromJson(Map<String, dynamic> json) {
    return Guest(
      name: json['name'],
      email: json['email'],
    );
  }
}
