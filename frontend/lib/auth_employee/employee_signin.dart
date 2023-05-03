import 'package:flutter/material.dart';
import 'package:medical_chain_manangement/blocks/auth_block.dart';
import 'package:medical_chain_manangement/models/employee.dart';
import 'package:medical_chain_manangement/services/forgot_password_service.dart';
import 'package:provider/provider.dart';

class EmployeeSignIn extends StatefulWidget {
  @override
  _EmployeeSignInState createState() => _EmployeeSignInState();
}

class _EmployeeSignInState extends State<EmployeeSignIn> {
  final _formKey = GlobalKey<FormState>();
  final EmployeeCredential employeeCredential =
      EmployeeCredential(email: '', password: '');
  final ForgotPasswordService forgotPasswordService = ForgotPasswordService();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter Email';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        employeeCredential.email = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter Your Email',
                      labelText: 'Email',
                    ),
                  ),
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter Password';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      employeeCredential.password = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter Password',
                    labelText: 'Password',
                  ),
                  obscureText: true,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Consumer<AuthBlock>(
                      builder: (BuildContext context, AuthBlock auth,
                          Widget? child) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).primaryColor,
                          ),
                          child: auth.loading && auth.loadingType == 'login'
                              ? CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                )
                              : Text(
                                  'Sign In',
                                  style: TextStyle(color: Colors.white),
                                ),
                          onPressed: () async {
                            // Validate form
                            if (_formKey.currentState!.validate() &&
                                !auth.loading) {
                              auth.employeeLogin(employeeCredential).then((e) {
                                Navigator.pop(context);
                              });
                            }
                          },
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Consumer<AuthBlock>(
                      builder: (BuildContext context, AuthBlock auth,
                          Widget? child) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).primaryColor,
                          ),
                          child: auth.loading && auth.loadingType == 'login'
                              ? CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                )
                              : Text(
                                  'Quên mật khẩu',
                                  style: TextStyle(color: Colors.white),
                                ),
                          onPressed: () async {
                            forgotPasswordService
                                .forgotPassword(employeeCredential.email)
                                .then((value) => {
                                      Navigator.pushNamed(
                                          context, '/reset_password',
                                          arguments: employeeCredential.email)
                                    });
                          },
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
