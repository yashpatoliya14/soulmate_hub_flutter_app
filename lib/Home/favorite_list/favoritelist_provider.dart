import 'package:matrimony_flutter/Home/user_list/user_controllers.dart';
import 'package:matrimony_flutter/Utils/importFiles.dart';

class FavoritelistProvider with ChangeNotifier {
  bool fetched = false;
  List<String> favList =[];
  List<Map<String,dynamic>> favoriteList = [];
  Future<void> getUserData([refresh=false]) async {
    if(fetched && refresh==false)
      return;
    
    final userOperations = UserOperations();

    final String? currentEmail = Auth().currentUser!.email;
    if (currentEmail == null) return;

    //get all users
    List<Map<String, dynamic>> userList = await userOperations.getAllUsers();

    //get user by email
    final userData = await userOperations.getUserByEmail(email: currentEmail);
    
    //favorite emails
     favList = List<String>.from(
      userData?[FAVORITELIST] ?? [],
    );

    //add favorite user data into favorite list 
    for (var user in userList) {
      if (favList.contains(user[EMAIL])) {
        favoriteList.add(user);
      }
    }
    fetched = true;
  }

  notifytoAllWidgets(){
    notifyListeners();
  }

}
