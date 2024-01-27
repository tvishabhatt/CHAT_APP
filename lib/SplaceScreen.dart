import 'dart:async';
import 'package:chat_app/DeshBordScreen.dart';
import 'package:chat_app/ForFuncations.dart';
import 'package:chat_app/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplaceScreen extends StatefulWidget {

  const SplaceScreen({Key? key}) : super(key: key);

  @override
  State<SplaceScreen> createState() => SplaceScreenState();
}

class SplaceScreenState extends State<SplaceScreen> with ForFuncations{
  static const String KEYLOGIN="Login";
  static const String LOGEDINUSER="LogedinUser";
  @override
  void initState() {
    super.initState();
    wheretigo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: forbg(),
        body: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  gradient: LinearGradient(
                    colors: [forbg(), forappbar()],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Image(
                    image:isDarkMode.value
                        ? AssetImage("assets/chat.png")
                        : AssetImage("assets/chat (1).png"),
                    height: 80,
                    width: 80,
                  ),
                ),
              ),
            ),
            SizedBox(height: 40,),
            Forfont(font: "Let's Talk", fontsize: 30, fontweight: FontWeight.bold, color: fortext()),
          ],
        ));
  }
  void wheretigo()async
  {
    var Prefs=await SharedPreferences.getInstance();
    var isloggedIn = Prefs.getBool(KEYLOGIN);


    Timer(Duration(seconds: 3), () {
      if(isloggedIn!=null)
      {
        if(isloggedIn)
        {
          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) =>DeshBordScreen()),);

        }
        else{
          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) =>LoginScreen()),);
        }
      }
      else{
        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) =>LoginScreen()),);
      }
    });



  }
}


