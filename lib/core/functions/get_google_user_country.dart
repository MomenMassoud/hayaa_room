import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<String?> getUserCountry() async {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = auth.currentUser;

  if (user != null) {
    GoogleSignInAccount? googleUser = await GoogleSignIn().signInSilently();
    if (googleUser != null) {
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      // Retrieve the user's country from the user's profile
      String? country = googleUser.serverAuthCode;
      return country;
    }
  }
}
