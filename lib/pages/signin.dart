import 'package:delivery_app/pages/routes.dart';
import 'package:delivery_app/pages/signup.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:email_validator/email_validator.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Signin extends StatefulWidget {
  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth auth = FirebaseAuth.instance;

  String email, password;
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Form(
              key: formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    flex: 16,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: 50.0),
                          TextFormField(
                            validator: (input) {
                              if (!EmailValidator.validate(input)) {
                                return 'Email non valide';
                              }
                            },
                            onSaved: (input) => email = input,
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
                              hintText: 'email',
                              hintStyle: TextStyle(
                                  fontFamily: 'arboria',
                                  fontWeight: FontWeight.normal,
                                  fontSize: 17.0,
                                  letterSpacing: 0.4,
                                  color: Color(0xffa0a0a0)),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.0),
                          TextFormField(
                            validator: (input) {
                              if (input.length < 6) {
                                return 'Mot de passe non valide';
                              }
                            },
                            onSaved: (input) => password = input,
                            obscureText: true,
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
                              hintText: 'mot de passe',
                              hintStyle: TextStyle(
                                  fontFamily: 'arboria',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 17.0,
                                  letterSpacing: 0.4,
                                  color: Color(0xffa0a0a0)),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                          ),
                          SizedBox(height: 30.0),
                          Container(
                            width: 200.0,
                            height: 50.0,
                            child: RaisedButton(
                              elevation: 0.0,
                              color: Colors.blue[700],
                              child: Text(
                                "Se connecter",
                                style: TextStyle(
                                  fontFamily: 'arboria',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17.0,
                                  color: Colors.white,
                                  letterSpacing: 0.7,
                                ),
                              ),
                              onPressed: signIn,
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0),
                              ),
                            ),
                          ),
                          SizedBox(height: 30.0),
                          /* Container(
                            width: 200.0,
                            height: 50.0,
                            child: SignInButton(
                              Buttons.Google,
                              onPressed: goSignIn,
                            )
                          ), */
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontFamily: 'arboria',
                          fontWeight: FontWeight.normal,
                          fontSize: 14.0,
                          color: Colors.black,
                          letterSpacing: 0.4,
                        ),
                        children: <TextSpan>[
                          TextSpan(text: 'Vous n\'avez pas de compte? '),
                          TextSpan(
                              text: 'Inscrivez-vous',
                              style: TextStyle(
                                fontFamily: 'arboria',
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                                color: Colors.blue[800],
                                letterSpacing: 0.7,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                      context, MaterialPageRoute(builder: (context) => Signup()));
                                }),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signIn() async {
    final formState = formkey.currentState;
    if (formState.validate()) {
      formState.save();
      try {
        FirebaseUser user =
            (await auth.signInWithEmailAndPassword(email: email, password: password)).user;
        Navigator.push(context, MaterialPageRoute(builder: (context) => Routes(user: user)));
      } catch (e) {
        Fluttertoast.showToast(
          msg: "Compte n'existe pas",
          toastLength: Toast.LENGTH_SHORT,
          textColor: Colors.red,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.white,
          fontSize: 15.0,
        );
      }
    }
  }

  Future<void> goSignIn() async {
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    try {
      FirebaseUser user = (await FirebaseAuth.instance.signInWithCredential(credential)).user;
      Navigator.push(context, MaterialPageRoute(builder: (context) => Routes()));
    } catch (e) {
      print(e.message);
    }
  }
}
