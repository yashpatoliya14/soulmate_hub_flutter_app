import 'package:matrimony_flutter/Home/loader.dart';
import 'package:matrimony_flutter/Home/user_list/userlist_provider.dart';
import 'package:matrimony_flutter/Utils/importFiles.dart';
import 'package:provider/provider.dart';
import '../appbar/search_bar.dart';
import 'get_list_item.dart';

class UserList extends StatefulWidget {
  bool search;
  UserList({super.key, required this.search});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  //utils

  bool _loading = false;

  //methods
  void changeStateOfSearchBar() {
    setState(() {
      isSearchBar = false;
    });
  }

  void onChangeSearchData(searchData) {
    setState(() {
      final provider = Provider.of<UserListProvider>(context,listen: false);
      List<Map<String,dynamic>> userList = provider.userList;
      provider.searchList =
          userList.where((user) {
            return user[FULLNAME].toString().toLowerCase().contains(
                  searchData,
                ) ||
                user[CITY].toString().toLowerCase().contains(searchData) ||
                user[EMAIL].toString().toLowerCase().contains(searchData) ||
                user[MOBILE].toString().toLowerCase().contains(searchData) ||
                user[AGE].toString().toLowerCase().contains(searchData);
          }).toList();
    });
  }


  Future<void> _fetchUserData({bool? refresh}) async {
    _loading = true;
    final provider = Provider.of<UserListProvider>(context, listen: false);
    await provider.getUserData(refresh: refresh ?? false).then((value) {
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserListProvider>(context);
    return Scaffold(
      body: Column(
        children: [
          Container(
            child: isSearchBarHide(
              widget,
              context,
              changeStateOfSearchBar,
              onChangeSearchData,
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                  provider.userList = []; 
                _fetchUserData(refresh:true);
              },
              child:
                  !_loading
                      ? ListView.builder(
                        itemBuilder: (BuildContext context, int index) {
                          return GetListItem(
                            index: index,
                          );
                        },
                        itemCount:
                            searchController.text.isEmpty
                                ? provider.userList.length
                                : provider.searchList.length,
                      )
                      : LoadingWidget(),
            ),
          ),
        ],
      ),
    );
  }
}
