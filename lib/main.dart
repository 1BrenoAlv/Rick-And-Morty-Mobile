import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rick_and_morty_mobile/app/view/pages/home-page/home_page.dart';
import './app/config/provider_config.dart';

void main() => runApp(
  MultiProvider(providers: ProviderConfig.providers, child: const MyApp()),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage(), debugShowCheckedModeBanner: false);
  }
}
