import 'package:matrimony_flutter/Update/Submit_Pages/email.dart';
import 'package:matrimony_flutter/Utils/importFiles.dart';

class Mobile extends StatefulWidget {
  const Mobile({super.key});

  @override
  State<Mobile> createState() => _MobileState();
}

class _MobileState extends State<Mobile> {
  final GlobalKey<FormState> _formkeyOfMobile = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formkeyOfMobile,
        child: Column(
          children: [
            SizedBox(height: 150),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: ListTile(
                title: Text(
                  "My Mobile",
                  style: GoogleFonts.nunito(fontSize: 40),
                  textAlign: TextAlign.left,
                ),
                subtitle: Text(
                  "Please enter your valid mobile number.",
                  style: GoogleFonts.nunito(fontSize: 15),
                  textAlign: TextAlign.left,
                ),
              ),
            ),

            SizedBox(height: 20),

            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              child: getTextFormField(
                controller: mobileController,
                icon: Iconsax.mobile,
                validateFun: validateMobile,
                label: "Enter your mobile no.",
                keyboardType: TextInputType.phone,
                errorMsg: mobileError,
                inputFormator: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                onChanged: () {
                  if (_formkeyOfMobile.currentState?.validate() ?? true) {
                    isDisplayFloatButton = true;
                    setState(() {});
                  } else {
                    isDisplayFloatButton = false;
                    setState(() {});
                  }
                },
              ),
            ),
            buildButton(
              label: "Next",
              textColor: Colors.white,
              backgroundColor: Colors.purple,
              icon: Icon(Iconsax.next, color: Colors.white),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();

                prefs.setInt("mobile", int.parse(mobileController.text));
                Navigator.push(
                  context,
                    PageRouteBuilder(
                        pageBuilder: (context,animation,secondaryAnimation) => Email(isSignIn: false,),
                        transitionsBuilder:(context,animation,secondaryAnimation,child){
                          return FadeTransition(
                              child:child,
                              opacity:animation
                          );
                        }
                    )
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
