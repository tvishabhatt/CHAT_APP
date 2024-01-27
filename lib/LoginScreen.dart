
import 'package:chat_app/DeshBordScreen.dart';
import 'package:chat_app/ForFuncations.dart';
import 'package:chat_app/RagisterScreen.dart';
import 'package:chat_app/SharedPreferencesService.dart';
import 'package:chat_app/SplaceScreen.dart';
import 'package:chat_app/main.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}



class _LoginScreenState extends State<LoginScreen> with ForFuncations {


  TextEditingController useremailController =TextEditingController();
  TextEditingController usernameController =TextEditingController();
  TextEditingController userpasswordController =TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: forbg(),
      resizeToAvoidBottomInset: true,

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 100,),
              Center(child: Image(image:isDarkMode.value?AssetImage("assets/chat.png"):AssetImage("assets/chat (1).png"),height: 100,width: 100,)),
              SizedBox(height: 30,),
              Center(child: Forfont(font: "Welcome",color: fortext(),fontsize: 30,fontweight: FontWeight.bold)),
              SizedBox(height: 30,),

              Center(child: ForTextFiled(hint: "Enter Name", controller:usernameController,b: false)),
              Center(child: ForTextFiled(hint: "Enter Email", controller:useremailController,b: false)),
              Center(child: ForTextFiled(hint: "Enter Password", controller:userpasswordController,b: true)),
              LogIn(),
              DoNotHaveaccount(),


            ],
          ),
        ),
      ),
    );
  }
  Widget LogIn(){
    return   Consumer<SharedPreferencesProvider>(
        builder: (context,provider,child) {
          return Padding(
            padding: const EdgeInsets.all(15),
            child: InkWell(

              onTap: ()async {
                try{
                  await auth.signInWithEmailAndPassword(
                    email:useremailController.text,
                    password: userpasswordController.text,
                  );
                  Provider.of<SharedPreferencesProvider>(context, listen: false).updateUserInfo(usernameController.text, useremailController.text);

                  ischecktoNextPage(useremailController.text);
                }
                catch(e){
                  print("Error $e");
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Enter Correct  Email and Password ."),
                    duration: Duration(seconds: 3),
                  ));
                }
                guest=false;


              },
              child:Center(
                child: Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: fortext(),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Forfont(font: "Log in ", fontsize: 25, fontweight: FontWeight.bold, color:forbg()),
                    ),
                  ),
                ),

              ),
            ),);
        }
    );
  }

  Widget DoNotHaveaccount(){
    return  Center(
        child: Row(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Forfont(font: "Don't have an account ?  ", fontsize: 10, fontweight: FontWeight.bold, color: fortext()),
            InkWell(

                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => RagisterScreen()));
                },
                child: Forfont(font: "Create Account", fontsize: 10, fontweight: FontWeight.bold, color: isDarkMode.value?Colors.red:Colors.blue)),
          ],
        ));
  }

  Future<bool> isEmailAlreadyInCollection(String email)async{



    QuerySnapshot<Map<String,dynamic>> querySnapshot=await FirebaseFirestore.instance.collection(collectionName).
    where("Email",isEqualTo: email).get();
    return querySnapshot.docs.isNotEmpty;
  }

  Future<void> ischecktoNextPage(String email) async{

    print("ischecked nextpage");
    bool isEmailExists =await isEmailAlreadyInCollection(email);


    if(isEmailExists){
      final prefs=await SharedPreferences.getInstance();
      prefs.setBool(SplaceScreenState.KEYLOGIN, true);

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DeshBordScreen(),));
    }

    else{
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("You Don't have Account With this Email right correct email."),
            duration: Duration(seconds: 3),
          ));
    }
  }

  @override
  void dispose() {
    useremailController.dispose();
    usernameController.dispose();
    userpasswordController.dispose();
    super.dispose();
  }

}
