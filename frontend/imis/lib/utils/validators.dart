String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter a password';
  }
  if (value.length < 6) {
    return 'Password must be at least 6 characters.\nInclude one uppercase letter and one special character.';
  }
  if (!RegExp(r'[A-Z]').hasMatch(value)) {
    return 'Password must be at least 6 characters.\nInclude one uppercase letter and one special character.';
  }
  if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
    return 'Password must be at least 6 characters.\nInclude one uppercase letter and one special character.';
  }
  return null;
}
