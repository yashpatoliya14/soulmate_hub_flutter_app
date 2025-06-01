import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:matrimony_flutter/Home/user_list/user_controllers.dart';
import 'package:matrimony_flutter/Chat/chat_services.dart';
import 'package:matrimony_flutter/Utils/importFiles.dart';

class ChatScreen extends StatefulWidget {
  final String receiverId;
  final String receiverName;

  const ChatScreen({
    Key? key,
    required this.receiverId,
    required this.receiverName,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatService _chatService = ChatService();
  final TextEditingController _controller = TextEditingController();

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _chatService.sendMessage(widget.receiverId, text);
    _controller.clear();
  }

  Future<String> _getUserId() async {
    UserOperations userOperations = UserOperations();
    final userData = await userOperations.getUserByEmail(
      email: Auth().currentUser!.email.toString(),
    );
    return userData![ID];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Chat with ${widget.receiverName}',),
          actions: [
            IconButton(onPressed: (){
              showDialog(context: context, builder:(context){
                return CupertinoAlertDialog(
                  title: Text("Delete chat"),
                  actions: [
                    TextButton(onPressed: (){
                      Navigator.pop(context);
                    }, child:Text("Cancel"),style: ButtonStyle(splashFactory: NoSplash.splashFactory),),
                    TextButton(onPressed: () async {
                      ChatService chatService = ChatService();
                      await chatService.deleteMessages(widget.receiverId);
                      setState(() {
                        Navigator.pop(context);
                        
                      });
                    }, child:Text("Confirm"),style: ButtonStyle(splashFactory: NoSplash.splashFactory),)
                  ],
                );
              });
            }, icon: Icon(Iconsax.message_remove),color: Colors.redAccent,)
          ],
          ),
        
        
        body: Column(
          children: [
        
            // Messages list
            Expanded(
              child: FutureBuilder<String>(
        
                future: _getUserId(),
        
                builder: (context, snapshot) {
            
                  if (ConnectionState.waiting == snapshot.connectionState) {
                    return const Center(child: CircularProgressIndicator());
                  }
            
                  final userId = snapshot.data;

                  //call get message for sender and receiver messages
                  return FutureBuilder<Stream<QuerySnapshot>>(
                    future: _chatService.getMessages(widget.receiverId),
                    
                    builder: (context, futureSnapshot) {
                      if (!futureSnapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      // Now build StreamBuilder inside
                      return StreamBuilder<QuerySnapshot>(
                        
                        stream: futureSnapshot.data!,
                        
                        builder: (context, streamSnapshot) {
                          if (streamSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (!streamSnapshot.hasData ||
                              streamSnapshot.data!.docs.isEmpty) {
                            return const Center(child: Text("No messages yet"));
                          }

                          final docs = streamSnapshot.data!.docs;
                          return ListView.builder(
                            reverse: true,
                            itemCount: docs.length,
                            itemBuilder: (context, index) {
                              final data =
                                  docs[index].data() as Map<String, dynamic>;
                              final isMe = data['senderId'] == userId;
                              return Align(
                                alignment:
                                    isMe
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color:
                                        isMe
                                            ? Colors.blue[200]
                                            : Colors.grey[300],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(data['text']),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
            // Input field
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _controller,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(20),
                        labelText: "Send Message",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          borderSide: BorderSide(color: Colors.black12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          borderSide: BorderSide(color: Colors.purple),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Icon(
                            Iconsax.message,
                            size: 25,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Iconsax.send_1),
                    onPressed: _send,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
