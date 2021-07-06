import 'package:flutter/material.dart';
import 'package:http_demo/blocs/user_bloc.dart';
import 'package:http_demo/models/user.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  var users = <User>[];
  final bloc = UserBloc();

  @override
  void initState() {
    bloc.getUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User List"),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return StreamBuilder<List<User>>(
      stream: bloc.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final users = snapshot.data!;
          return Container(
            child: ListView.builder(
              itemBuilder: (ctx, index) {
                return buildItem(users[index]);
              },
              itemCount: users.length,
            ),
          );
        }
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        
        return CircularProgressIndicator();
      },
    );
  }

  Widget buildItem(User user) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          buildAvatar(user.avatar ?? ""),
          SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.name ?? "",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 4),
              Text(
                user.createdDate ?? "",
                style: TextStyle(color: Colors.grey[400]),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget buildAvatar(String url) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(500),
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.yellow,
        ),
        child: Image.network(url, fit: BoxFit.cover),
      ),
    );
  }
}
