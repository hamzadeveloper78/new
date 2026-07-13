import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const StudentManagementApp());
}

class StudentManagementApp extends StatelessWidget {
  const StudentManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'نظام إدارة الطلاب',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        fontFamily: 'Arial', // يمكن تغيير الخط لاحقاً إذا توفر خط عربي مخصص
      ),
      localizationsDelegates: const [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale("ar", "AE"),
      ],
      locale: const Locale("ar", "AE"),
      home: const HomeScreen(),
    );
  }
}
