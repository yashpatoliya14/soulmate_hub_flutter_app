import 'package:flutter/material.dart';
import 'package:matrimony_flutter/Home/user_list/user_controllers.dart';
import 'package:matrimony_flutter/Utils/importFiles.dart';

class DrawerProvider with ChangeNotifier{
  //variables
  bool fetched = false;
  Map<String, dynamic>? userDetail;
  
  //methods
  Future<void> getProfileDetails([refresh=false]) async {
    
    if(fetched && refresh==false)
      return; // if data already fetched
    
    //this code execute when user want to data on refresh and first time fetch
    UserOperations userOperations = UserOperations();
    SharedPreferences prefs = Get.find<SharedPreferences>();
    userDetail = await userOperations.getUserByEmail(
      email: Auth().currentUser!.email ?? '',
    );

    fetched=true;
  }
}