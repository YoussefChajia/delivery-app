import 'package:delivery_app/pages/book.dart';
import 'package:delivery_app/pages/details.dart';
import 'package:delivery_app/widgets/ProgressIndicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:search_widget/search_widget.dart';
import 'package:flutter/services.dart';

class Home extends StatefulWidget {
  final FirebaseUser user;
  const Home({Key key, this.user}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return StreamBuilder(
      stream: Firestore.instance.collection('dishes').snapshots(),
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
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
                    child: SearchWidget<DocumentSnapshot>(
                        dataList: snapshot.data.documents,
                        listContainerHeight: (97 * snapshot.data.documents.length).toDouble(),
                        queryBuilder: (String query, List<DocumentSnapshot> list) {
                          if ((query).isEmpty) return null;
                          return list
                              .where((DocumentSnapshot item) =>
                                  item['name'].toLowerCase().contains(query.toLowerCase()))
                              .toList();
                        },
                        popupListItemBuilder: (DocumentSnapshot suggestion) {
                          return GestureDetector(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                              child: Container(
                                height: 80.0,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0), color: Colors.white),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: 80.0,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10.0),
                                        image: DecorationImage(
                                          image: NetworkImage(suggestion['background']),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 5.0),
                                      child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    suggestion['name'],
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontFamily: 'arboria',
                                                      fontSize: 14.0,
                                                      fontWeight: FontWeight.w600,
                                                      letterSpacing: 1,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5.0,
                                                  ),
                                                  Text(
                                                    suggestion['name'],
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontFamily: 'arboria',
                                                      fontSize: 10.0,
                                                      fontWeight: FontWeight.w400,
                                                      letterSpacing: 1,
                                                    ),
                                                  ),
                                                ]),
                                            StarRating(
                                              size: 12.0,
                                              rating: 3.5,
                                              color: Colors.orange,
                                              borderColor: Colors.grey,
                                              starCount: 5,
                                            ),
                                          ]),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        textFieldBuilder: (TextEditingController controller, FocusNode focusNode) {
                          return TextField(
                            controller: controller,
                            focusNode: focusNode,
                            style: TextStyle(
                              fontFamily: 'arboria',
                              fontWeight: FontWeight.w300,
                              fontSize: 17.0,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 30.0),
                              hintText: 'Rechercher',
                              hintStyle: TextStyle(
                                  fontFamily: 'arboria',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17.0,
                                  letterSpacing: 0.7,
                                  color: Color(0xffa0a0a0)),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                          );
                        },
                        onItemSelected: (item) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Details(data: item, user: widget.user)));
                        },
                        selectedItemBuilder: (DocumentSnapshot selectedItem, deleteSelectedItem) {
                          return null;
                        }),
                  ),
                  Container(
                    height: 270.0,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    width: 250.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            snapshot.data.documents[index]['background']),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 250.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      gradient: LinearGradient(
                                        colors: [Colors.black, Colors.transparent],
                                        begin: Alignment(1.0, 1.0),
                                        end: Alignment(1.0, -0.2),
                                      ),
                                    ),
                                  ),
                                  /* Positioned(
                                  top: 0.0,
                                  right: 0.0,
                                  child: IconButton(
                                    icon: Icon(Icons.favorite_border),
                                    color: Colors.white,
                                    onPressed: () {},
                                  ),
                                ), */
                                  Positioned(
                                    left: 15.0,
                                    bottom: 15.0,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          snapshot.data.documents[index]['name'],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'arboria',
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 3.0,
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.monetization_on,
                                              color: Colors.white,
                                              size: 13.0,
                                            ),
                                            SizedBox(
                                              width: 5.0,
                                            ),
                                            Text(
                                              snapshot.data.documents[index]['price'].toString(),
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'arboria',
                                                fontSize: 13.0,
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 1,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Details(
                                          data: snapshot.data.documents[index],
                                          user: widget.user)));
                            },
                          );
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      height: 60.0,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 0.0,
                        color: Color(0xffFF6060),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Book(user: widget.user)));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Reserver une Table',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'arboria',
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1,
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 25.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      child: Text(
                        'Plat du jour',
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
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          height: 200.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            image: DecorationImage(
                              image: AssetImage('assets/images/burger.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          height: 200.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            gradient: LinearGradient(
                              colors: [Colors.black, Colors.transparent],
                              begin: Alignment(1.0, 1.0),
                              end: Alignment(1.0, -0.2),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 15.0,
                          bottom: 15.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Burgers with patty',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'arboria',
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1,
                                ),
                              ),
                              SizedBox(
                                height: 3.0,
                              ),
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.monetization_on,
                                    color: Colors.white,
                                    size: 13.0,
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Text(
                                    '150',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'arboria',
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
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
