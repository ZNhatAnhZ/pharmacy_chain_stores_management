import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medical_chain_manangement/blocks/auth_block.dart';
import 'admin_signin.dart';

class AdminAuth extends StatelessWidget {
  final List<Widget> tabs = [AdminSignIn()];
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
      body: tabs[authBlock.currentIndex],
    );
  }
}
