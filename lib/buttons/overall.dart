import 'package:flutter_bloc/flutter_bloc.dart';

class Overall extends Cubit<String> {
  Overall() : super('');
  List posts = [];
  dynamic decodedMessage;

  void login(name, channel) {
    channel.sink.add('{"type": "sign_in", "data": {"Name": "$name"}}');
  }

  void delete(_id, channel) {
    channel.sink.add('{"type": "delete_post", "data": {"postId": "$_id"}}');
  }

  void createPost(title, description, url, channel) {
    channel.sink.add(
        '{"type": "create_post", "data": {"title": "$title", "description": "$description", "image": "$url"}}');
  }

  String getName() {
    return state;
  }
}
