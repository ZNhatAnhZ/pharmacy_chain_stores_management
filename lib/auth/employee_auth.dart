import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medical_chain_manangement/blocks/auth_block.dart';
import 'employee_signin.dart';
import 'employee_signup.dart';

class EmployeeAuth extends StatelessWidget {
  final List<Widget> tabs = [EmployeeSignIn(), EmployeeSignUp()];
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
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.lock_person_outlined),
            label: 'Employee sign In',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            label: 'Employee create Account',
          ),
        ],
        currentIndex: authBlock.currentIndex,
        selectedItemColor: Colors.amber[800],
        onTap: (num) {
          authBlock.currentIndex = num;
        },
      ),
      body: tabs[authBlock.currentIndex],
    );
  }
}
