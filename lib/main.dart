import 'package:matrimony_flutter/Authentication/widget_tree.dart';
import 'package:matrimony_flutter/Home/favorite_list/favoritelist_provider.dart';
import 'package:matrimony_flutter/Home/profile/drawer_provider.dart';
import 'package:matrimony_flutter/Home/user_list/userlist_provider.dart';
import 'package:matrimony_flutter/Utils/importFiles.dart';
import 'package:matrimony_flutter/launch_page.dart';
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
        ChangeNotifierProvider(create: (_) => UserListProvider()),
        ChangeNotifierProvider(create: (_) => DrawerProvider()),
        ChangeNotifierProvider(create: (_) => FavoritelistProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      color: Colors.white,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: Colors.teal,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        splashColor: Colors.transparent,
      ),
      home: WidgetTree(),
    );
  }
}
