import 'package:matrimony_flutter/Utils/importFiles.dart';


class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  
    TextEditingController controllerEmail = TextEditingController();
    final GlobalKey<FormState> _formkeyForForgot = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          MediaQuery.of(context).size.height * 0.08,
        ),
        child: getAppBar(context, name: "Reset Password"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formkeyForForgot,
          child: SingleChildScrollView(
            child: Column(
              children: [
                getTextFormField(
                  label: "Email",
                  controller: controllerEmail,
                  icon: Iconsax.message,
                  validateFun: validateEmail,
                  errorMsg: emailError,
                  keyboardType: TextInputType.emailAddress

                ),
                SizedBox(
                  width: 20,
                  height: 20,
                ),
                ElevatedButton(onPressed: () async {
                    
                    if(_formkeyForForgot.currentState!.validate()){
                      
                    }
                }, child: Text("Reset"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
