import 'package:chat_app/ForFuncations.dart';
import 'package:chat_app/LoginScreen.dart';
import 'package:chat_app/RagisterScreen.dart';
import 'package:chat_app/SharedPreferencesService.dart';
import 'package:chat_app/SplaceScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> with ForFuncations {
  void initializeTheme() async {
    bool? storedThemeMode = GetStorage().read("appTheme");
    if (storedThemeMode != null) {
      isDarkMode.value = storedThemeMode;
      updateThemeMode(isDarkMode.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: forbg(),
      appBar: AppBar(
        title: Text("Profile Page"),
        centerTitle: true,
        backgroundColor: forappbar(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            SizedBox(
              height: 60,
            ),
            Forfont(
                font: "Email  you loged in with ",
                fontsize: 22,
                fontweight: FontWeight.bold,
                color: fortext()),
            SizedBox(
              height: 20,
            ),
            Consumer<SharedPreferencesProvider>(
                builder: (context, provider, child) {
              return Center(
                  child: Forfont(
                      font: "Name : ${provider.name}",
                      fontsize: 22,
                      fontweight: FontWeight.bold,
                      color: fortext()));
            }),
            Consumer<SharedPreferencesProvider>(
              builder: (context, provider, child) {
                return Center(
                    child: Forfont(
                        font: "Email: ${provider.email}",
                        fontsize: 22,
                        fontweight: FontWeight.bold,
                        color: fortext()));
              },
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Forfont(
                    font: "Change Theme",
                    fontsize: 25,
                    fontweight: FontWeight.bold,
                    color: fortext()),
                IconButton(
                    onPressed: () => AppTheme(),
                    icon: Icon(
                      isDarkMode.value ? Icons.dark_mode : Icons.light,
                      color: fortext(),
                    )),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Forfont(
                    font: "Log Out",
                    fontsize: 25,
                    fontweight: FontWeight.bold,
                    color: fortext()),
                IconButton(
                    onPressed: () async {

                        await auth.signOut();

                      final prefs = await SharedPreferences.getInstance();
                      prefs.setBool(SplaceScreenState.KEYLOGIN, false);

                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ));
                    },
                    icon: Icon(
                      Icons.login_outlined,
                      size: 30,
                      color: fortext(),
                    ))
              ],
            ),
            SizedBox(
              height: 20,
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => RagisterScreen(),
                  ));
                },
                child: Forfont(
                    font: "Create New Account ",
                    fontsize: 25,
                    fontweight: FontWeight.bold,
                    color: fortext())),
          ],
        ),
      ),
    );
  }

  void AppTheme() {
    isDarkMode.value = !isDarkMode.value;
    updateThemeMode(isDarkMode.value);
    GetStorage().write("appTheme", isDarkMode.value);
  }

  void updateThemeMode(bool darkMode) {
    Get.changeThemeMode(darkMode ? ThemeMode.dark : ThemeMode.light);
  }
}
