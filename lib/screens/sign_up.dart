import 'package:chat_app/Helper/show_snack_bar.dart';
import 'package:chat_app/constants.dart';
import 'package:chat_app/screens/chat_page.dart';
import 'package:chat_app/screens/cubits/register_cubit/register_cubit.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SignUp extends StatelessWidget {
  static String id = 'SignUpPage';
  String? email;

  String? password;

  bool isLoading = false;

// this key is working with the form widget
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
         if (state is RegisterLoading) {
          isLoading = true;
        } else if (state is RegisterSuccess) {
          Navigator.pushNamed(context, ChatPage.id);
          isLoading=false;
        } else if (state is RegisterFailure) {
          showSnackBar(context, state.errMessage);
          isLoading=false;
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: isLoading, // show the loading indicator
          child: Scaffold(
            backgroundColor: kPrimaryColor,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Form(
                key:
                    formKey, //give you access to all things to the form (the state of the form)
                child: ListView(
                  children: [
                    const SizedBox(
                      height: 75,
                    ),
                    Image.asset(
                      "assets/images/scholar.png",
                      height: 75,
                    ),
                    const SizedBox(
                      height: 75,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Scholar Chat",
                          style: TextStyle(
                              fontSize: 32,
                              color: Colors.white,
                              fontFamily: 'Pacifico'),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 75,
                    ),
                    const Row(
                      children: [
                        Text(
                          "SignUp",
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomFormTextfield(
                      onChanged: (data) {
                        email = data;
                      },
                      hintText: ' Email',
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomFormTextfield(
                      onChanged: (data) {
                        password = data;
                      },
                      hintText: ' Password',
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomButton(
                      onTap: () async {
                        //make validate to the current state , take the data from the current state to check on it
                        if (formKey.currentState!.validate()) {
                          BlocProvider.of<RegisterCubit>(context)
                              .SigUpMethod(email: email!, password: password!);
                        } else {}
                      },
                      text: 'SignUp',
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have account?  ",
                          style: TextStyle(color: Colors.white),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(color: Color(0xffC7EDE6)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> SigUpMethod() async {
    UserCredential user = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email!, password: password!);
  }
}
