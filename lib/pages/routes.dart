import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:delivery_app/pages/orders.dart';
import 'package:delivery_app/pages/home.dart';
import 'package:delivery_app/pages/favorites.dart';
import 'package:delivery_app/pages/profile.dart';
import 'package:flutter/services.dart';

class Routes extends StatefulWidget {

  final FirebaseUser user;
  const Routes({Key key, this.user}) : super(key: key);

  @override
  _RoutesState createState() => _RoutesState();
}

class _RoutesState extends State<Routes> {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        color: Colors.red,
        home: DefaultTabController(
          length: 4,
            child: new Scaffold(
            body: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                MaterialApp(home: Home(user: widget.user), debugShowCheckedModeBanner: false,),
                MaterialApp(home: Orders(user: widget.user), debugShowCheckedModeBanner: false,),
                MaterialApp(home: Favorites(user: widget.user), debugShowCheckedModeBanner: false,),
                MaterialApp(home: Profile(user: widget.user), debugShowCheckedModeBanner: false,),
            ],
            ),
            bottomNavigationBar: new TabBar(
              tabs: [
                SizedBox(height:60, child: Tab(icon: new Icon(Icons.home, size: 25,))),
                SizedBox(height:60, child: Tab(icon: new Icon(Icons.assignment, size: 25,))),
                SizedBox(height:60, child: Tab(icon: new Icon(Icons.favorite, size: 25,))),
                SizedBox(height:60, child: Tab(icon: new Icon(Icons.person, size: 25,)))
              ],
              labelColor: Colors.white,
              unselectedLabelColor: Colors.blue[400],
              indicatorPadding: EdgeInsets.all(5.0),
              indicatorColor: Colors.transparent,
            ),
            backgroundColor: Colors.blue[700],
          ),
        ),
      ),
    );
  }
}