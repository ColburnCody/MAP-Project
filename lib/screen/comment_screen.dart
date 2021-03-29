import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/controller/firebasecontroller.dart';
import 'package:lesson3/model/comment.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/screen/myview/mydialog.dart';

class CommentScreen extends StatefulWidget {
  static const routeName = '/commentScreen';
  @override
  State<StatefulWidget> createState() {
    return _CommentState();
  }
}

class _CommentState extends State<CommentScreen> {
  _Controller con;
  User user;
  String progressMessage;
  List<Comment> comments;
  @override
  void initState() {
    con = _Controller(this);
    super.initState();
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;
    user ??= args[Constant.ARG_USER];
    return Scaffold(
      appBar: AppBar(
        title: Text('Comment Screen'),
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                height: 60,
                width: double.infinity,
                color: Colors.green,
                child: Row(
                  children: [
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Leave a comment...',
                          hintStyle: TextStyle(color: Colors.black),
                          border: InputBorder.none,
                        ),
                        onSubmitted: (val) async {
                          con.saveComment(val);
                          con.saveUser();
                          con.addComment();
                          ListView.builder(
                            itemCount: comments.length,
                            itemBuilder: (BuildContext context, int index) => Container(
                              child: ListTile(
                                title: Text('${comments[index].userName}'),
                                subtitle: Text('${comments[index].messageContent}'),
                              ),
                            ),
                          );
                          render(() {});
                        },
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Controller {
  _CommentState state;
  _Controller(this.state);
  Comment tempComment = Comment();

  void clear() {}
  void saveUser() {
    tempComment.userName = state.user.uid;
  }

  void saveComment(String comment) {
    tempComment.messageContent = comment;
  }

  void addComment() {
    state.comments.add(tempComment);
  }

  Widget postComment(BuildContext context, int index) {
    return Card(
      margin: EdgeInsets.all(16.0),
      color: Colors.green,
      elevation: 15.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: ListTile(
        title: Text('${state.comments[index].userName}'),
        subtitle: Text('${state.comments[index].messageContent}'),
      ),
    );
  }
}
