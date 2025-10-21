import 'package:flutter/services.dart';

// ignore: unused_element
class RangeInputFormatter extends TextInputFormatter {
  final int min;
  final int max;

  RangeInputFormatter(this.min, this.max);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;

    final int? value = int.tryParse(newValue.text);
    if (value == null || value < min || value > max) {
      return oldValue;
    }
    return newValue;
  }
}

class CompletedInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    // Allow only digits
    if (!RegExp(r'^\d*$').hasMatch(text)) return oldValue;

    // If empty, allow it (for backspace)
    if (text.isEmpty) return newValue;

    // Convert to number
    final value = int.tryParse(text) ?? 0;

    // Only allow values 100–999
    if (value < 100 || value > 999) {
      return oldValue;
    }

    return newValue;
  }
}
