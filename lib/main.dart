import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:proyecto_v2/auth/auth_page.dart';
import 'package:proyecto_v2/presentation/providers/user_profile_provider.dart';
import 'services/firebase_options.dart';
import 'package:proyecto_v2/config/theme/app_theme.dart';
import 'package:proyecto_v2/presentation/pages/init/login_page.dart';
import 'package:proyecto_v2/presentation/pages/init/register_page.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ChangeNotifierProvider(
    create: (context) => UserProvider(),
    child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        theme: AppTheme(selectedColor: 5).theme(),
        initialRoute: 'auth',
        routes: {
          'login': ( _ ) => const LoginPage(),
          'register': ( _ ) => const RegisterPage(),
          'auth': ( _ ) => const AuthPage(),
        },
      );
  }
}