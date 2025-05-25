import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:matrimony_flutter/Home/favorite_list/favoritelist_provider.dart';
import 'package:matrimony_flutter/Home/user_list/user_controllers.dart';
import 'package:matrimony_flutter/Home/user_list/user_model.dart';
import 'package:matrimony_flutter/Chat/chat_screen.dart';
import 'package:matrimony_flutter/Home/favorite_list/favoriteList.dart';
import 'package:matrimony_flutter/Home/user_list/userlist_provider.dart';
import 'package:matrimony_flutter/User_Detail/user_detail.dart';
import 'package:matrimony_flutter/Utils/importFiles.dart';
import 'package:provider/provider.dart';

import '../appbar/search_bar.dart';

class GetListItem extends StatefulWidget {
  final int index;
  final List<Map<String, dynamic>> searchList;

  const GetListItem({Key? key, required this.index, required this.searchList})
    : super(key: key);

  //methods

  @override
  State<GetListItem> createState() => _GetListItemState();
}

class _GetListItemState extends State<GetListItem> {
  @override
  Widget build(BuildContext context) {
    final int index = widget.index;
    final provider = Provider.of<UserListProvider>(context);
    final List<Map<String, dynamic>> userList = provider.userList;
    final List<Map<String, dynamic>> searchList = widget.searchList;
    final currentList = searchController.text.isEmpty ? userList : searchList;
    final providerFavoriteList = Provider.of<FavoritelistProvider>(
      context,
      listen: false,
    );

    bool isSearchOpen = searchController.text.isNotEmpty;
    void onLike() async {
      SharedPreferences preferences = Get.find<SharedPreferences>();
      UserOperations userOperations = UserOperations();

      String selectedEmail = userList[index][EMAIL];

      // Toggle logic
      if (providerFavoriteList.favList.contains(
        isSearchOpen ? searchList[index][EMAIL] : userList[index][EMAIL],
      )) {
        setState(() {
          providerFavoriteList.favoriteList.removeWhere(
            (favorite) => favorite[EMAIL] == selectedEmail,
          );
          providerFavoriteList.favList.remove(selectedEmail);
        });
      } else {
        setState(() {
          providerFavoriteList.favoriteList.add(
            provider.userList.singleWhere(
              (user) => user[EMAIL] == selectedEmail,
            ),
          );
          providerFavoriteList.favList.add(selectedEmail);
        });
      }

      UserModel updatedUser = UserModel(
        FAVORITELIST: providerFavoriteList.favList,
      );

      await userOperations.updateUserByEmail(
        updatedData: updatedUser.toJson(),
        email: Auth().currentUser!.email.toString(),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isTablet = constraints.maxWidth > 600;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            width: double.infinity,
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
                // Profile Image
                CircleAvatar(
                  radius: isTablet ? 45 : 35,
                  backgroundImage: NetworkImage(
                    currentList[index][PROFILEPHOTO] ?? "",
                  ),
                  backgroundColor: Colors.grey[200],
                ),
                const SizedBox(width: 12),

                // Details Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name
                      Text(
                        userList[index][FULLNAME],
                        style: TextStyle(
                          fontSize: isTablet ? 20 : 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),

                      // Email & City
                      Wrap(
                        spacing: 10,
                        runSpacing: 6,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Iconsax.location,
                                size: 16,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                currentList[index][CITY],
                                style: const TextStyle(color: Colors.black54),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.email,
                                size: 16,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                currentList[index][EMAIL],
                                style: const TextStyle(color: Colors.black54),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // Buttons
                      Wrap(
                        spacing: 12,
                        runSpacing: 8,
                        children: [
                          // Like Button
                          TextButton.icon(
                            onPressed: onLike,
                            icon: Icon(
                              (providerFavoriteList.favList.contains(
                                    isSearchOpen
                                        ? searchList[index][EMAIL]
                                        : userList[index][EMAIL],
                                  ))
                                  ? Iconsax.heart5
                                  : Iconsax.heart,
                              color:
                                  (providerFavoriteList.favList.contains(
                                        isSearchOpen
                                            ? searchList[index][EMAIL]
                                            : userList[index][EMAIL],
                                      ))
                                      ? Colors.red
                                      : Colors.deepOrange,
                            ),
                            label: Text(
                              (providerFavoriteList.favList.contains(
                                        isSearchOpen
                                            ? searchList[index][EMAIL]
                                            : userList[index][EMAIL],
                                      ))
                                  ? "Liked"
                                  : "Like",
                            ),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                            ),
                          ),

                          // Message Button
                          TextButton.icon(
                            onPressed: () {
                              Get.to(
                                ChatScreen(
                                  receiverId: userList[index][ID],
                                  receiverName: userList[index][FULLNAME],
                                ),
                                transition: Transition.fade,
                              );
                            },
                            icon: const Icon(Iconsax.message),
                            label: const Text("Message"),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.purple,
                            ),
                          ),

                          // View Profile
                          TextButton(
                            onPressed: () {
                              Get.to(
                                UserDetail(data: userList[index]),
                                transition: Transition.fadeIn,
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
