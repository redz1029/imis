class FormValidator {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter some text";
    }
    bool emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+$",
    ).hasMatch(value);
    return emailValid ? null : "Please enter a valid email";
  }
}
