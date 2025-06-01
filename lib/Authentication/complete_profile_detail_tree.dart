import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrimony_flutter/AnimatedLoader.dart';
import 'package:matrimony_flutter/Home/user_list/user_controllers.dart';
import 'package:matrimony_flutter/Home/home.dart';
import 'package:matrimony_flutter/Update/Submit_Pages/Hobbies.dart';
import 'package:matrimony_flutter/Update/Submit_Pages/city.dart';
import 'package:matrimony_flutter/Update/Submit_Pages/gender.dart';
import 'package:matrimony_flutter/Update/Submit_Pages/name_profilephoto.dart';

class CompleteProfileDetailTree extends StatefulWidget {
  String email;
  CompleteProfileDetailTree({super.key,required this.email});

  @override
  State<CompleteProfileDetailTree> createState() =>
      _CompleteProfileDetailTreeState();
}

class _CompleteProfileDetailTreeState extends State<CompleteProfileDetailTree> {
  UserOperations  userOperations = UserOperations();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
        future: userOperations.checkUnfillDetail(email: widget.email),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: AnimatedLoader());
          } else if (snapshot.hasData) {
            String data = snapshot.data!;

            if (data == 'name') {
              return NameProfilephoto(); // Your screen for name input
            } else if (data == 'dob') {
              return NameProfilephoto(); // Your screen for DOB
            } else if (data == 'gender') {
              return Gender(); // Your screen for gender
            } else if (data == 'city') {
              return City(); // Your screen for city
            } else if (data == 'hobbies') {
              return Hobbies(); // Your screen for hobbies
            } else {
              return Home(); // All fields filled
            }
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            return Home();
          }
        }
    );
  }
}
