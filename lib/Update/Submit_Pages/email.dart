import 'package:firebase_auth/firebase_auth.dart';
import 'package:matrimony_flutter/Authentication/widget_tree.dart';
import 'package:matrimony_flutter/Utils/importFiles.dart';

class Email extends StatefulWidget {
  bool isSignIn;
  Email({super.key, required this.isSignIn});

  @override
  State<Email> createState() => _EmailState();
}

class _EmailState extends State<Email> {
  //utils
  final GlobalKey<FormState> _formkeyOfEmail = GlobalKey();
  bool? isUserExist;

  //methods
  Future<void> signup() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("email", emailController.text);
      prefs.setString("password", passwordController.text);

      await Auth().signUp(
        email: prefs.getString("email").toString(),
        password: passwordController.text,
      );

      Get.offAll(VerifyEmailAddress(), transition: Transition.fade);
    } on FirebaseAuthException catch (e) {
      String err = '';
      switch (e.code) {
        case 'invalid-email':
          err = 'The email address is not valid.';
          break;
        case 'user-not-found':
          err = 'No user found with this email.';
          break;
        case 'wrong-password':
          err = 'Incorrect password. Please try again.';
          break;
        case 'invalid-credential':
          err = 'Invalid email or password.';
          break;
        case 'email-already-in-use':
          err = 'This email address is already in use.';
          break;
        case 'operation-not-allowed':
          err = 'Sign-in method not allowed.';
          break;
        case 'user-disabled':
          err = 'This user has been disabled.';
          break;
        default:
          err = "An unknown error occurred. Please try again.";
      }
      Get.snackbar("Try again !", err);
    } catch (e) {
      print("Error: $e");
    }
  }

  void signin()  {
    try {
      Auth().signIn(
        email: emailController.text,
        password: passwordController.text,
      );

      Get.offAll(WidgetTree(), transition: Transition.fade);
    } on FirebaseAuthException catch (e) {
      String err = '';
      switch (e.code) {
        case 'invalid-email':
          err = 'The email address is not valid.';
          break;
        case 'user-not-found':
          err = 'No user found with this email.';
          break;
        case 'wrong-password':
          err = 'Incorrect password. Please try again.';
          break;
        case 'invalid-credential':
          err = 'Invalid email or password.';
          break;
        case 'email-already-in-use':
          err = 'This email address is already in use.';
          break;
        case 'operation-not-allowed':
          err = 'Sign-in method not allowed.';
          break;
        case 'user-disabled':
          err = 'This user has been disabled.';
          break;
        default:
          err = "An unknown error occurred. Please try again.";
      }
      Get.snackbar("Try again !", err);
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      top: false,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Form(
            key: _formkeyOfEmail,
            child: Column(
              children: [
                const SizedBox(height: 150),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  child: ListTile(
                    title: Text(
                      "My Email",
                      style: GoogleFonts.nunito(fontSize: 40),
                      textAlign: TextAlign.left,
                    ),
                    subtitle: Text(
                      "Please enter your valid email. We will send you a mail to verify your account.",
                      style: GoogleFonts.nunito(fontSize: 15),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),

                SizedBox(height: 20),

                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  child: getTextFormField(
                    controller: emailController,
                    icon: Iconsax.message,
                    validateFun: validateEmail,
                    label: "Enter your email address",
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  child: getTextFormField(
                    controller: passwordController,
                    label: "Password",
                    errorMsg: passwordError,
                    icon: Iconsax.password_check,
                    hideText: ishidePass!,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          ishidePass = !ishidePass!;
                        });
                      },
                      icon:
                          ishidePass!
                              ? Icon(Iconsax.eye_slash)
                              : Icon(Iconsax.eye),
                    ),
                    validateFun: validatePassword,
                  ),
                ),
                SizedBox(height: 20),
                buildButton(
                  label: "Next",
                  textColor: Colors.white,
                  backgroundColor: Colors.purple,
                  icon: Icon(Iconsax.next, color: Colors.white),
                  onPressed: () {
                    if (_formkeyOfEmail.currentState!.validate()) {
                      if (widget.isSignIn) {
                         signin();
                      } else {
                         signup();
                      }
                    }
                  },
                ),

                SizedBox(height: 20),

                if (!widget.isSignIn)
                  buildButton(
                    label: "Sign up with Google",
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
      ),
    );
  }
}
