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

    List<Map<String, dynamic>> userList = await userOperations.getAllUsers();

    final userData = await userOperations.getUserByEmail(email: currentEmail);
    
    final List<String> favoriteListEmail = List<String>.from(
      userData?[FAVORITELIST] ?? [],
    );

    for (var user in userList) {
      if (favoriteListEmail.contains(user[EMAIL])) {
        favoriteList.add(user);
      }
    }
    favList = favoriteListEmail;
    fetched = true;
  }

}
