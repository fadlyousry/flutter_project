import 'package:flutter/material.dart';
import 'package:flutter_project/auth/signup.dart';
import 'package:flutter_project/auth/splashScreen.dart';
import 'package:flutter_project/auth/login.dart';
import 'package:flutter_project/home/home_page.dart';
import 'package:flutter_project/orders/orders.dart';
import 'package:flutter_project/profile/profile.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Commerce App',
      initialRoute: '/',
      routes: {
        '/': (context) =>  SplashScreen(),
        '/login': (context) =>  Login(),      
        '/register': (context) =>  SignUpPage(), 
        '/home': (context) =>  HomePageWithPages(),  
        '/orders': (context) => OrdersPage(),
        '/profile': (context) => ProfilePage(),
    
      
      },
    );
  }
}
