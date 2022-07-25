import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagramclone/resources/auth_methods.dart';
import 'package:instagramclone/screens/tonav.dart';
import 'package:instagramclone/utils/utils.dart';
import 'package:instagramclone/widgets/text_field_input.dart';

import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layout.dart';

class SignupScreen extends StatefulWidget {
  SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void signUpUser() async {
    String res = await Authmethods().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
      bio: _bioController.text,
      file: _image!,
    );
    if (res != 'success') {
      showSnackBar(res, context); // Add stuffin this
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
                mobileScreenLayout: MobileScreenLayout(),
                webScreenLayout: WebScreenLayout(),
              )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 10,
            ),
            Center(
              child: SvgPicture.asset(
                'assets/ic_instagram.svg',
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Stack(children: [
              Row(
                children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(_image!),
                        )
                      : CircleAvatar(
                          radius: 64,
                          backgroundImage: NetworkImage(
                              'https://www.pngfind.com/pngs/m/169-1699926_user-plus-user-user-add-profile-add-profile.png')),
                  Stack(children: [
                    IconButton(
                      onPressed: selectImage,
                      icon: Icon(Icons.add_a_photo),
                    ),
                  ]),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    children: [Text('Name'), Text('Bio')],
                  )
                ],
              ),
            ]),
            SizedBox(height: 30),
            TextFieldInput(
                textEditingController: _usernameController,
                hintText: 'Enter Username',
                textInputType: TextInputType.emailAddress),
            SizedBox(
              height: 10,
            ),
            TextFieldInput(
                textEditingController: _emailController,
                hintText: 'Enter Email',
                textInputType: TextInputType.emailAddress),
            SizedBox(
              height: 10,
            ),
            TextFieldInput(
                textEditingController: _passwordController,
                hintText: 'Enter Password',
                textInputType: TextInputType.text,
                isPass: true),
            SizedBox(
              height: 10,
            ),
            TextFieldInput(
                textEditingController: _bioController,
                hintText: 'Enter Bio',
                textInputType: TextInputType.text),
            SizedBox(
              height: 15,
            ),
            InkWell(
              onTap: signUpUser,
              child: Container(
                width: double.infinity,
                child: Text(
                  'Sign Up',
                  style: TextStyle(color: Colors.white),
                ),
                alignment: Alignment.center,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: Colors.blue, borderRadius: BorderRadius.circular(4)),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
