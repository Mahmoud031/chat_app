import 'package:chat_app/constants.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/screens/cubits/chat_cubit/chat_cubit.dart';
import 'package:chat_app/widgets/chat_buble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatPage extends StatelessWidget {
  ChatPage({super.key});
  static String id = 'ChatPage';

  final _controller = ScrollController();
  List<Message> messagesList = [];

  TextEditingController controller =
      TextEditingController(); //create a controller to use it in the textField
  @override
  Widget build(BuildContext context) {
    var email = ModalRoute.of(context)!
        .settings
        .arguments as String; // get the arguments from login page(email)

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, //used to show the back arrow or not
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
            child: BlocBuilder<ChatCubit, ChatState>(
                            builder: (context, state) {
                              var messagesList=BlocProvider.of<ChatCubit>(context).messagesList;
                return ListView.builder(
                    reverse: true,
                    controller: _controller,
                    itemCount: messagesList.length,
                    itemBuilder: (context, index) {
                      return messagesList[index].id == email
                          ? ChatBuble(
                              message: messagesList[index],
                            )
                          : ChatBubleForFriend(message: messagesList[index]);
                    });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller:
                  controller, // associate the controller to the textField
              //recieve the message after submitted it and add to the firestore
              onSubmitted: (data) {
                BlocProvider.of<ChatCubit>(context).sendMessage(message: data, email: email);
                controller
                    .clear(); //clear the message from the textField after sending it

                //used controller to display the end of the chat
                _controller.animateTo(0,
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
  }
}
