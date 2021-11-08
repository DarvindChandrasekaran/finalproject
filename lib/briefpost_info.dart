import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BriefPost extends StatelessWidget {
  const BriefPost({
    Key? key,
    required this.title,
    required this.description,
    required this.url,
    required this.name,
  }) : super(key: key);

  final String title;
  final String description;
  final String url;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        'ShibaInuArmy',
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      )),
      body: ListView(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 30, left: 20, right: 20, bottom: 10),
                child: Image(
                  image: NetworkImage(Uri.parse(url).isAbsolute
                      ? url
                      : 'http://cdn.onlinewebfonts.com/svg/img_546302.png'),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 20.0, left: 20.0, right: 20),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 30,
                    color: Colors.deepOrangeAccent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 20.0, left: 20.0, right: 20),
                child: Flexible(
                  child: Text(
                    description,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
