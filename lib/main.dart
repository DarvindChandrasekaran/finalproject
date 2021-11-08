import 'package:finalproject/briefpost_info.dart';
import 'package:finalproject/buttons/overall.dart';
import 'package:finalproject/listpost_sum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/io.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/briefpost_info': (context) => const BriefPost(
              url: '',
              name: '',
              title: '',
              description: '',
            ),
      },
      debugShowCheckedModeBanner: false,
      title: 'Final Project',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: BlocProvider(
        create: (context) => Overall(),
        child: const logIn(),
      ),
    );
  }
}

class logIn extends StatefulWidget {
  const logIn({Key? key}) : super(key: key);

  @override
  _logInState createState() => _logInState();
}

class _logInState extends State<logIn> {
  TextEditingController username = TextEditingController();

  final channel =
      IOWebSocketChannel.connect('ws://besquare-demo.herokuapp.com');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.yellow,
        child: Column(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            const Padding(
              padding: EdgeInsets.all(50.0),
              child: Text(
                'ShibaInuArmy',
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.deepOrangeAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                    child: Container(
                      color: Colors.yellow,
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.center,
                        controller: username,
                        decoration: const InputDecoration(
                          hintText: 'Type Your Name Here',
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.orange)),
                    onPressed: () {
                      (username.text.isEmpty)
                          ? {print('Name is not FILLED')}
                          : {
                              context
                                  .read<Overall>()
                                  .login(username.text, channel),
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          ListPost(channel: channel)))
                            };
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
