class Enforcer {
  final String? id;
  final String firstName;
  final String middleName;
  final String lastName;
  final String? suffix;
  final String profileImageUrl;

  const Enforcer({
    this.id,
    this.suffix,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.profileImageUrl,
  });
}
