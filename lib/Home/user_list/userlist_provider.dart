import 'package:flutter/cupertino.dart';
import 'package:matrimony_flutter/Authentication/auth.dart';
import 'package:matrimony_flutter/Authentication/standard.dart';
import 'package:matrimony_flutter/Home/user_list/user_controllers.dart';

class UserListProvider with ChangeNotifier{
  List<Map<String, dynamic>> userList = [];
  List<String> favList = [];
  bool fetched = false;
  List<String> cities = [];
  String? selectedCity;
  String? selectedGender;

  Future<void> getUserData({bool refresh=false}) async {
    if(fetched && refresh==false) return ;
    UserOperations userOperations = UserOperations();
    final currentUserEmail = Auth().currentUser?.email;

    if (currentUserEmail == null) return;

      final allUsers = await userOperations.getAllUsers();
      List<Map<String, dynamic>> filteredUsers = [];

      for (var user in allUsers) {
        // Set favList for current user
        if (user[EMAIL] == currentUserEmail) {
          favList = List<String>.from(user[FAVORITELIST] ?? []);
          continue;
        }

        if (user[ISPROFILEDETAILS] == true) {
          bool matchesCity = selectedCity == null || user[CITY] == selectedCity;
          bool matchesGender =
              selectedGender == null || user[GENDER] == selectedGender;

          if (matchesCity && matchesGender) {
            filteredUsers.add(user);
          }
        }
      }
      
      userList = filteredUsers.reversed.toList(); // Show newest users first
      print("::::$userList");
      
      fetched = true;
  }

}