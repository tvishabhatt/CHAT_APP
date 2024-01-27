import 'package:chat_app/SharedPreferencesService.dart';
import 'package:chat_app/SplaceScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';


late final FirebaseApp app;
late final FirebaseAuth auth;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  try{
    app=await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: 'AIzaSyDws5G8_6FufBkgnOo__Tn-Dcs0Z3bvCg0',
          appId: '1:158769547937:android:9526bc778b641d434c7ee0',
          messagingSenderId: '158769547937',
          projectId: 'chat-app-ba1fc'),
    );
  }
  catch(e){
    print('Firebase initialization failed: $e');
  }
  auth = FirebaseAuth.instanceFor(app: app);

  await GetStorage.init();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => SharedPreferencesProvider(),),
    ],
    child: const MyApp(),
  ));
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme:ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: GetStorage().read("appTheme") == true ?ThemeMode.dark:ThemeMode.light,
      home: SplaceScreen(),
    );
  }
}
