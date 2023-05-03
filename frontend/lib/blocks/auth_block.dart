import 'package:flutter/material.dart';
import 'package:medical_chain_manangement/models/employee.dart';
import 'package:medical_chain_manangement/services/auth_service.dart';

import '../models/customer.dart';

class AuthBlock extends ChangeNotifier {
  AuthBlock() {
    setEmployee();
  }

  final AuthService _authService = AuthService();
  // Index
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;
  set currentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  // Loading
  bool _loading = false;
  late String _loadingType;
  bool get loading => _loading;
  String get loadingType => _loadingType;
  set loading(bool loadingState) {
    _loading = loadingState;
    notifyListeners();
  }

  set loadingType(String loadingType) {
    _loadingType = loadingType;
    notifyListeners();
  }

  // Loading
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;
  set isLoggedIn(bool isUserExist) {
    _isLoggedIn = isUserExist;
    notifyListeners();
  }

  // just in case if you want to see how logged in drawer would look like, uncomment _user and  comment _authService.getUser()
  // Map _user = {
  //   'user_email': 'furqan.khanzada@gmail.com',
  //   'user_display_name': 'Muhammad Furqan'
  // };
  Map _employee = {};
  Map get employee => _employee;

  setEmployee() async {
    _employee = await _authService.getEmployee();
    isLoggedIn = _employee.isNotEmpty;
    notifyListeners();
  }

  employeeLogin(EmployeeCredential employeeCredential) async {
    loading = true;
    loadingType = 'login';
    _authService.employeeLogin(employeeCredential).then((value) async {
      _employee = value;
      isLoggedIn = _employee.isNotEmpty;
      loading = false;
      notifyListeners();
    }).onError((error, stackTrace) {
      print(error);
      loading = false;
    });
  }

  employeeRegister(Employee employee) async {
    loading = true;
    loadingType = 'register';
    await _authService.employeeRegister(employee);
    loading = false;
  }

  customerLogin(EmployeeCredential employeeCredential) async {
    loading = true;
    loadingType = 'login';
    _authService.customerLogin(employeeCredential).then((value) async {
      _employee = value;
      isLoggedIn = _employee.isNotEmpty;
      loading = false;
      notifyListeners();
    }).onError((error, stackTrace) {
      print(error);
      loading = false;
    });
  }

  customerRegister(Customer customer) async {
    loading = true;
    loadingType = 'register';
    await _authService.customerRegister(customer);
    loading = false;
  }

  logout() async {
    await _authService.logout();
    isLoggedIn = false;
    notifyListeners();
  }
}
