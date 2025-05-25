import 'package:matrimony_flutter/AnimatedLoader.dart';
import 'package:matrimony_flutter/Authentication/complete_profile_detail_tree.dart';
import 'package:matrimony_flutter/Home/user_list/user_controllers.dart';
import 'package:matrimony_flutter/Utils/importFiles.dart';
import 'package:matrimony_flutter/launch_page.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.emailVerified) {
            String email = snapshot.data!.email ?? '';
            return FutureBuilder<bool?>(
              future: UserOperations().isProfileDetails(email: email),
              builder: (context, profileSnapshot) {
                if (profileSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: AnimatedLoader());
                } else if (profileSnapshot.hasData) {
                  if(profileSnapshot.data!){
                    return Home();
                  }else{
                    return CompleteProfileDetailTree(email:email);
                  }
                } else {
                  return CompleteProfileDetailTree(email: email);
                }
              },
            );
          } else {
            return VerifyEmailAddress();
          }
        } else {
          return LaunchPage();
        }
      },
    );
  }
}

