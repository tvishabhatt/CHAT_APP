import 'package:chat_app/ForFuncations.dart';
import 'package:chat_app/SharedPreferencesService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

abstract class  Google_abstract{


  Future<void> Signin(dynamic context,dynamic screen);
  Future<void> logout();
}
class GoogleHelper extends Google_abstract with ForFuncations{

  GoogleSignIn googleSignIn=GoogleSignIn();
  USERSModal Googleuser=USERSModal(Email: '', uid: '', Name: '', PhotoURL: '');

  @override
  Future<void> Signin(dynamic context,dynamic screen) async {

    GoogleSignInAccount ? googleUser=await googleSignIn.signIn();
    if(googleUser !=null){
      GoogleSignInAuthentication googleSignInAuthentication=await googleUser.authentication;
      AuthCredential credential=GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
      );
      UserCredential userCredential=await auth.signInWithCredential(credential);
      User? user=userCredential.user;

      if(user!=null){
        Map<String,dynamic> userData={
          'uid':user.uid,
          'Email':user.email,
          'Name':user.displayName,
          'PhotoURL':user.photoURL,
        };
        bool emailExists = await checkIfEmailExists(user.email!);
          if(!emailExists){
            Googleuser=USERSModal(Email: user.email!, uid: user.uid!, Name: user.displayName!, PhotoURL: user.photoURL!);
            Provider.of<SharedPreferencesProvider>(context, listen: false).updateUserInfo(user.displayName!, user.email!);


            await FirebaseFirestore.instance.collection("USERS").doc(user.uid).set(userData);

            Navigator.of(context).push(MaterialPageRoute(builder: (context) => screen,));
          }
          else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content:Text("Account alredy exist with this account ${user.email!}"),
              duration: Duration(seconds: 3),));
            print('User with email ${user.email!} already exists');
          }

    }
    }
    print("Goolge sign in");
    }

  @override


  @override
  Future<void> logout() async {
     await googleSignIn.signOut();
  }
  Future<bool> checkIfEmailExists(String email) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
    await db.collection(collectionName).where('Email', isEqualTo: email).get();

    return querySnapshot.docs.isNotEmpty;
  }

}
class USERSModal {
  String Email;
  String uid;
  String Name;
  String PhotoURL;

  USERSModal({
    required this.Email, required this.uid, required this.Name, required this.PhotoURL
  });
}
