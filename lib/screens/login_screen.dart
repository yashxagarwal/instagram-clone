import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagramclone/resources/auth_methods.dart';
import 'package:instagramclone/screens/signup_screen.dart';
import 'package:instagramclone/utils/utils.dart';
import 'package:instagramclone/widgets/text_field_input.dart';

import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    String res = await Authmethods().loginUser(
        email: _emailController.text, password: _passwordController.text);
    if (res == 'success') {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
                mobileScreenLayout: MobileScreenLayout(),
                webScreenLayout: WebScreenLayout(),
              )));
    } else {
      showSnackBar(res, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
      padding: EdgeInsets.symmetric(horizontal: 32),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Container(),
            flex: 2,
          ),
          SvgPicture.asset('assets/ic_instagram.svg'),
          SizedBox(height: 80),
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
            textInputType: TextInputType.emailAddress,
            isPass: true,
          ),
          const SizedBox(height: 24),
          InkWell(
            onTap: loginUser,
            child: Container(
              width: double.infinity,
              child: Text(
                'Log In',
                style: TextStyle(color: Colors.white),
              ),
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(4)),
            ),
          ),
          SizedBox(height: 14),
          Flexible(
            child: Container(
              decoration: BoxDecoration(),
            ),
            flex: 2,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account? "),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: ((context) => SignupScreen())));
                  },
                  child: Container(
                    child: Text(
                      'Sign Up',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    )));
  }
}
