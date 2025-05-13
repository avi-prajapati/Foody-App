import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_button/sign_button.dart';

import 'food_category_screen.dart';

class GoogleSignInScreen extends StatefulWidget {
  const GoogleSignInScreen({super.key});

  @override
  State<GoogleSignInScreen> createState() => _GoogleSignInScreenState();
}

class _GoogleSignInScreenState extends State<GoogleSignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.amber,
        title: const Text(
          'Welcome To F🍩🍩dy',
          style: TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
              fontSize: 24,
              fontWeight: FontWeight.w700),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: 200,
                width: 200,
                child: Image.asset('images/food-stall.png')),
            const SizedBox(height: 20),
            const SizedBox(
              height: 80,
              width: 150,
              child: Text(
                'F🍩🍩dy',
                textAlign: TextAlign.center,
                style: TextStyle(
                    backgroundColor: Colors.amber,
                    color: Colors.black,
                    fontSize: 29,
                    fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 100),
            SignInButton(
                buttonType: ButtonType.google,
                buttonSize: ButtonSize.large, // small(default), medium, large
                onPressed: () {
                  _handlingGoogleSignInbutton();
                }),
          ],
        ),
      ),
    );
  }

  //Function for handling siigle sign in.
  _handlingGoogleSignInbutton() {
    _signInWithGoogle().then(
      (user) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FoodCategoryScreen(),
            ));
      },
    );
  }

  //GOOGLE SIGN IN.
  Future<UserCredential> _signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
