import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_app/pages/details.dart';
import 'package:delivery_app/widgets/DatabaseService.dart';
import 'package:delivery_app/widgets/ProgressIndicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Comments extends StatefulWidget {
  final DocumentSnapshot data;
  final FirebaseUser user;
  const Comments({Key key, @required this.data, @required this.user}) : super(key: key);

  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  final comment = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return StreamBuilder(
      stream: Firestore.instance.collection('dishes').document(widget.data.documentID).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return ProgressDialogPrimary();
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Color(0xffDEDFE2),
          body: SafeArea(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              child: Column(
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.arrow_back),
                            color: Colors.black,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Details(data: widget.data, user: widget.user)),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 14,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data['comments'].length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    /* Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        'Youssef',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'arboria',
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.8,
                                        ),
                                      ),
                                      StarRating(
                                        size: 16.0,
                                        rating: 4.5,
                                        color: Colors.orange,
                                        borderColor: Colors.grey,
                                        starCount: 5,
                                      ),
                                    ]
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ), */
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                      child: Text(
                                        snapshot.data['comments'][index],
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'arboria',
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w400,
                                          letterSpacing: 0.5,
                                        ),
                                        textAlign: TextAlign.justify,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    Divider(
                                      color: Colors.grey,
                                      height: 1,
                                      thickness: 1,
                                      indent: 50.0,
                                      endIndent: 50.0,
                                    ),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              controller: comment,
                              style: TextStyle(
                                fontFamily: 'arboria',
                                fontWeight: FontWeight.normal,
                                fontSize: 17.0,
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 30.0),
                                hintText: 'commentaire',
                                hintStyle: TextStyle(
                                    fontFamily: 'arboria',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 17.0,
                                    letterSpacing: 0.4,
                                    color: Color(0xffa0a0a0)),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blue[700],
                                borderRadius: new BorderRadius.circular(10.0),
                              ),
                              child: IconButton(
                                icon: Icon(Icons.send),
                                color: Colors.white,
                                onPressed: () {
                                  DatabaseService(uid: widget.user.uid)
                                      .addComment(widget.data.documentID, comment.text);
                                  comment.clear();
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
