import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:matrimony_flutter/Authentication/auth.dart';
import 'package:matrimony_flutter/Authentication/standard.dart';
import 'package:matrimony_flutter/Home/favorite_list/favoritelist_provider.dart';
import 'package:matrimony_flutter/Home/user_list/user_controllers.dart';
import 'package:matrimony_flutter/Home/user_list/user_model.dart';
import 'package:matrimony_flutter/User_Detail/user_detail.dart';
import 'package:provider/provider.dart';


class GetListItemForFavorite extends StatefulWidget {
  Map<String,dynamic> user;
  int index;
  List<String> favList;
  GetListItemForFavorite({super.key,required this.user,required this.index,required this.favList});

  @override
  State<GetListItemForFavorite> createState() => _GetListItemForFavoriteState();
}

class _GetListItemForFavoriteState extends State<GetListItemForFavorite> {
  Map<String,dynamic> user = {};
  int index = -1;
  List<String> favList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     user = widget.user;
     index=widget.index;
     favList = widget.favList;
  }
   // like button logic 
  Future<void> onLike(String selectedEmail) async {

    UserOperations userOperations = UserOperations();
    final provider = Provider.of<FavoritelistProvider>(context,listen: false);
    final currentEmail = Auth().currentUser!.email.toString();
    
    //email does not found !
    if(currentEmail==null){
      print(":::::::User email not found !! :::::::");
      return;
    }

    //if user contain in favlist then remove 
    if (provider.favList.contains(selectedEmail)) {
        provider.favList.remove(selectedEmail);
        provider.favoriteList.removeWhere((favorite)=>favorite[EMAIL] == selectedEmail);
        provider.notifytoAllWidgets();
    }

    UserModel updatedUser = UserModel(FAVORITELIST: provider.favList);

    // update favorite list of user
    await userOperations.updateUserByEmail(
        updatedData: updatedUser.toJson(),
        email: currentEmail,
      );
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isTablet = constraints.maxWidth > 600;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 8,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: isTablet ? 45 : 35,
                  backgroundImage: NetworkImage(user[PROFILEPHOTO] ?? ""),
                  backgroundColor: Colors.grey[200],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user[FULLNAME],
                        style: TextStyle(
                          fontSize: isTablet ? 20 : 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 10,
                        runSpacing: 6,
                        children: [
                          Row(
                            children: [
                              const Icon(Iconsax.location, size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(user[CITY], style: const TextStyle(color: Colors.black54)),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.email, size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(user[EMAIL], style: const TextStyle(color: Colors.black54)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 12,
                        runSpacing: 8,
                        children: [
                          TextButton.icon(
                            onPressed: () => onLike(user[EMAIL]),
                            icon: Icon(
                                  favList.contains(user[EMAIL]) ? Iconsax.heart5 : Iconsax.heart,
                                  color:favList.contains(user[EMAIL])? Colors.red : Colors.deepOrange,
                                ),
                            label: Text(favList.contains(user[EMAIL]) ? "Liked" : "Like"),
                              
                            
                          ),
                          TextButton(
                            onPressed: () {
                              Get.to(
                                UserDetail(data: user),
                                transition: Transition.fade,
                              );
                            },
                            child: const Text(
                              "View Profile",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.indigo,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
