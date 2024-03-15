
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';


abstract class ThemeFunctions
{
  Color fortext();
  Color forappbar();
  Color forme();
  Color forbg();
  Color foryou();
  Widget Forfont({required String font, required double fontsize, required FontWeight fontweight, required Color color});
  Widget ForTextFiled({required String hint, required TextEditingController controller, required bool b});
  Future<bool> checkIfEmailExists(String email);
}

mixin ForFuncations implements ThemeFunctions{


 String  collectionNameOfChatrooms='CHAT_ROOMS';
  String collectionName='USERS';
  String collectionOfMesaages="MESSAGES";

  FirebaseFirestore db = FirebaseFirestore.instance;
  RxBool isDarkMode=true.obs;
 dynamic user =FirebaseAuth.instance.currentUser;
  final FirebaseAuth auth=FirebaseAuth.instance;


 @override
  Color fortext(){
    return isDarkMode.value?Colors.black:Colors.white;
  }

  @override
  Color forappbar(){
    return isDarkMode.value?
    Color(0xff1E5631):
    Color(0xff03555b)
    ;
  }

  @override
  Color forme(){
    return isDarkMode.value?
    Color(0xff2C7873):
    Color(0xffDDBC95);
  }

  @override
  Color forbg(){
    return isDarkMode.value?
    Colors.white:
    Colors.black54;
  }

  @override
  Color foryou(){
    return isDarkMode.value?
    Color(0xff6FB98F):
    Color(0xffB38867);
  }


  @override
  Widget Forfont({required String font,required double fontsize,required FontWeight fontweight,required Color color}) {
    return
      Text(font, style: GoogleFonts.exo2(
        textStyle: TextStyle(fontSize: fontsize, fontWeight: fontweight,color: color),));
  }

  @override
  Widget ForTextFiled({required String hint,required TextEditingController controller,required bool b}){
    return Padding(
      padding: const EdgeInsets.all(12),
      child: TextField(
          controller:controller ,
          obscureText:b,
          style: TextStyle(color: fortext(),fontSize: 16,fontWeight: FontWeight.w500),
          cursorColor: fortext(),


          decoration: InputDecoration(
              border: OutlineInputBorder(borderSide: BorderSide(color: fortext())),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: fortext()),
              ),
              hintText: hint,
              fillColor: fortext(),
              focusColor: fortext(),


              hintStyle: TextStyle(
                fontSize: 16,fontWeight: FontWeight.w500,color: fortext(),
              )

          )
      ),
    );
  }

  @override
 Future<bool> checkIfEmailExists(String email) async {
   QuerySnapshot<Map<String, dynamic>> querySnapshot =
   await db.collection(collectionName).where('Email', isEqualTo: email).get();

   return querySnapshot.docs.isNotEmpty;
 }


}
