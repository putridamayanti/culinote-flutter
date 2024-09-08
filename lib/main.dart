import 'package:culinote_flutter/routes/route_generator.dart';
import 'package:culinote_flutter/routes/routes.dart';
import 'package:culinote_flutter/theme/app.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Culinote',
      theme: AppTheme.themeData,
      initialRoute: RouteNames.homeScreen,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
