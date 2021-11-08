import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: AboutUs()));
}

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.orange,
            title: const Text('About Us'),
          ),
          body: Center(
            child: Column(
              children: const [
                Image(
                    image: NetworkImage(
                        'https://images.mktw.net/im-402743?width=700&height=487')),
                Divider(
                  height: 40.0,
                ),
                Text(
                  'ShibaInu Army is one of a kind',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.deepOrangeAccent,
                  ),
                  textAlign: TextAlign.center,
                ),
                Divider(
                  height: 20.0,
                ),
                Text(
                  'We allow users to make discussion on cryptos. Try to share you understanding here and Also learn at the same time. Lets make the world a better place. ',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                Divider(
                  height: 40.0,
                ),
                Text(
                  'Join Us',
                  style: TextStyle(
                    fontSize: 40,
                    color: Colors.deepOrangeAccent,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Let us be the First',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.deepOrangeAccent,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )),
    );
  }
}
