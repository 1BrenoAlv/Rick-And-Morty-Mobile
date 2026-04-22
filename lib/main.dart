import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rick_and_morty_mobile/app/view/pages/splash/splash_page.dart';
import './app/config/provider_config.dart';
import './app/config/colors.dart';

void main() => runApp(
  MultiProvider(providers: ProviderConfig.providers, child: const MyApp()),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.bgColor,
        primaryColor: AppColors.primaryColor,
        colorScheme: ColorScheme.light(
          primary: AppColors.primaryColor,
          secondary: AppColors.bgAside,
          surface: AppColors.bgColor,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.bgAside,
          foregroundColor: AppColors.bgColor,
          elevation: 2,
          iconTheme: IconThemeData(color: AppColors.bgColor),
          titleTextStyle: TextStyle(
            color: AppColors.bgColor,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: AppColors.borderRadiusCard,
            side: const BorderSide(color: AppColors.colorBorder, width: 1),
          ),
        ),
        drawerTheme: const DrawerThemeData(
          backgroundColor: AppColors.bgAside,
        ),
        iconTheme: const IconThemeData(color: AppColors.primaryColor),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: AppColors.primaryColor),
          bodyMedium: TextStyle(color: AppColors.primaryColor),
          bodySmall: TextStyle(color: AppColors.primaryColor),
          titleLarge: TextStyle(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: AppColors.borderRadiusCard,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderRadius: AppColors.borderRadiusCard,
            borderSide: const BorderSide(color: AppColors.colorBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppColors.borderRadiusCard,
            borderSide: const BorderSide(color: AppColors.bgAside, width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      home: const SplashPage(),
    );
  }
}
