import 'package:bookshop/screens/main_screen.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bookshope',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          surfaceTintColor: Colors.transparent,
          backgroundColor: const Color.fromRGBO(235, 226, 215, 1.0),
          titleTextStyle: TextStyle(
            color: const Color(0xFF382110),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(
            color: Color(0xFF382110),
          )
        ),
        
        scaffoldBackgroundColor: const Color(0xFFFAF8F6),
        iconTheme: const IconThemeData(
          color: Color(0xFF382110), 
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF382110),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),

        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black),
          titleLarge: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),

        inputDecorationTheme: InputDecorationTheme(
          labelStyle: const TextStyle(color: Color(0xFF382110)),
          prefixIconColor: const Color(0xFF382110),
          suffixIconColor: const Color(0xFF382110),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF382110)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF382110), width: 2),
          ),
        ),

        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xFF382110),
          selectionColor: Color(0xFF382110),
          selectionHandleColor: Color(0xFF382110),
        ),
      ),
      home: const MainScreen(),
    );
  }
}