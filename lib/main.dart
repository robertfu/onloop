import 'package:flutter/material.dart';
import 'package:onloop/bloc/content_provider.dart';
import 'package:onloop/pages/articles.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => ContentProvider(),
      dispose: (_, ContentProvider p) => p.dispose(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
         appBarTheme: const AppBarTheme(
           color: Colors.white
         ),
         scaffoldBackgroundColor: Colors.grey.shade200
        ),
        home: const Article(),
      ),
    );
  }
}
