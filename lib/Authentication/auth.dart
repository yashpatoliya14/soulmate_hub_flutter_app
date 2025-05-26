import 'dart:convert';
import 'package:matrimony_flutter/Home/user_list/user_controllers.dart';
import 'package:matrimony_flutter/Home/user_list/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class Auth{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  //__________________________________________
  // signin with email and password 
  //__________________________________________

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
  //__________________________________________
  // signup with email and password 
  //__________________________________________


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

  //__________________________________________
  // signout both in firebase and sign out
  //__________________________________________

  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await _firebaseAuth.signOut();
  }

  //__________________________________________
  // signin with google  
  //__________________________________________

  Future<void> signInWithGoogle() async {
    //every time user select email 
    if(await GoogleSignIn().isSignedIn()){

      await GoogleSignIn(scopes: ['email'],
      signInOption: SignInOption.standard,).disconnect();
    }


    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
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