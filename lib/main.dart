
import 'package:matrimony_flutter/Authentication/widget_tree.dart';
import 'package:matrimony_flutter/Home/favorite_list/favoritelist_provider.dart';
import 'package:matrimony_flutter/Home/profile/drawer_provider.dart';
import 'package:matrimony_flutter/Home/user_list/userlist_provider.dart';
import 'package:matrimony_flutter/Utils/importFiles.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  Get.put<SharedPreferences>(prefs); // Store it globally in GetX
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_)=>UserListProvider()),
            ChangeNotifierProvider(create: (_)=>DrawerProvider()),
            ChangeNotifierProvider(create: (_)=>FavoritelistProvider()),
          ],
          child: const MyApp()
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      color: Colors.white,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        splashColor: Colors.transparent,
      ),
      home: WidgetTree(),
    );
  }
}
