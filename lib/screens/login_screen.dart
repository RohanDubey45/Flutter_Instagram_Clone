import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram_flutter/resources/authentication_methods.dart';
import 'package:instagram_flutter/responsive/mobile_screen_layout.dart';
import 'package:instagram_flutter/responsive/responsive.dart';
import 'package:instagram_flutter/responsive/web_screen_layout.dart';
import 'package:instagram_flutter/screens/sign_up_screen.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/utils/utils.dart';
import 'package:instagram_flutter/widgets/text_input_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void signUpPage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) {
          return SignUp();
        },
      ),
    );
  }

  void loginUser() async {
    setState(() {
      isLoading = true;
    });

    String res = await AuthMethods().loginUser(
      email: _emailController.text,
      password: _passwordController.text,
    );

    setState(() {
      isLoading = false;
    });

    if (!mounted) return;

    if (res == "success") {
      debugPrint("Logged in user: ${FirebaseAuth.instance.currentUser!.uid}");
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) {
            return const ResponsiveLayout(
              webScreenLayout: WebScreenLayout(),
              mobileScreenLayout: MobileScreenLayout(),
            );
          },
        ),
      );
    } else {
      showSnackBar(res, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              Flexible(flex: 1, child: Container()),

              //svg
              SvgPicture.asset(
                "assets/ic_instagram.svg",
                colorFilter: ColorFilter.mode(primaryColor, BlendMode.srcIn),
                height: 55,
              ),

              const SizedBox(height: 30),

              // text field for email
              TextInputField(
                textEditingController: _emailController,
                hintText: "Enter your email",
                isPass: false,
                textInputType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 25),

              // text field for password
              TextInputField(
                textEditingController: _passwordController,
                hintText: "Enter your password",
                isPass: true,
                textInputType: TextInputType.text,
              ),

              const SizedBox(height: 25),

              // button for login
              InkWell(
                onTap: loginUser,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 14,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: blueColor,
                  ),
                  child:
                      isLoading
                          ? Center(
                            child: CircularProgressIndicator(
                              color: primaryColor,
                            ),
                          )
                          : Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                ),
              ),

              Flexible(flex: 1, child: Container()),

              // some txts like forgot password
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: signUpPage,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Text(
                        "Sign up.",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent
                        ),
                      ),
                    ),
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
