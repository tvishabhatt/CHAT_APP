import 'package:chat_app/DeshBordScreen.dart';
import 'package:chat_app/ForFuncations.dart';
import 'package:chat_app/SharedPreferencesService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RagisterScreen extends StatefulWidget {
  const RagisterScreen({Key? key}) : super(key: key);

  @override
  State<RagisterScreen> createState() => _RagisterScreenState();
}






class _RagisterScreenState extends State<RagisterScreen> with ForFuncations {

  TextEditingController useremailController2 =TextEditingController();
  TextEditingController usernameController2 =TextEditingController();
  TextEditingController userpasswordController2 =TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: forbg(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 100,),
              Center(child: Image(image: isDarkMode.value?AssetImage("assets/chat.png"):AssetImage("assets/chat (1).png"),height: 100,width: 100,)),
              SizedBox(height: 20,),
              Center(child: Forfont(font: "Create New Account",color: fortext(),fontsize: 30,fontweight: FontWeight.bold)),
              SizedBox(height: 20,),
              CreateAccount(),
              SizedBox(height: 10,),




            ],
          ),
        ),
      ),
    );
  }
  Widget CreateAccount(){
    return Column( crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(child: ForTextFiled(hint: "Enter Name", controller:usernameController2,b: false)),
        Center(child: ForTextFiled(hint: "Enter Email", controller:useremailController2,b: false)),
        Center(child: ForTextFiled(hint: "Enter Password", controller:userpasswordController2,b: true)),


        GestureDetector(
          onTap: ()async {


            await auth.createUserWithEmailAndPassword(
                email: useremailController2.text,
                password: userpasswordController2.text);

            Map<String,dynamic> users={
              "Email":useremailController2.text,
              "Name":usernameController2.text,
              "ProfilePic":null
            };

            bool emailExists = await checkIfEmailExists( useremailController2.text);
            if(!emailExists){

              await db.collection(collectionName).add(users);
              Provider.of<SharedPreferencesProvider>(context, listen: false).updateUserInfo(usernameController2.text,useremailController2.text);
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => DeshBordScreen(),));

            }else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content:Text("Account alredy exist with this account ${useremailController2.text}"),
                duration: Duration(seconds: 3),));
              print('User with email ${useremailController2.text} already exists');
            }},
          child:
          Center(child: Container(
              decoration: BoxDecoration(
                color: fortext(),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Forfont(font: "Create", fontsize: 14, fontweight: FontWeight.bold,color:forbg()),
              ))),),
      ],
    );
  }



  Future<bool> checkIfEmailExists(String email) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
    await db.collection(collectionName).where('Email', isEqualTo: email).get();

    return querySnapshot.docs.isNotEmpty;
  }



  void dispose(){
    usernameController2.dispose();
    userpasswordController2.dispose();
    useremailController2.dispose();
    super.dispose();
  }
}
