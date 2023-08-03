import 'package:flutter/material.dart';
import 'package:zola/models/contact_model.dart';
import 'package:zola/services/users.dart' as userService;
import 'package:zola/widgets/contact_item.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  List<ContactModel> chatUsers = [];
  bool _loading = true;
  @override
  void initState() {
    // TODO: implement initState
    userService.getFriend().then((value) {
      setState(() {
        chatUsers = value;
        _loading = false;
      });
    });

    userService.getFriend(refetch: true).then((value) {
      setState(() {
        chatUsers = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (!_loading) {
      if (chatUsers.isNotEmpty) {
        return _buildBody();
      } else {
        return const Center(child: Text('Chưa có bạn bè'));
      }
    } else {
      return const Center(child: Text("Erorr!"));
    }
  }

  _buildBody() {
    return Column(children: <Widget>[
      Expanded(
          child: ListView.builder(
        itemCount: chatUsers.length,
        shrinkWrap: true,
        padding: const EdgeInsets.only(top: 16),
        // physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return ContactItem(
            id: chatUsers[index].id,
            name: chatUsers[index].name,
            imageUrl: chatUsers[index].imageURL,
            username: chatUsers[index].username,
          );
        },
      )),
    ]);
  }
}
