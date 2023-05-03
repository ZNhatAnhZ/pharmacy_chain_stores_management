import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medical_chain_manangement/blocks/auth_block.dart';
import 'customer_signin.dart';
import 'customer_signup.dart';

class CustomerAuth extends StatelessWidget {
  final List<Widget> tabs = [CustomerSignIn(), CustomerSignUp()];
  @override
  Widget build(BuildContext context) {
    final AuthBlock authBlock = Provider.of<AuthBlock>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text((() {
          if (authBlock.currentIndex == 0) {
            return 'Customer sign In';
          } else {
            return 'Customer Create Account';
          }
        }())),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.lock_person_outlined),
            label: 'Customer sign In',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            label: 'Customer create Account',
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
