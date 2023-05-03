import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medical_chain_manangement/blocks/auth_block.dart';
import 'employee_signin.dart';
import 'employee_signup.dart';

class EmployeeAuth extends StatelessWidget {
  final List<Widget> tabs = [EmployeeSignIn()];
  @override
  Widget build(BuildContext context) {
    final AuthBlock authBlock = Provider.of<AuthBlock>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text((() {
          if (authBlock.currentIndex == 0) {
            return 'Employee sign In';
          } else {
            return 'Employee Create Account';
          }
        }())),
      ),
      body: tabs[authBlock.currentIndex],
    );
  }
}
