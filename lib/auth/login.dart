import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // key for the form
  final _formKey = GlobalKey<FormState>();
  bool _agree = false;

  // controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadRememberMe();
  }

  // rember mr
  Future<void> _loadRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    final remember = prefs.getBool('remember_me') ?? false;
    final savedEmail = prefs.getString('saved_email') ?? '';

    setState(() {
      _agree = remember;
      if (_agree) {
        _emailController.text = savedEmail;
      }
    });
  }

  Future<void> _onRememberMeChanged(bool? value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _agree = value ?? false;
    });
    await prefs.setBool('remember_me', _agree);

    if (_agree) {
      await prefs.setString('saved_email', _emailController.text.trim());
    } else {
      await prefs.remove('saved_email');
    }
  }

  // login function
  Future<void> _loginData() async {
    final prefs = await SharedPreferences.getInstance();

    final inputEmail = _emailController.text.trim();

    final userJson = prefs.getString('user_$inputEmail');

    if (userJson != null) {
      final userData = json.decode(userJson);

      if (userData['email'] == inputEmail &&
          userData['password'] == _passwordController.text) {
        await prefs.setString('logged_in_user', inputEmail);

        print('Login successful');
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Invalid email or password')));
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('No user found with this email')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/logo.png',
              width: 50,
              height: 30,
              color: Colors.deepOrange,
            ),
            const SizedBox(width: 5),
            const Text(
              "Elyousr Store ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: 20),
              Text(
                "Welcome back!\n Sign In",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                "Let's get started with signing in to your account",
                style: TextStyle(fontSize: 17, color: Colors.grey),
              ),
              SizedBox(height: 20),

              //email
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  hintText: "please enter your email",
                ),
                validator: (value) {
                  if (value!.isEmpty) return 'Enter your email';
                  if (!value.contains('@')) return 'Invalid email';
                  return null;
                },
              ),
              SizedBox(height: 15),

              //password
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: "please enter password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                obscureText: true,
                validator: (value) =>
                    value!.length < 8 ? 'Min 8 characters' : null,
              ),

              //remember me checkbox
              SizedBox(height: 20),
              Row(
                children: [
                  Checkbox(
                    value: _agree,
                    onChanged:
                        _onRememberMeChanged, 
                  ),
                  Text("Remember me", style: TextStyle(color: Colors.grey)),
                ],
              ),

              //signup Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _loginData();
                    // printAllSharedPrefs();
                  }
                },
                child: const Text(
                  'Sign In',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(color: Colors.grey),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/register');
                    },
                    child: Text(
                      "Sign Up",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey, thickness: 1)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text("or", style: TextStyle(color: Colors.grey)),
                  ),
                  Expanded(child: Divider(color: Colors.grey, thickness: 1)),
                ],
              ),
              SizedBox(height: 25),

              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {},
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/google.png', width: 24, height: 24),
                      SizedBox(width: 10),
                      Text(
                        "Sign in with Google",
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 25),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {},
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/facebook.png', width: 24, height: 24),
                      SizedBox(width: 10),
                      Text(
                        "Sign in with Facebook",
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
