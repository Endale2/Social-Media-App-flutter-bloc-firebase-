class AppUser {
  final String uid;
  final String email;
  final String name;

  const AppUser({required this.email, required this.name, required this.uid});

  // Convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "email": email,
      "name": name,
    };
  }

  // Convert JSON to AppUser object
  factory AppUser.fromJson(Map<String, dynamic> jsonUser) {
    return AppUser(
      email: jsonUser["email"],
      name: jsonUser["name"],
      uid: jsonUser["uid"],
    );
  }
}
