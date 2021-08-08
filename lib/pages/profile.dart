import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_app/pages/signin.dart';
import 'package:delivery_app/widgets/DatabaseService.dart';
import 'package:delivery_app/widgets/ProgressIndicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Profile extends StatefulWidget {
  final FirebaseUser user;
  const Profile({Key key, this.user}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final address = TextEditingController();

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return StreamBuilder(
      stream: Firestore.instance.collection('users').document(widget.user.uid).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return ProgressDialogPrimary();
        firstName.text = snapshot.data['firstname'];
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Color(0xffDEDFE2),
          body: SafeArea(
            child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                },
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ListView(children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: TextField(
                        controller: email,
                        style: TextStyle(
                          fontFamily: 'arboria',
                          fontWeight: FontWeight.bold,
                          fontSize: 17.0,
                          letterSpacing: 0.7,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 30.0),
                          hintText: widget.user.email,
                          hintStyle: TextStyle(
                              fontFamily: 'arboria',
                              fontWeight: FontWeight.bold,
                              fontSize: 17.0,
                              letterSpacing: 0.7,
                              color: Colors.black),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: TextField(
                        controller: firstName,
                        style: TextStyle(
                          fontFamily: 'arboria',
                          fontWeight: FontWeight.bold,
                          fontSize: 17.0,
                          letterSpacing: 0.7,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 30.0),
                          hintText: snapshot.data['firstname'] == ''
                              ? 'Prénom'
                              : snapshot.data['firstname'],
                          hintStyle: TextStyle(
                              fontFamily: 'arboria',
                              fontWeight: FontWeight.bold,
                              fontSize: 17.0,
                              letterSpacing: 0.7,
                              color: snapshot.data['firstname'] == ''
                                  ? Color(0xffa0a0a0)
                                  : Colors.black),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: TextField(
                        controller: lastName,
                        style: TextStyle(
                          fontFamily: 'arboria',
                          fontWeight: FontWeight.bold,
                          fontSize: 17.0,
                          letterSpacing: 0.7,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 30.0),
                          hintText:
                              snapshot.data['lastname'] == '' ? 'Nom ' : snapshot.data['lastname'],
                          hintStyle: TextStyle(
                              fontFamily: 'arboria',
                              fontWeight: FontWeight.bold,
                              fontSize: 17.0,
                              letterSpacing: 0.7,
                              color: snapshot.data['lastname'] == ''
                                  ? Color(0xffa0a0a0)
                                  : Colors.black),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: TextField(
                        controller: address,
                        style: TextStyle(
                          fontFamily: 'arboria',
                          fontWeight: FontWeight.bold,
                          fontSize: 17.0,
                          letterSpacing: 0.7,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 30.0),
                          hintText:
                              snapshot.data['address'] == '' ? 'Adresse' : snapshot.data['address'],
                          hintStyle: TextStyle(
                              fontFamily: 'arboria',
                              fontWeight: FontWeight.bold,
                              fontSize: 17.0,
                              letterSpacing: 0.7,
                              color: snapshot.data['address'] == ''
                                  ? Color(0xffa0a0a0)
                                  : Colors.black),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Container(
                        height: 50.0,
                        child: RaisedButton(
                          elevation: 0.0,
                          color: Colors.blue,
                          onPressed: () {
                            DatabaseService(uid: widget.user.uid)
                                .updateUserData(firstName.text, lastName.text, address.text);
                          },
                          child: Text(
                            'Modifier',
                            style: TextStyle(
                              fontFamily: 'arboria',
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                              color: Colors.white,
                              letterSpacing: 0.7,
                            ),
                          ),
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                    ),
                  ]),
                )),
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              width: double.infinity,
              child: FloatingActionButton.extended(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                backgroundColor: Colors.red[400],
                onPressed: () {
                  signOut();
                  exit(0);
                },
                label: Text(
                  'Se déconnecter',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'arboria',
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }

  Future<void> signOut() async {
    try {
      firstName.value = widget.user.email as TextEditingValue;
      await auth.signOut();
      Navigator.push(context, MaterialPageRoute(builder: (context) => new Signin()));
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> updateData() async {
    final formState = formkey.currentState;
    if (formState.validate()) {
      formState.save();
      try {
        await DatabaseService(uid: widget.user.uid).updateUserData('', '', '');
      } catch (e) {
        print(e.message);
      }
    }
  }

  Future<DocumentReference> getData() async {
    try {
      DocumentReference ref = Firestore.instance.collection('users').document(widget.user.uid);
      return ref;
    } catch (e) {
      print(e.message);
      return null;
    }
  }
}
