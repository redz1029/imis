import 'package:flutter/material.dart';

class TimePickerField extends StatefulWidget {
  final String label;
  final TimeOfDay? initialTime;
  final Function(TimeOfDay)? onTimeSelected;

  const TimePickerField({
    super.key,
    this.label = "Select Time",
    this.initialTime,
    this.onTimeSelected,
  });

  @override
  TimePickerFieldState createState() => TimePickerFieldState();
}

class TimePickerFieldState extends State<TimePickerField> {
  late TextEditingController _controller;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.initialTime;
    _controller = TextEditingController(
      text: _selectedTime != null ? _formatTime(_selectedTime!) : "",
    );
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? "AM" : "PM";
    return "$hour:$minute $period";
  }

  Future<void> _pickTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
        child: child!,
      ),
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        _controller.text = _formatTime(picked);

        if (widget.onTimeSelected != null) widget.onTimeSelected!(picked);
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      readOnly: true,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelText: widget.label,
        border: OutlineInputBorder(),
        suffixIcon: const Icon(Icons.access_time),
      ),
      onTap: _pickTime,
    );
  }
}
