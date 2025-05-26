//region hobbies List
import 'package:flutter/material.dart';
final List<Map<String, dynamic>> hobbiesData = [
  {"name": "Cricket", "isChecked": false},
  {"name": "Reading", "isChecked": false},
  {"name": "Watching", "isChecked": false},
  {"name": "Gaming", "isChecked": false},
  {"name": "Coding", "isChecked": false},
  {"name": "travelling", "isChecked": false},
];


//cities list
List<String> cities = [
  "Select your city",
  "Rajkot",
  "Ahemdabad",
  "Vadodara",
  "Surat",
  "Delhi",
  "Mumbai",
  "Jaipur",
  "banglore",
  "hydrabad",
  "kolakata"
];
bool isDisplayFloatButton = false;
bool? ishidePass = true;
bool? ishideConfirm = true;

//select variables
int? selectedRadio = 0;
String? selectedCity ;
DateTime? selectedDate = DateTime.now();
bool isSelectedRadio = true;
bool isSelectedCity = true;
bool isSelectedHobbies = true;
List<String>? selectedHobbies;

//errors variables
String? firstNameError;
String? emailError;
String? mobileError;
String? passwordError;
String? confirmPasswordError;
String? dobError;
String? cityError;
String? hobbiesError;
String? genderError;

//gender list
List<String> gender = ["Male", "Female"];
bool? isFavorite;


final List<Color> appBarGradientColors = [Colors.red, Colors.deepOrange.shade300];

//all controller
TextEditingController fullnameController = TextEditingController();
TextEditingController lastnameController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController mobileController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController confirmPasswordController = TextEditingController();
TextEditingController dobController = TextEditingController();


String? validateFirstName(String? value) {
  if (value == null || value.isEmpty) {
    return 'Enter Your Full Name';
  }
  if (!RegExp(r"^[a-zA-Z\s']{3,50}$").hasMatch(value)) {
    return "Enter a valid first name (3-50 characters, alphabets only)";
  }
  return null;
}

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Enter Email Address';
  }
  if (!RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
      .hasMatch(value)) {
    return 'Enter a valid email address.';
  }
  return null;
}

String? validateMobile(String? value) {
  if (value == null || value.isEmpty) {
    return 'Enter Mobile Number';
  }
  if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(value)) {
    return 'Enter a valid Mobile Number.';
  }
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Enter Password';
  }
  if (!RegExp(r"(?=^.{8,}$)((?=.*\d)|(?=.*\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$")
      .hasMatch(value)) {
    return "Please Enter a Strong Password";
  }
  return null;
}

String? validateConfirmPassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Enter Confirm Password';
  }
  if (passwordController.text != confirmPasswordController.text) {
    return "Passwords do not match";
  }
  return null;
}

String? validateDOB(String? value) {
  if (value == null || value.isEmpty) {
    return "Select Your BirthDate";
  }

  DateTime today = DateTime.now();
  int yearDifference = today.year - selectedDate!.year;

  if (today.month < selectedDate!.month ||
      (today.month == selectedDate!.month && today.day < selectedDate!.day)) {
    yearDifference--;
  }
  if (yearDifference < 18) {
    return "You must be at least 18 years old to register.";
  }
  if (yearDifference > 80) {
    return "You must be at most 80 years old to register.";
  }
  return null;
}

String? validateCity(String? value) {
  if (value == null || value == cities[0]) {
    return "Please select your city";
  }
  return null;
}

String? validateHobbies() {
  final selectedHobbies = hobbiesData
      .where((hobby) => hobby["isChecked"] == true)
      .map((hobby) => hobby["name"] as String)
      .toList();
  if (selectedHobbies.isEmpty) {
    return "Please select your hobbies";
  }
  return null;
}

