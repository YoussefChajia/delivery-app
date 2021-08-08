import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_app/pages/comments.dart';
import 'package:delivery_app/pages/home.dart';
import 'package:delivery_app/widgets/DatabaseService.dart';
import 'package:delivery_app/widgets/ProgressIndicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:numberpicker/numberpicker.dart';


class Details extends StatefulWidget {

  final DocumentSnapshot data;
  final FirebaseUser user;
  const Details({Key key, @required this.data, @required this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DetailsState();
  }
}

class _DetailsState extends State<Details> {

  int quantity = 2;

  bool heart = false;

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
          body: SafeArea(
            child: ListView(
              children: <Widget>[
                Padding(
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
                            MaterialPageRoute(builder: (context) => Home(user: widget.user)),
                          );
                        },
                      ),
                      IconButton(
                        icon: heart ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
                        color: Colors.black,
                        onPressed: () {
                          setState(() => heart = !heart);
                          DatabaseService(uid: widget.user.uid).addFavorites(widget.data.documentID);
                        },
                      ),
                    ],
                  ),
                ),
                CarouselSlider(
                  items: widget.data['images'].map<Widget>((item) => Container(
                    child: Container(
                      margin: EdgeInsets.all(5.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        child: Image.network(item, fit: BoxFit.cover, width: 1000.0),
                      ),
                    ),
                  )).toList(),
                  options: CarouselOptions(
                    autoPlay: true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 5.0),
                  child: Container(
                    child: Text(
                      widget.data['name'],
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'arboria',
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      StarRating(
                        size: 20.0,
                        rating: widget.data['review'],
                        color: Colors.orange,
                        borderColor: Colors.grey,
                        starCount: 5,
                      ),
                      Text(
                        widget.data['price'].toString(),
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'arboria',
                          fontSize: 15.0,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  child: Container(
                    child: Text(
                      widget.data['description'],
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'arboria',
                        fontSize: 15.0,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.5,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    height: 50.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[300],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Quantité : ',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'arboria',
                              fontSize: 17.0,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.5,
                            ),
                          ),
                          NumberPicker.horizontal(
                            initialValue: quantity,
                            minValue: 1,
                            maxValue: 10,
                            step: 1,
                            onChanged: (value) => setState(() => quantity = value),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 100.0),
                  child: Container(
                    width: 200.0,
                    height: 50.0,
                    child: RaisedButton(
                      elevation: 0.0,
                      color: Colors.blue[700],
                      child: Text(
                        "Commentaires",
                        style: TextStyle(
                          fontFamily: 'arboria',
                          fontWeight: FontWeight.w600,
                          fontSize: 17.0,
                          color: Colors.white,
                          letterSpacing: 0.7,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (context) => Comments(data: widget.data, user: widget.user))
                        );
                      },
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ]
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
                onPressed: () {
                  DatabaseService(uid: widget.user.uid).addOrders(widget.data.documentID, quantity);
                }, 
                label: Text('Ajouter au panier',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'arboria',
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 25.0,
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