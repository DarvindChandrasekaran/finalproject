import 'dart:convert';
import 'package:finalproject/aboutus.dart';
import 'package:finalproject/briefpost_info.dart';
import 'package:finalproject/newpost_up.dart';
import 'package:finalproject/buttons/overall.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ListPost extends StatefulWidget {
  const ListPost({Key? key, required this.channel}) : super(key: key);
  final WebSocketChannel channel;

  State<StatefulWidget> createState() {
    return _ListPostState(channel);
  }
}

class _ListPostState extends State<ListPost> {
  _ListPostState(this.channel);
  WebSocketChannel channel;
  TextEditingController name = TextEditingController();
  bool isFavorite = false;
  bool favouriteClicked = false;

  List posts = [];
  List favoritePosts = [];

  void getPosts() {
    channel.stream.listen((message) {
      final decodedMessage = jsonDecode(message);
      setState(() {
        posts = decodedMessage['data']['posts'];
        posts.sort((a, b) => b.compareTo(a));
      });
    });

    channel.sink.add('{"type": "get_posts"}');
  }

  @override
  void initState() {
    super.initState();
    getPosts();
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Overall(),
      child: Scaffold(
        drawer: Drawer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 200,
                color: Colors.white,
                child: Image.network(
                    'https://blockworks.co/wp-content/uploads/2021/11/shutterstock_1971532808.png'),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => AboutUs()));
                      },
                      child: const Text('About ShibaInuArmy')),
                ],
              )
            ],
          ),
        ),
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    if (favouriteClicked == true) {
                      favouriteClicked = false;
                    } else {
                      favouriteClicked = true;
                    }
                  });
                },
                icon: const Icon(Icons.favorite_outline_sharp)),
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => NewPost(channel: channel)));
              },
              icon: const Icon(Icons.add),
            ),
            IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return BlocProvider(
                        create: (context) => Overall(),
                        child: BlocBuilder<Overall, String>(
                          builder: (context, state) {
                            return AlertDialog(
                              title: const Text("Information"),
                              content: const Text(
                                  "Hold long on the post to delete it"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Ok"),
                                )
                              ],
                            );
                          },
                        ),
                      );
                    });
              },
              icon: const Icon(Icons.info),
            ),
          ],
          title: const Center(
            child: Text(
              'ShibaInuArmy',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
          backgroundColor: Colors.orange,
        ),
        body: (favouriteClicked == false)
            ? BlocBuilder<Overall, String>(
                builder: (context, index) {
                  print(posts.length);
                  return ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        int reversedIndex = posts.length - 1 - index;
                        return Card(
                          elevation: 10.0,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BriefPost(
                                    name: posts[reversedIndex]['author'],
                                    title: posts[reversedIndex]['title'],
                                    description: posts[reversedIndex]
                                        ['description'],
                                    url: posts[reversedIndex]['image'],
                                  ),
                                ),
                              );
                            },
                            onLongPress: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return BlocProvider(
                                      create: (context) => Overall(),
                                      child: BlocBuilder<Overall, String>(
                                        builder: (context, state) {
                                          return AlertDialog(
                                            title: const Text("Delete Post"),
                                            content: const Text(
                                                "Are you sure to delete this post?"),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    context
                                                        .read<Overall>()
                                                        .delete(
                                                            posts[reversedIndex]
                                                                ['_id'],
                                                            channel);

                                                    Navigator.of(context).pop();
                                                  });
                                                },
                                                child: const Text('Delete'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text("Cancel"),
                                              )
                                            ],
                                          );
                                        },
                                      ),
                                    );
                                  });
                            },
                            child: Container(
                                padding: const EdgeInsets.all(10.0),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(Uri.parse(
                                                    posts[reversedIndex]
                                                        ['image'])
                                                .isAbsolute &&
                                            posts[reversedIndex]
                                                .containsKey('image')
                                        ? '${posts[reversedIndex]['image']}'
                                        : 'http://cdn.onlinewebfonts.com/svg/img_546302.png'),
                                  ),
                                  title: Text(
                                    '${posts[reversedIndex]["title"].toString().characters.take(20)}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                      'Created by ${posts[reversedIndex]["author"].toString().characters.take(15)} on ${posts[reversedIndex]["date"].toString().characters.take(10)}'),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      FavoriteButton(
                                          iconSize: 30.0,
                                          valueChanged: (isFavorite) {
                                            setState(() {
                                              isFavorite = true;
                                              if (favoritePosts.contains(
                                                  posts[reversedIndex])) {
                                                favoritePosts.remove(
                                                    posts[reversedIndex]);
                                                print('item already added');
                                              } else {
                                                favoritePosts
                                                    .add(posts[reversedIndex]);
                                              }
                                              //print(favoritePosts);
                                            });
                                          }),
                                    ],
                                  ),
                                )),
                          ),
                        );
                      });
                },
              )
            : BlocBuilder<Overall, String>(
                builder: (context, state) {
                  return ListView.builder(
                      itemCount: favoritePosts.length,
                      itemBuilder: (context, index) {
                        int reversedIndex = posts.length - 1 - index;
                        return Card(
                          elevation: 10.0,
                          child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BriefPost(
                                      name: posts[reversedIndex]['author'],
                                      title: posts[reversedIndex]['title'],
                                      description: posts[reversedIndex]
                                          ['description'],
                                      url: posts[reversedIndex]['image'],
                                    ),
                                  ),
                                );
                              },
                              onLongPress: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return BlocProvider(
                                        create: (context) => Overall(),
                                        child: BlocBuilder<Overall, String>(
                                          builder: (context, state) {
                                            return AlertDialog(
                                              title: const Text("Delete Post"),
                                              content: const Text(
                                                  "Do you want to delete this post?"),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      context.read().delete(
                                                          posts[reversedIndex]
                                                              ['_id']);

                                                      Navigator.of(context)
                                                          .pop();
                                                    });
                                                  },
                                                  child: const Text('Delete'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text("Cancel"),
                                                )
                                              ],
                                            );
                                          },
                                        ),
                                      );
                                    });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(Uri.parse(
                                                      posts[reversedIndex]
                                                          ['image'])
                                                  .isAbsolute &&
                                              posts[reversedIndex]
                                                  .containsKey('image')
                                          ? '${posts[reversedIndex]['image']}'
                                          : 'https://image.freepik.com/free-vector/bye-bye-cute-emoji-cartoon-character-yellow-backround_106878-540.jpg'),
                                    ),
                                    title: Text(
                                      '${posts[reversedIndex]["title"].toString().characters.take(20)}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                        'Created by ${posts[reversedIndex]["author"].toString().characters.take(15)} on ${posts[reversedIndex]["date"].toString().characters.take(10)}')),
                              )),
                        );
                      });
                },
              ),
      ),
    );
  }
}
