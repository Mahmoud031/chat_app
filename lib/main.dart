import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/screens/chat_page.dart';
import 'package:chat_app/screens/cubits/login_cubit/login_cubit.dart';
import 'package:chat_app/screens/cubits/register_cubit/register_cubit.dart';
import 'package:chat_app/screens/login_page.dart';
import 'package:chat_app/screens/sign_up.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginCubit(),
        ),
        BlocProvider(
          create: (context) => RegisterCubit(),
        ),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          routes: {
            LoginPage.id: (context) => LoginPage(),
            SignUp.id: (context) =>  SignUp(),
            ChatPage.id: (context) => ChatPage()
          },
          initialRoute: LoginPage.id),
    );
  }
}
