class UserAlreadyExistsException implements Exception {
  @override
  String toString() {
    return 'The username already exists.';
  }
}
