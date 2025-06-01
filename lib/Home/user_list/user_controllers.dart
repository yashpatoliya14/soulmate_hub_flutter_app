import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:matrimony_flutter/Home/user_list/user_model.dart';
import 'package:matrimony_flutter/Utils/importFiles.dart';

class UserOperations {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String? docId;
  Future<void> createUser({required UserModel data}) async {

    if(data.toJson()[EMAIL]!=null){
        if(await checkUserByEmail(email: data.toJson()[EMAIL])==true){
          print("USER ALREADY EXISTS");
          return ;
        }
    }

    await _db.collection('users').add(data.toJson());
    print(":::::::data add successful ::::::");
  }

  getUserById(String id) async {
    final result = await FirebaseFirestore.instance
      .collection('users')
      .doc(id)
      .get(); 

      print("${result.data()} :::::: data by id ::: ");
    return result.data();
  }

  Future<void> updateUserByEmail({
    required String email,
    required Map<String, dynamic> updatedData,
  }) async {
    final query = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    if (query.docs.isNotEmpty) {
      // Get the first matching document
      docId = query.docs.first.id;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(docId)
          .set(updatedData,SetOptions(merge: true));

      print('✅ Data updated for: $email');
    } else {
      print('❌ No user found with email: $email');
    }
  }

  Future<bool?> isProfileDetails({required String email}) async {
    final res = await FirebaseFirestore.instance
        .collection('users')
        .where('email',isEqualTo: email)
        .get();

    if(res.docs.isNotEmpty){
        final data=  res.docs.first.data();
        return data['isProfileDetails'];
    }

  }

  Future<String?> checkUnfillDetail({required String email}) async {
    final res = await FirebaseFirestore.instance
        .collection('users')
        .where('email',isEqualTo: email)
        .get();

    if(res.docs.isNotEmpty){
      final data=  res.docs.first.data();
      if(data['name']==null){
        return 'name';
      }else if(data['dob']==null){
        return 'dob';
      }else if(data['gender']==null){
        return 'gender';
      }else if(data['city']==null){
        return 'city';
      }else if(data['hobbies']==null){
        return 'hobbies';
      }else{
        updateUserByEmail(email: email, updatedData: {'isProfileDetails':true});
        return null;
      }
    }else{
      print(":::docs does not found:::");
    }

  }

  Future<Map<String,dynamic>?> getUserByEmail({
    required String email,
  }) async {
    final query = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    if (query.docs.isNotEmpty) {
    // Grab the first matching document
    final docSnap = query.docs.first;

    // Extract its ID…
    final docId = docSnap.id;
    // …and its data map
    final data = docSnap.data();

    // For convenience, you can add the ID into the map
    data[ID] = docId;

    print("Fetched user (ID: $docId): $data");
    return data;
  } else {
    print('No user found with email: $email');
    return null;
  }
  }
  Future<bool?> checkUserByEmail({
    required String email,
  }) async {
    final query = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    if (query.docs.isNotEmpty) {
      // Get the first matching document
      final data = query.docs.first.data() ;

      print("::::::::::::$data");
      return true;
      print('✅ Data get for: $email');
    } else {
      print('❌ No user found with email: $email');
      return false;
    }
  }

Future<List<Map<String,dynamic>>> getAllUsers() async {
    final query = await FirebaseFirestore.instance
        .collection('users')
        .get();

    if (query.docs.isNotEmpty) {
      // Get the first matching document
      final data = query.docs.map(
        (doc){
          final user = doc.data();
          user[ID]=doc.id;
          return user;
          }).toList() ;

      print("::::::::::::$data");
      return data;
    } else {
      print('❌ No user found');
      return [];
    }
  }
  Future<void> deleteAccountByEmail(email) async {
    final query = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    if (query.docs.isNotEmpty) {
    // Grab the first matching document
    final docSnap = query.docs.first;

    // Extract its ID…
    docId = docSnap.id;
    // …and its data map
    final data = docSnap.data();

    await FirebaseFirestore.instance
    .collection('users')
    .doc(docId)
    .delete();
    }
  }

}