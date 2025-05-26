import 'package:firebase_auth/firebase_auth.dart';
import 'package:matrimony_flutter/Home/user_list/user_controllers.dart';
import 'package:matrimony_flutter/Home/user_list/user_model.dart';
import 'package:matrimony_flutter/Update/Submit_Pages/name_profilephoto.dart';
import 'package:matrimony_flutter/Utils/importFiles.dart';

class VerifyEmailAddress extends StatefulWidget {
  const VerifyEmailAddress({super.key});

  @override
  State<VerifyEmailAddress> createState() => _VerifyEmailAddressState();
}

class _VerifyEmailAddressState extends State<VerifyEmailAddress> {
  @override
  void initState() {
    super.initState();

    sendForVerifyEmail();
  }

  Future<void> sendForVerifyEmail() async {
    await FirebaseAuth.instance.currentUser!.sendEmailVerification().then((
      value,
    ) {
      SnackBar(content: Text("Successful"));
    });
  }

  void reload() async {
    User? user = FirebaseAuth.instance.currentUser;

    await user?.reload();
    user = FirebaseAuth.instance.currentUser;

    if (user != null && user.emailVerified) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("email",user.email.toString());
      UserModel userModel = UserModel(ISVERIFIED: true,ISPROFILEDETAILS: false);
      UserOperations userOperations = UserOperations();
      userOperations.updateUserByEmail(
        updatedData: userModel.toJson(),
        email: user.email.toString(),
      );
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => NameProfilephoto(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(child: child, opacity: animation);
          },
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Email not verified yet. Please check your inbox."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 150),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: ListTile(
              title: Text(
                "Verify Email Address",
                style: GoogleFonts.nunito(fontSize: 40),
                textAlign: TextAlign.left,
              ),
              subtitle: Text(
                "Verification link sent to email box",
                style: GoogleFonts.nunito(fontSize: 20),
                textAlign: TextAlign.left,
              ),
            ),
          ),

          SizedBox(height: 20),
        ],
      ),
      floatingActionButton: IconButton(
        onPressed: () {
          reload();
        },
        icon: Icon(Iconsax.refresh),
      ),
    );
  }
}
