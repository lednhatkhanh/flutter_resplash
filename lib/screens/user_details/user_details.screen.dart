import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:re_splash/models/user.model.dart';
import 'package:re_splash/screens/user_details/providers/user_details.provider.dart';
import 'package:re_splash/screens/user_details/widgets/user_details_content.dart';

class UserDetailsScreen extends StatelessWidget {
  final User user;

  const UserDetailsScreen({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserDetailsProvider(user: user),
      child: UserDetailsContent(user: user),
    );
  }
}
