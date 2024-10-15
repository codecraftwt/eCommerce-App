import 'package:ecommerce_app/Provider/user_provider.dart';
import 'package:ecommerce_app/common/bottom_bar.dart';
import 'package:ecommerce_app/constants/global_variables.dart';
import 'package:ecommerce_app/features/SplashScreen/SplashScreen.dart';
import 'package:ecommerce_app/features/admin/screen/admin_screen.dart';
import 'package:ecommerce_app/features/auth/screens/auth_screen.dart';
import 'package:ecommerce_app/features/auth/services/auth_service.dart';
import 'package:ecommerce_app/router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    authService.getUserData(context);
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    print("User Type: ${userProvider.user.type}");
    return ToastificationWrapper(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Amazon Clone',
        theme: ThemeData(
          scaffoldBackgroundColor: GlobalVariables.backgroundColor,
          colorScheme: const ColorScheme.light(
            primary: GlobalVariables.secondaryColor,
          ),
          appBarTheme: const AppBarTheme(
            elevation: 0,
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
          ),
          useMaterial3: false,
        ),
        onGenerateRoute: (settings) => generateRoute(settings),
        initialRoute: SplashScreen.routeName,
        home: userProvider.user.token.isNotEmpty
            ? userProvider.user.type == 'Buyer'
                ? BottomBar()
                : AdminScreen()
            : const AuthScreen(),
      ),
    );
  }
}
