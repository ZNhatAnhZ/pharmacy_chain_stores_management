import 'package:flutter/material.dart';
import 'package:medical_chain_manangement/blocks/auth_block.dart';
import 'package:medical_chain_manangement/models/employee.dart';
import 'package:provider/provider.dart';

import '../models/customer.dart';

class CustomerSignUp extends StatefulWidget {
  @override
  _CustomerSignUpState createState() => _CustomerSignUpState();
}

class _CustomerSignUpState extends State<CustomerSignUp> {
  final _formKey = GlobalKey<FormState>();
  final Customer customer = Customer(password: '', name: '', email: '');
  late String confirmPassword;

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
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter Username';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      setState(() {
                        customer.name = value!;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter Username',
                      labelText: 'Username',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter Email Address';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      setState(() {
                        customer.email = value!;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter Email',
                      labelText: 'Email',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter Password';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        setState(() {
                          customer.password = value!;
                        });
                      },
                      onChanged: (text) {
                        customer.password = text;
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter Password',
                        labelText: 'Password',
                      ),
                      obscureText: true),
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter Confirm Password';
                    } else if (customer.password != confirmPassword) {
                      return 'Password fields dont match';
                    }
                    return null;
                  },
                  onChanged: (text) {
                    confirmPassword = text;
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter Same Password',
                    labelText: 'Confirm Password',
                  ),
                  obscureText: true,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Consumer<AuthBlock>(builder:
                        (BuildContext context, AuthBlock auth, Widget? child) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor,
                        ),
                        child: auth.loading && auth.loadingType == 'register'
                            ? CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : Text(
                                'Sign Up',
                                style: TextStyle(color: Colors.white),
                              ),
                        onPressed: () {
                          if (_formKey.currentState!.validate() &&
                              !auth.loading) {
                            _formKey.currentState!.save();
                            // If the form is valid, display a snackbar. In the real world,
                            // you'd often call a server or save the information in a database.
                            auth.customerRegister(customer);
                          }
                        },
                      );
                    }),
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
