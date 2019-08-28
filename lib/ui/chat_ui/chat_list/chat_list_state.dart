import 'package:deal/entities/chat_entity.dart';
import 'package:deal/ui/chat_ui/chat_screen/chat_state.dart';
import 'package:deal/ui/common/profile_card.dart';
import 'package:deal/utils/values.dart';
import 'package:deal/utils/web_service/chat_webservice.dart';
import 'package:flutter/material.dart';

class ChatListScreen extends StatefulWidget {
  createState() => _ChatListState();
}

class _ChatListState extends State<ChatListScreen> {

  List<ChatEntity> _chats = List();
  bool _isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ChatWebService().getChatList().then((chats) {
      setState(() {
        _isLoading = false;
        _chats.addAll(chats);
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Values.primaryColor,
        title: Text("Chats"),
      ),
      body: Container(
        child: _isLoading ? Center(child: CircularProgressIndicator(),) :
          ListView.builder(itemBuilder: (context, index){
            ChatEntity chat = _chats[index];
            return Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
              child: DetailsProfileCard(isLoading: false, user: chat.user, navigateTo: ChatScreen(product: chat.product, user: chat.user,), createdAt: chat.createdAt, product: chat.product,),
            );
          }, itemCount: _chats.length,),
      ),
    );
  }

}