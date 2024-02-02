
import 'package:chat_app/ChatScreen.dart';
import 'package:chat_app/ForFuncations.dart';
import 'package:chat_app/LoginScreen.dart';
import 'package:chat_app/RagisterScreen.dart';
import 'package:chat_app/SettingScreen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class DeshBordScreen extends StatefulWidget {
  const DeshBordScreen({Key? key}) : super(key: key);

  @override
  State<DeshBordScreen> createState() => _DeshBordScreenState();
}

class _DeshBordScreenState extends State<DeshBordScreen> with ForFuncations{


  @override
  Widget build(BuildContext context) {
    return  Scaffold (
      backgroundColor: forbg(),
      appBar: AppBar(
        backgroundColor: forappbar(),
        title: Text("Users"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingScreen(),));
          }, icon: Icon(Icons.person_2_rounded,size: 22,color:isDarkMode.value?Colors.white:Colors.black,)),
        ],
      ),
      body:guest?
      Center(
          child:Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text( "You'cant go Futher because you are geust . If you want to " ,style: TextStyle( fontSize: 16, fontWeight: FontWeight.bold, color: fortext()),textAlign: TextAlign.center,),
                InkWell(

                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => RagisterScreen()));
                    },
                    child: Forfont(font: "Create Account", fontsize: 16, fontweight: FontWeight.bold, color:isDarkMode.value?Colors.red:Colors.blue)),
                Text( "or " ,style: TextStyle( fontSize: 16, fontWeight: FontWeight.bold, color: fortext())),


                InkWell(

                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen()));
                    },
                    child: Forfont(font: "Log in ", fontsize: 16, fontweight: FontWeight.bold, color: isDarkMode.value?Colors.red:Colors.blue)),
              ],
            ),
          )):
      StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection(collectionName).snapshots(),
          builder: (context, snapshot) {
            if(!snapshot.hasData){
              return Center(child: CircularProgressIndicator());
            };
            var users = snapshot.data!.docs;
            List<Widget> UsersList=[];
            for(var user in users){
              var UserData = user.data() as Map<String,dynamic>;
              if(auth.currentUser!.email !=UserData["Email"]){
                UsersList.add(
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatScreen(username: UserData['Name'].toString(),uid:user.id ,email:UserData['Email'].toString() ,),));
                        },
                        child: ListTile(
                          title: Text(UserData['Name'].toString(),style: TextStyle(color: fortext()),),
                          subtitle: Text('${UserData['Email']}',style: TextStyle(color: fortext()),),
                        ),
                      ),
                    ));
              }

            }
            return ListView(
              children: UsersList,
            );
          }
      ),



    );
  }


}


