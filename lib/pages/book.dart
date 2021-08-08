import 'package:delivery_app/pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Book extends StatefulWidget {
  final FirebaseUser user;
  const Book({Key key, this.user}) : super(key: key);

  @override
  _BookState createState() => _BookState();
}

class _BookState extends State<Book> {
  DateTime start = DateTime.now();
  DateTime finish = DateTime.now();
  DateTime open = DateTime.parse("2020-06-10 08:00:00Z");
  DateTime close = DateTime.parse("2020-06-10 22:00:00Z");

  int selectedIndex;

  List<int> tables = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: ListView(children: <Widget>[
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
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Container(
                  height: 50.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blue,
                  ),
                  child: FlatButton(
                      onPressed: () {
                        DatePicker.showPicker(context, showTitleActions: true, onChanged: (date) {
                          print('change $date in time zone ' +
                              date.timeZoneOffset.inHours.toString());
                        }, onConfirm: (date) {
                          setState(() {
                            start = date;
                          });
                          print('confirm $start');
                        },
                            pickerModel: CustomPicker(currentTime: DateTime.now()),
                            locale: LocaleType.en);
                      },
                      child: Text(
                        'Choisir l\'heure de début',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'arboria',
                          fontSize: 15.0,
                          fontWeight: FontWeight.normal,
                          letterSpacing: 0.5,
                        ),
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
                child: Container(
                  height: 50.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blue,
                  ),
                  child: FlatButton(
                      onPressed: () {
                        DatePicker.showPicker(context, showTitleActions: true, onChanged: (date) {
                          print('change $date in time zone ' +
                              date.timeZoneOffset.inHours.toString());
                        }, onConfirm: (date) {
                          setState(() {
                            finish = date;
                          });
                          print('confirm $finish');
                        },
                            pickerModel: CustomPicker(currentTime: DateTime.now()),
                            locale: LocaleType.en);
                      },
                      child: Text(
                        'Choisir l\'heure de fin',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'arboria',
                          fontSize: 15.0,
                          fontWeight: FontWeight.normal,
                          letterSpacing: 0.5,
                        ),
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Center(
                  child: Text(
                    'Votre réservation est de ' +
                        start.hour.toString() +
                        ' : ' +
                        start.minute.toString() +
                        ' à ' +
                        finish.hour.toString() +
                        ' : ' +
                        finish.minute.toString(),
                    style: TextStyle(
                      color: Colors.blue,
                      fontFamily: 'arboria',
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  height: 360.0,
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: tables.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
                            child: Container(
                              height: 50.0,
                              width: 200.0,
                              child: RaisedButton(
                                elevation: 0.0,
                                color: selectedIndex == index ? Colors.blue : Colors.grey[400],
                                onPressed: () => setState(() => selectedIndex = index),
                                child: Text(
                                  "Table : " + tables[index].toString(),
                                  style: TextStyle(
                                    fontFamily: 'arboria',
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15.0,
                                    color: Colors.white,
                                    letterSpacing: 0.7,
                                  ),
                                ),
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              )
            ])),
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
              print('$start | $finish');
              if (start.isAfter(finish) || start.hour < open.hour || finish.hour >= close.hour) {
                Fluttertoast.showToast(
                  msg: "La période saisie n'est pas valable",
                  toastLength: Toast.LENGTH_SHORT,
                  textColor: Colors.red,
                  gravity: ToastGravity.CENTER,
                  backgroundColor: Colors.white,
                  fontSize: 15.0,
                );
              } else {
                seeDialog();
              }
              /* admin.firestore().collection('mail').add({
                to: widget.user.email,
                message: {
                  subject: 'Validation de votre réservation',
                  html: Text("Votre réservation de " + start.hour.toString() + " : " + start.minute.toString() + " à " + finish.hour.toString() + " : " + finish.minute.toString() + " a été enregistrée avec succès"),
                },
              }); */
            },
            label: Text(
              'Reserver',
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
  }

  Future<void> seeDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Réservé avec succès"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Votre réservation de " +
                    start.hour.toString() +
                    " : " +
                    start.minute.toString() +
                    " à " +
                    finish.hour.toString() +
                    " : " +
                    finish.minute.toString() +
                    " a été enregistrée avec succès"),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('D’accord'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class CustomPicker extends CommonPickerModel {
  String digits(int value, int length) {
    return '$value'.padLeft(length, "0");
  }

  CustomPicker({DateTime currentTime, LocaleType locale}) : super(locale: locale) {
    this.currentTime = currentTime ?? DateTime.now();
    this.setLeftIndex(this.currentTime.hour);
    this.setMiddleIndex(this.currentTime.minute);
    this.setRightIndex(this.currentTime.second);
  }

  @override
  String leftStringAtIndex(int index) {
    if (index >= 0 && index < 24) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String middleStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String leftDivider() {
    return "|";
  }

  @override
  List<int> layoutProportions() {
    return [1, 1, 0];
  }

  @override
  DateTime finalTime() {
    return currentTime.isUtc
        ? DateTime.utc(currentTime.year, currentTime.month, currentTime.day,
            this.currentLeftIndex(), this.currentMiddleIndex(), this.currentRightIndex())
        : DateTime(currentTime.year, currentTime.month, currentTime.day, this.currentLeftIndex(),
            this.currentMiddleIndex(), this.currentRightIndex());
  }
}
