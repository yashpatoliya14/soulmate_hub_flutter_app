import 'package:flutter/cupertino.dart';
import 'package:matrimony_flutter/Authentication/auth.dart';
import 'package:matrimony_flutter/standard.dart';
import 'package:matrimony_flutter/Home/user_list/user_controllers.dart';

class UserListProvider with ChangeNotifier{
  List<Map<String, dynamic>> userList = [];
  List<Map<String, dynamic>> searchList = [];
  Map<String,dynamic> userData = {}; 
  bool fetched = false;

  Future<void> getUserData({bool refresh=false}) async {
    if(fetched && refresh==false) return ;
    UserOperations userOperations = UserOperations();
    final currentUserEmail = Auth().currentUser?.email;
    //user doesn't found
    if (currentUserEmail == null) return;

      final allUsers = await userOperations.getAllUsers();
      List<Map<String, dynamic>> filteredUsers = [];

      for (var user in allUsers) {

        if (user[ISPROFILEDETAILS] == true && user[EMAIL] != currentUserEmail) {
            filteredUsers.add(user);
        }
        if(user[EMAIL] == currentUserEmail){
            userData = user;
        }
      }
      
      userList = filteredUsers.reversed.toList(); // Show newest users first
      
      fetched = true;
  }
  notifytoAllWidgets(){
    notifyListeners();
  }
  clear(){
    userList = [];
    fetched = false;
    notifyListeners();
  }

}