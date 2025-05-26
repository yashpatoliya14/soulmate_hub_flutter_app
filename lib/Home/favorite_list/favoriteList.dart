import 'package:matrimony_flutter/Home/favorite_list/favoritelist_provider.dart';
import 'package:matrimony_flutter/Home/favorite_list/get_list_item_for_favorite.dart';
import 'package:matrimony_flutter/Home/loader.dart';
import 'package:matrimony_flutter/Utils/importFiles.dart';
import 'package:provider/provider.dart';

class Favoritelist extends StatefulWidget {
  const Favoritelist({super.key});

  @override
  State<Favoritelist> createState() => _FavoritelistState();
}

class _FavoritelistState extends State<Favoritelist> {
  bool _loading = false;

  //fetch favorite users
  _fetchFavorites([refresh=false]) async {
    setState(() {
      _loading = true;
    });
    await Provider.of<FavoritelistProvider>(context,listen: false).getUserData(refresh);
    setState(() {
      _loading = false;
    });
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
                    itemCount: provider.favoriteList.length,
                    itemBuilder: (context, index) {
                      return GetListItemForFavorite(user : favoriteList[index],index: index,favList : provider.favList);
                    },
                  ) : LoadingWidget()
            ),
          ),
      ],
    );
  }

  
}