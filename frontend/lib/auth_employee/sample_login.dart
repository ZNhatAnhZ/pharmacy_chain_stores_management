import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../blocks/auth_block.dart';
import '../models/employee.dart';
import '../services/forgot_password_service.dart';
import 'my_text.dart';
import 'mybutton.dart';

class LoginBodyScreen extends StatefulWidget {
  const LoginBodyScreen({super.key});

  @override
  State<LoginBodyScreen> createState() => _LoginBodyScreenState();
}

class _LoginBodyScreenState extends State<LoginBodyScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final EmployeeCredential employeeCredential =
      EmployeeCredential(email: '', password: '');
  final ForgotPasswordService forgotPasswordService = ForgotPasswordService();

  List<String> list = <String>['Employee', 'Customer', 'Admin'];
  String dropdownValue = 'Employee';

  @override
  Widget build(BuildContext context) {
    final AuthBlock auth = Provider.of<AuthBlock>(context);
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Container(
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage("https://i.ibb.co/qpNZ52M/pharmacy.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(0, 40, 0, 120),
            shrinkWrap: true,
            reverse: true,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 600,
                        width: 370,
                        decoration: BoxDecoration(
                          color: HexColor("#ffffff"),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                            bottomRight: Radius.circular(40),
                            bottomLeft: Radius.circular(40),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Log In",
                                style: GoogleFonts.poppins(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: HexColor("#4f4f4f"),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 0, 0, 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "User Type",
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        color: HexColor("#8d8d8d"),
                                      ),
                                    ),
                                    DropdownButton<String>(
                                      value: dropdownValue,
                                      icon: const Icon(Icons.arrow_drop_down),
                                      elevation: 16,
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        color: HexColor("#8d8d8d"),
                                      ),
                                      isExpanded: true,
                                      underline: Container(
                                        height: 2,
                                        color: HexColor("#ffffff"),
                                      ),
                                      iconSize: 30,
                                      borderRadius: BorderRadius.circular(20),
                                      onChanged: (String? value) {
                                        setState(() {
                                          dropdownValue = value!;
                                        });
                                      },
                                      items: list.map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 1,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 0, 0, 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Email",
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        color: HexColor("#8d8d8d"),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    MyTextField(
                                      controller: emailController,
                                      hintText: "hello@gmail.com",
                                      obscureText: false,
                                      prefixIcon:
                                          const Icon(Icons.mail_outline),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Password",
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        color: HexColor("#8d8d8d"),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    MyTextField(
                                      controller: passwordController,
                                      hintText: "**************",
                                      obscureText: true,
                                      prefixIcon:
                                          const Icon(Icons.lock_outline),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    MyButton(
                                      onPressed: () {
                                        employeeCredential.email =
                                            emailController.text;
                                        employeeCredential.password =
                                            passwordController.text;
                                        inspect(employeeCredential);

                                        if (auth.isLoggedIn) {
                                          Navigator.pop(context);
                                          if (auth.employee['role'] ==
                                              'customer') {
                                            Navigator.pushNamed(
                                                context, '/inventory_page');
                                          }

                                          if (auth.employee['role'] ==
                                              'admin') {
                                            Navigator.pushNamed(
                                                context, '/employee_page');
                                          }
                                        } else {
                                          switch (dropdownValue) {
                                            case 'Employee':
                                              auth.employeeLogin(
                                                  employeeCredential);
                                              break;
                                            case 'Customer':
                                              auth.customerLogin(
                                                  employeeCredential);
                                              break;
                                            case 'Admin':
                                              auth.adminLogin(
                                                  employeeCredential);
                                              break;
                                          }
                                        }
                                      },
                                      buttonText: 'Submit',
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 0, 0, 0),
                                      child: Row(
                                        children: [
                                          Text("Don't have an account?",
                                              style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                color: HexColor("#8d8d8d"),
                                              )),
                                          TextButton(
                                              child: Text(
                                                "Sign Up",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 15,
                                                  color: HexColor("#44564a"),
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                                Navigator.pushNamed(
                                                    context, '/signup');
                                              }),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 0, 0, 0),
                                      child: Row(
                                        children: [
                                          Text("Forgot password?",
                                              style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                color: HexColor("#8d8d8d"),
                                              )),
                                          TextButton(
                                              child: Text(
                                                "Click here",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 15,
                                                  color: HexColor("#44564a"),
                                                ),
                                              ),
                                              onPressed: () {
                                                forgotPasswordService
                                                    .forgotPassword(
                                                        emailController.text)
                                                    .then((value) {
                                                  if (value) {
                                                    Navigator.pop(context);
                                                    Navigator.pushNamed(context,
                                                        '/forgot_password',
                                                        arguments:
                                                            emailController
                                                                .text);
                                                  }
                                                });
                                              }),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
