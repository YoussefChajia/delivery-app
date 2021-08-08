import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_app/pages/details.dart';
import 'package:delivery_app/widgets/DatabaseService.dart';
import 'package:delivery_app/widgets/ProgressIndicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating/flutter_rating.dart';

class Orders extends StatefulWidget {
  final FirebaseUser user;
  const Orders({Key key, this.user}) : super(key: key);

  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return StreamBuilder(
      stream: Firestore.instance
          .collection('dishes')
          .where("orders", arrayContains: widget.user.uid)
          .snapshots(),
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
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            height: 120.0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0), color: Colors.white),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: 100.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          snapshot.data.documents[index]['background']),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Row(children: <Widget>[
                                                  Container(
                                                    height: 20.0,
                                                    width: 20.0,
                                                    decoration: BoxDecoration(
                                                      color: Colors.black,
                                                      borderRadius: BorderRadius.circular(5.0),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        '2',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily: 'arboria',
                                                          fontSize: 12.0,
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 5.0,
                                                  ),
                                                  Text(
                                                    snapshot.data.documents[index]['name'],
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontFamily: 'arboria',
                                                      fontSize: 14.0,
                                                      fontWeight: FontWeight.w600,
                                                      letterSpacing: 1,
                                                    ),
                                                  ),
                                                ]),
                                                SizedBox(
                                                  height: 7.0,
                                                ),
                                                Text(
                                                  snapshot.data.documents[index]['name'],
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: 'arboria',
                                                    fontSize: 10.0,
                                                    fontWeight: FontWeight.w400,
                                                    letterSpacing: 1,
                                                  ),
                                                ),
                                              ]),
                                          Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                StarRating(
                                                  size: 15.0,
                                                  rating: 3.5,
                                                  color: Colors.orange,
                                                  borderColor: Colors.grey,
                                                  starCount: 5,
                                                ),
                                                FlatButton(
                                                  materialTapTargetSize:
                                                      MaterialTapTargetSize.shrinkWrap,
                                                  onPressed: () {
                                                    DatabaseService(uid: widget.user.uid)
                                                        .removeOrders(snapshot
                                                            .data.documents[index].documentID);
                                                  },
                                                  child: Text(
                                                    'supprimer',
                                                    style: TextStyle(
                                                      color: Colors.red[400],
                                                      fontFamily: 'arboria',
                                                      fontSize: 13.0,
                                                      fontWeight: FontWeight.w400,
                                                      letterSpacing: 1,
                                                    ),
                                                  ),
                                                ),
                                              ]),
                                        ]),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Details(
                                    data: snapshot.data.documents[index], user: widget.user)),
                          );
                        },
                      );
                    }),
              ),
            ),
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              width: double.infinity,
              child: FloatingActionButton.extended(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                backgroundColor: Color(0xff40D47B),
                onPressed: () {},
                label: Text(
                  'Payer tous',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'arboria',
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
                icon: Icon(
                  Icons.monetization_on,
                  color: Colors.white,
                  size: 20.0,
                ),
              ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }
}
