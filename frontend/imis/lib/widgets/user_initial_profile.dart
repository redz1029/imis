import 'package:flutter/material.dart';
import 'package:imis/user/models/user_registration.dart';
import 'package:imis/utils/auth_util.dart';

class UserInitialProfile extends StatelessWidget {
  final double size;
  final Color? color;
  final Color? textColor;

  const UserInitialProfile({
    super.key,
    this.size = 40,
    this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserRegistration?>(
      future: AuthUtil.fetchLoggedUser(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          final user = snapshot.data!;
          final firstNameInitial =
              user.firstName!.isNotEmpty
                  ? user.firstName![0].toUpperCase()
                  : '';
          final lastNameInitial =
              user.lastName!.isNotEmpty ? user.lastName![0].toUpperCase() : '';

          return Container(
            width: size,
            height: size,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color ?? Theme.of(context).primaryColor,
            ),
            child: Text(
              '$firstNameInitial$lastNameInitial',
              style: TextStyle(
                color: textColor ?? Colors.white,
                fontSize: size / 2,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }
        return Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color ?? Colors.grey[300],
          ),
          child: Icon(
            Icons.person,
            size: size / 2,
            color: textColor ?? Colors.grey[700],
          ),
        );
      },
    );
  }
}
