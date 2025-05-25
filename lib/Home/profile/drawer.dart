import 'package:flutter/material.dart';
import 'package:matrimony_flutter/Home/profile/drawer_provider.dart';
import 'package:matrimony_flutter/Home/profile/profile_image.dart';
import 'package:matrimony_flutter/Home/profile/profile_list_tile.dart';
import 'package:matrimony_flutter/Userform/EditForm/user_form.dart';
import 'package:matrimony_flutter/Utils/importFiles.dart';
import 'package:matrimony_flutter/launch_page.dart';
import 'package:provider/provider.dart';

class GetDrawer extends StatefulWidget {
  const GetDrawer({super.key});

  @override
  State<GetDrawer> createState() => _GetDrawerState();
}

class _GetDrawerState extends State<GetDrawer> {
  // ___________________________variables__________________________
  bool _loading = false;

  //______________________________________________________________
  // when user click on edit button then move
  // to userform page and can edit profile data
  //______________________________________________________________

  void onEdit() {
    Get.to(
      UserForm(
        userDetail:
            Provider.of<DrawerProvider>(context, listen: false).userDetail!,
        isAppBar: true,
      ),
    )?.then((value) {
      _fetchUserDetail(true);
    });
  }

  //___________________________________________________________________
  // fetch user details
  //___________________________________________________________________
  Future<void> _fetchUserDetail([refresh = false]) async {
    setState(() {
      _loading = true;
    });
    final provider = Provider.of<DrawerProvider>(context, listen: false);
    await provider.getProfileDetails(refresh).then((value) {
      setState(() {
        _loading = false;
      });
    });
  }

  //_____________________________________________________________________
  // signout from google signin and password based
  //_____________________________________________________________________
  Future<void> signOut() async {
    await Auth().signOut();

    Get.offAll(LaunchPage(), transition: Transition.fade);
  }

  @override
  void initState() {
    super.initState();
    _fetchUserDetail();
  }

  @override
  Widget build(BuildContext context) {
    //provider variable
    final provider = Provider.of<DrawerProvider>(context);
    if (provider.userDetail == null) {
      return const Center(child: Text("User data not available"));
    }
    final user = provider.userDetail;
    if (user == null)
      return const Center(child: Text("User data not available"));

    return Drawer(
      width: 300,
      child:
          !_loading
              ? ListView(
                padding: EdgeInsets.all(16),
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: ProfileImage(image: user[PROFILEPHOTO]),
                  ),

                  SizedBox(height: 10),

                  Text(
                    user['name'] ?? 'No Name',
                    style: GoogleFonts.raleway(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        child: Column(
                          children: [
                            Icon(Iconsax.edit),
                            Text("Edit", style: GoogleFonts.nunito()),
                          ],
                        ),
                        onTap: () {
                          onEdit();
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  TextButton.icon(
                    icon: Icon(Iconsax.logout),
                    label: Text("Sign out", style: GoogleFonts.nunito()),
                    onPressed: () {
                      signOut();
                    },
                  ),

                  SizedBox(height: 20),

                  ProfileListTile(
                    label: "Email",
                    data: user[EMAIL].toString(),
                    icon: Iconsax.message,
                  ),

                  SizedBox(height: 15),
                  ProfileListTile(
                    label: "Gender",
                    data: user[GENDER].toString(),
                    icon:
                        user[GENDER].toString() == "Male"
                            ? Iconsax.man
                            : Iconsax.woman,
                  ),
                  SizedBox(height: 15),
                  ProfileListTile(
                    label: "City",
                    data: user[CITY].toString(),
                    icon: Iconsax.building,
                  ),
                  SizedBox(height: 15),
                  ProfileListTile(
                    label: "Hobbies",
                    data: user[HOBBIES].join(", "),
                    icon: Iconsax.note_favorite,
                  ),
                  SizedBox(height: 15),
                  ProfileListTile(
                    label: "Date of birth",
                    data: user[DOB],
                    icon: Iconsax.calendar,
                  ),
                ],
              )
              : Center(child: CircularProgressIndicator()),
    );
  }
}
