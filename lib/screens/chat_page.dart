import 'package:chat_app/constants.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/widgets/chat_buble.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatPage extends StatelessWidget {
  ChatPage({super.key});
  static String id = 'ChatPage';

  final _controller = ScrollController();


  // Create a CollectionReference called messages that references the firestore collection
  CollectionReference messages =
      FirebaseFirestore.instance.collection(KMessageCollections);
  TextEditingController controller =
      TextEditingController(); //create a controller to use it in the textField
  @override
  Widget build(BuildContext context) {
    var email = ModalRoute.of(context)!.settings.arguments; // get the arguments from login page(email)
    return StreamBuilder<QuerySnapshot>(
      // access Streams that change the UI in every new data
      stream:
          messages.orderBy(kCreatedAt, descending: true).snapshots(), // get a stream of snapshots
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Message> messagesList = [];
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            messagesList.add(Message.fromJson(snapshot.data!.docs[i]));
          }
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading:
                  false, //used to show the back arrow or not
              backgroundColor: kPrimaryColor,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    kLogo,
                    height: 50,
                  ),
                  const Text('Chat'),
                ],
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                      controller: _controller,
                      itemCount: messagesList.length,
                      itemBuilder: (context, index) {
                        return  messagesList[index].id == email ? ChatBuble(
                          message: messagesList[index],
                        ) : ChatBubleForFriend(message: messagesList[index]);
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller:
                        controller, // associate the controller to the textField
                    //recieve the message after submitted it and add to the firestore
                    onSubmitted: (data) {
                      messages
                          .add({kMessage: data, kCreatedAt: DateTime.now(),'id' : email });
                      controller
                          .clear(); //clear the message from the textField after sending it
                      
                      //used controller to display the end of the chat
                      _controller.animateTo(
                          0,
                          duration: const Duration(seconds: 1),
                          curve: Curves.fastOutSlowIn); // the shape of movement
                    },
                    decoration: InputDecoration(
                      hintText: 'Send Message',
                      suffixIcon: const Icon(
                        Icons.send,
                        color: kPrimaryColor,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: kPrimaryColor),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        } else {
          return const Text('Loading...');
        }
      },
    );
  }
}
