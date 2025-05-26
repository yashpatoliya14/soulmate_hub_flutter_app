
import 'package:matrimony_flutter/Authentication/widget_tree.dart';
import 'package:matrimony_flutter/Authentication/email.dart';
import 'package:matrimony_flutter/Utils/importFiles.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //logo
              Image.asset("assets/login_signup_tree1.png", width: 100),
              SizedBox(height: 50),

              //Sign in / up to continue
              Text(
                "Sign In to continue",
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 20),

              //continue with email button
              buildButton(
                label: "Continue with email",
                textColor: Colors.white,
                backgroundColor: Colors.purple,
                onPressed: () {
                 Get.to(Email(isSignIn: true),transition: Transition.fade);
                },
              ),
              SizedBox(height: 20),


              SizedBox(height: 20),

              //divider ------------------------pending to seperate component
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Divider(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      "or sign in with",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Divider(),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              // google button
              buildButton(
                label:"Sign in with Google",
                textColor: Colors.black,
                backgroundColor: Colors.white30,
                icon: Image.asset("assets/google_image.jpg", height: 20),
                borderColor: Colors.black,
                onPressed: () async {
                  try {
                    await Auth().signInWithGoogle();

                    
                  Get.offAll(WidgetTree(),transition: Transition.fade);
                  } catch (err) {
                    print(err);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
