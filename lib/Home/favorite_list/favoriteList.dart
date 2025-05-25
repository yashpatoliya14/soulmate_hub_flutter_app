import 'package:matrimony_flutter/Home/favorite_list/favoritelist_provider.dart';
import 'package:matrimony_flutter/Home/user_list/user_controllers.dart';
import 'package:matrimony_flutter/Home/user_list/user_model.dart';
import 'package:matrimony_flutter/Home/loader.dart';
import 'package:matrimony_flutter/User_Detail/user_detail.dart';
import 'package:matrimony_flutter/Utils/importFiles.dart';
import 'package:provider/provider.dart';

class Favoritelist extends StatefulWidget {
  const Favoritelist({super.key});

  @override
  State<Favoritelist> createState() => _FavoritelistState();
}

class _FavoritelistState extends State<Favoritelist> {
  bool _loading = false;

  _fetchFavorites([refresh=false]) async {
    setState(() {
      _loading = true;
    });
    await Provider.of<FavoritelistProvider>(context,listen: false).getUserData(refresh);
    setState(() {
      _loading = false;
    });
  }


  Future<void> onLike(String selectedEmail) async {
    UserOperations userOperations = UserOperations();
    final provider = Provider.of<FavoritelistProvider>(context,listen: false);
    final currentEmail = Auth().currentUser!.email.toString();
    if(currentEmail==null){
      print(":::::::User email not found !! :::::::");
      return;
    }

      if (provider.favList.contains(selectedEmail)) {
        provider.favList.remove(selectedEmail);
        provider.favoriteList.removeWhere((favorite)=>favorite[EMAIL] == selectedEmail);
        setState(() {
          
        });
      } else {
        provider.favList.add(selectedEmail);            
      }

      UserModel updatedUser = UserModel(FAVORITELIST: provider.favList);

      await userOperations.updateUserByEmail(
        updatedData: updatedUser.toJson(),
        email: currentEmail,
      );
  }

  @override
  void initState() {
    super.initState();
     _fetchFavorites();
  }
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FavoritelistProvider>(context);
    final favoriteList = provider.favoriteList;
    if(favoriteList.isEmpty){
      return Center(
        child: Text("No favorite user found",style: GoogleFonts.nunito(),),
      );
    }
    return Column(
      children: [
        const Padding(padding: EdgeInsets.all(8.0)),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              provider.favoriteList.clear();
              provider.favList.clear();
              _fetchFavorites(true);              
            },
            child: !_loading ? ListView.builder(
                    itemCount: favoriteList.length,
                    itemBuilder: (context, index) {
                      return getListItem(favoriteList[index], index,provider.favList);
                    },
                  ) : LoadingWidget()
            ),
          ),
      ],
    );
  }

  Widget getListItem(Map<String, dynamic> user, int index, List<String> favList) {
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