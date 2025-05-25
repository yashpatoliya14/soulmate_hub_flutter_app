import 'dart:convert';
import 'package:matrimony_flutter/Home/user_list/user_controllers.dart';
import 'package:matrimony_flutter/Home/user_list/user_model.dart';
import 'package:matrimony_flutter/Userform/EditForm/form_utils.dart';
import 'package:matrimony_flutter/Authentication/standard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
class Auth{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signIn({
    required String email,
    required String password
  })async{
    try{
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<void> sendBackendRequestToCreateUser(String? idToken, String email, [String? password]) async {
    final url = Uri.parse("http://192.168.51.147:3000/api/firebase-login");
    print("Requesting: $url");

    final body = {
      'email': email,
    };

    if (password != null) {
      body['password'] = password;
    }

    if (idToken == null) {
      print("No ID token available");
      return;
    }

    final res = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken', // ✅ Important!
      },
      body: jsonEncode(body),
    );

    if (res.statusCode == 200) {
      print("Backend response: ${res.body}");
    } else {
      print("Backend error: ${res.statusCode} - ${res.body}");
    }
  }


  Future<bool?> signUp({required String email, required String password})async{

    try{
      UserModel userModel = UserModel(EMAIL:email,PASSWORD: password);
      UserOperations userOperations = UserOperations();
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );

      //create user into database
      userOperations.createUser(data: userModel);
    } on FirebaseAuthException {
      rethrow;
    }
  }
  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await _firebaseAuth.signOut();
  }

  Future<void> signInWithGoogle() async {
    if(await GoogleSignIn().isSignedIn()){

      await GoogleSignIn(scopes: ['email'],
      signInOption: SignInOption.standard,).disconnect();
    }
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("email", googleUser.email.toString());
    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken
    );
    await FirebaseAuth.instance.signInWithCredential(credential);
    UserModel userModel = UserModel(EMAIL:googleUser.email,ISPROFILEDETAILS: false);
    UserOperations userOperations = UserOperations();
    //create user into database
    userOperations.createUser(data: userModel);
  }
  

}