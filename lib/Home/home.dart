import 'package:firebase_auth/firebase_auth.dart';
import 'package:matrimony_flutter/Home/about/about_page.dart';
import 'package:matrimony_flutter/Home/profile/drawer.dart';
import 'package:matrimony_flutter/Utils/importFiles.dart';
import 'package:matrimony_flutter/Home/favorite_list/favoriteList.dart';
import 'package:matrimony_flutter/Update/EditForm/user_form.dart';
import 'package:matrimony_flutter/Home/user_list/user_list.dart';
import 'package:animations/animations.dart';

class Home extends StatefulWidget {
  final int index;

  // Constructor with a default value for index if null
  const Home({super.key, this.index = 0});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final User? user = Auth().currentUser;

  @override
  void initState() {
    super.initState();
    activeIndex = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      UserList(search: isSearchBar),
      Favoritelist(),
      AboutPage(),
    ];
    void onClickSearchBar() {
      setState(() {
        isSearchBar = true;
        activeIndex = 0;
      });
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          MediaQuery.of(context).size.height * 0.08,
        ),

        child: getAppBar(
          context,
          onClickSearchBar: onClickSearchBar,
          name: "Soulmate Hub",
          actionsList: [
            IconButton(
              onPressed: () {
                onClickSearchBar();
              },
              icon: const Icon(Iconsax.search_normal, color: Colors.white),
              iconSize: 25,
            ),
          ],
        ),
      ),

      drawer: SafeArea(child: GetDrawer()),

      body: PageTransitionSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
          return FadeThroughTransition(
            animation: primaryAnimation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
        child: pages[activeIndex],
      ),

      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            activeIndex = index;
          });
        },
        currentIndex: activeIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.purple.shade50,
        selectedItemColor: Colors.purple, // Keep colors unchanged
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Iconsax.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Iconsax.heart), label: 'Favorite'),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.info_circle),
            label: 'About',
          ),
        ],
      ),
    );
  }
}
