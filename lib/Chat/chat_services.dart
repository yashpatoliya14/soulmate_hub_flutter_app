import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:matrimony_flutter/Home/user_list/user_controllers.dart';
import 'package:matrimony_flutter/Utils/importFiles.dart';

class ChatService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// Generates a consistent chat ID for two users.
  String getChatId(String uid1, String uid2) {
    return uid1.compareTo(uid2) <= 0 ? '$uid1\_$uid2' : '$uid2\_$uid1';
  }

  /// Sends a text message to [receiverId].
  Future<void> sendMessage(String receiverId, String text) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    UserOperations userOperations = UserOperations();
    final userData =await userOperations.getUserByEmail(email: prefs.getString(EMAIL).toString());
    final senderId = userData![ID];
    final chatId = getChatId(senderId, receiverId);
    print("::::receiverID $receiverId");
    print("::::senderID $senderId");
    print("::::chatID $chatId");
    print("::::chatID ${auth.currentUser!.email}");
    await firestore
      .collection('messages')
      .doc(chatId)
      .collection('chats')
      .add({
        'senderId': senderId,
        'receiverId': receiverId,
        'text': text,
        'timestamp': FieldValue.serverTimestamp(),
      });
  }

  /// Streams all messages for the chat with [receiverId], ordered by time.
  Future<Stream<QuerySnapshot<Object>>>? getMessages(String receiverId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    UserOperations userOperations = UserOperations();
    final userData =await userOperations.getUserByEmail(email: prefs.getString(EMAIL).toString());
    final userId = userData![ID];
    final chatId = getChatId(userId, receiverId);
    print("::::receiverID $receiverId");
    print("::::userID $userId");
    print("::::chatID $chatId");
    print("::::chatID ${auth.currentUser!.email}");

    return firestore
      .collection('messages')
      .doc(chatId)
      .collection('chats')
      .orderBy('timestamp', descending: true)
      .snapshots();
  }
  Future<void> deleteMessages(String receiverId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    UserOperations userOperations = UserOperations();
    final userData =await userOperations.getUserByEmail(email: prefs.getString(EMAIL).toString());
    final userId = userData![ID];
    final chatId = getChatId(userId, receiverId);
    final chatRef = FirebaseFirestore.instance
      .collection('messages')
      .doc(chatId)
      .collection('chats');

    final snapshot = await chatRef.get();

    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }
}