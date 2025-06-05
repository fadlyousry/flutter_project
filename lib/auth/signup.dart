import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

enum Gender { male, female }

File? _profileImage;

class _SignUpPageState extends State<SignUpPage> {
  String? _selectedGender = "male";

  DateTime? _selectedDate;

  // date of birth
  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  // image
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  // controllers
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _adressController = TextEditingController();
  final _dateController = TextEditingController();

  // save data
  Future<void> _registerUser() async {
    final prefs = await SharedPreferences.getInstance();

    final user = {
      'fullName': _nameController.text.trim(),
      'email': _emailController.text.trim(),
      'phone': _phoneController.text.trim(),
      'password': _passwordController.text.trim(),
      'imagePath': _profileImage?.path ?? '',
      'date': _dateController.text.trim(),
      'gender': _selectedGender,
      'adress': _adressController.text.trim(),
    };
    print(user);
    // save in sheard
    final userJson = jsonEncode(user);

    List<String> usersList = prefs.getStringList('users_list') ?? [];
    usersList.add(user['email']!);
    prefs.setStringList('users_list', usersList);

    await prefs.setString('user_${user['email']}', userJson);
    await prefs.setString('logged_in_user', user['email']!);

    // Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    final egyptPhone = RegExp(r'^(010|011|012|015)\d{8}$');

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
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: 20),
              Text(
                "Create your Account",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                "Let's get started with a free account",
                style: TextStyle(fontSize: 17, color: Colors.grey),
              ),
              SizedBox(height: 20),

              //name
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  hintText: "please enter your name",
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your name' : null,
              ),
              SizedBox(height: 15),

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

              //phone
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  hintText: "please enter your phone",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter your phone number';
                  }

                  if (!egyptPhone.hasMatch(value)) {
                    return 'Enter a valid Egyptian phone number';
                  }

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
              SizedBox(height: 15),

              //Confirm Password
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  hintText: "please enter Confirm Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                obscureText: true,
                validator: (value) {
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  if (value == null || value.isEmpty) {
                    return "please enter Confirm Password";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              //adress
              TextFormField(
                controller: _adressController,
                decoration: InputDecoration(
                  labelText: "Address",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  hintText: "please enter your address",
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your address' : null,
              ),
              SizedBox(height: 15),

              // date
              TextFormField(
                controller: _dateController,
                readOnly: true,
                onTap: _pickDate,
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.calendar_today),

                  labelText: "Select Date of Birth",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  hintText: "please Select Date of Birth",
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please Select Date of Birth' : null,
              ),
              SizedBox(height: 15),

              // gender
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      activeColor: Colors.black,
                      title: Text("Male"),
                      value: "male",
                      groupValue: _selectedGender,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedGender = value;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      activeColor: Colors.black,
                      title: Text("Female"),
                      value: "female",
                      groupValue: _selectedGender,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedGender = value;
                        });
                      },
                    ),
                  ),
                ],
              ),

              // Profile Image Picker
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _profileImage != null
                      ? CircleAvatar(
                          backgroundImage: FileImage(_profileImage!),
                          radius: 30,
                          child: IconButton(
                            onPressed: _pickImage,
                            icon: Icon(
                              Icons.camera_alt,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : CircleAvatar(
                          backgroundColor: const Color.fromARGB(131, 0, 0, 0),
                          radius: 30,
                          child: IconButton(
                            onPressed: _pickImage,
                            icon: Icon(
                              Icons.camera_alt,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),

                  SizedBox(width: 10),
                  Text("chose profile photo"),
                  SizedBox(width: 10),
                ],
              ),

              const SizedBox(height: 20),

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
                    _registerUser();
                    print("sign up successfully");
                    Navigator.pushReplacementNamed(context, '/login');
                  }
                },
                child: const Text(
                  'Sign Up',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: TextStyle(color: Colors.grey),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: Text("Login", style: TextStyle(color: Colors.black)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
