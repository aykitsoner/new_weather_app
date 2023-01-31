import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:new_weather_app/utils/constants.dart';

class AuthService {
  final firebaseAuth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future signAnonymous() async {
    try {
      final result = await firebaseAuth.signInAnonymously();
      final user = result.user;

      if (user != null) {
        print("anonim olarak oturum açıldı");
        print(user.uid);
      }

      final userCollection = <String, String>{
        "cityname": weatherData["city"]["name"],
      };
      FirebaseFirestore.instance
          .collection("cities")
          .doc(user!.uid)
          .collection("fav");
      // .doc()
      // .set(userCollection);

      // await _firestore.collection("userCollection").document(user!.uid).setData({
      //   "uid": user.uid,
      // });

    } catch (e) {
      print("Anonimus Error$e");
      return null;
    }
  }
}
