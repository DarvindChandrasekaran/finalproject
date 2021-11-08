import 'package:finalproject/buttons/overall.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class NewPost extends StatefulWidget {
  const NewPost({Key? key, required this.channel}) : super(key: key);
  final WebSocketChannel channel;

  State<StatefulWidget> createState() {
    return _NewPost(channel);
  }
}

class _NewPost extends State<NewPost> {
  _NewPost(this.channel);
  WebSocketChannel channel;
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController image = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Overall(),
      child: BlocBuilder<Overall, String>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'New Post',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
            body: ListView(children: [
              Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, right: 8.0, top: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Title',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        fontStyle: FontStyle.italic,
                        color: Colors.deepOrangeAccent,
                      ),
                    ),
                    TextFormField(
                      controller: title,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Your Title',
                      ),
                    ),
                    const Divider(
                      height: 40.0,
                    ),
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        fontStyle: FontStyle.italic,
                        color: Colors.deepOrangeAccent,
                      ),
                    ),
                    TextFormField(
                      maxLines: 2,
                      controller: description,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Your Description',
                      ),
                    ),
                    const Divider(
                      height: 40.0,
                    ),
                    const Text(
                      'Image URL',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        fontStyle: FontStyle.italic,
                        color: Colors.deepOrangeAccent,
                      ),
                    ),
                    TextFormField(
                      controller: image,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'The Image URL',
                      ),
                    ),
                    const Divider(
                      height: 40.0,
                    ),
                    const Divider(
                      height: 20.0,
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      context.read<Overall>().createPost(
                          title.text, description.text, image.text, channel);

                      Navigator.pop(context);
                    },
                    child: const Text('Create'),
                  ),
                ],
              )
            ]),
          );
        },
      ),
    );
  }
}
