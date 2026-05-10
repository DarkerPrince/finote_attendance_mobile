import 'package:finote_program/View/Auth/SignupPage.dart';
import 'package:finote_program/View/HomePage.dart';
import 'package:finote_program/features/auth/auth_bloc.dart';
import 'package:finote_program/features/auth/auth_event.dart';
import 'package:finote_program/features/auth/auth_state.dart';
import 'package:finote_program/utils/animationUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isPasswordHidden = true;

  void _login() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Email and password cannot be empty"),
        ),
      );
      return;
    }

    context.read<AuthBloc>().add(
      LoginRequested(email: email, password: password),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffECECEC),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => MyHomePage(userId: state.user.id),
              ),
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return Center(
            child: SingleChildScrollView(
              child: Container(
                width: 360,
                margin: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(35),
                ),
                child: Column(
                  children: [
                    // TOP DESIGN
                    Container(
                      height: 320,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Color(0xffF7F7F7),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(35),
                          topRight: Radius.circular(35),
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 30,
                            right: -50,
                            child: _circleOutline(170),
                          ),
                          Positioned(
                            bottom: -60,
                            left: -70,
                            child: _circleOutline(200),
                          ),
                          Positioned(
                            bottom: 20,
                            right: -40,
                            child: _circleDesign(150),
                          ),

                          Positioned(
                            left: 28,
                            top: 20,
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Image.asset('assets/placeholder/logo_home.png', fit: BoxFit.cover, height: 100,width: 100,),
                                Text(
                                  "Finote Tsidk",
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w700,
                                    height: 1.2,
                                  ),
                                ),
                                Text(
                                  "Sunday.S.",
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w700,
                                    height: 1.2,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  "Join our community",
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // FORM SECTION
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 24,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Log in",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          const SizedBox(height: 24),

                          // EMAIL FIELD
                          TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              hintText: "Phone or Email",
                              filled: true,
                              fillColor: const Color(0xffF7F7F7),
                              suffixIcon: const Icon(
                                Icons.check,
                                color: Colors.blue,
                              ),
                              contentPadding:
                              const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 18,
                              ),
                              border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.circular(14),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // PASSWORD FIELD
                          TextField(
                            controller: _passwordController,
                            obscureText: isPasswordHidden,
                            decoration: InputDecoration(
                              hintText: "************",
                              filled: true,
                              fillColor: const Color(0xffF7F7F7),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isPasswordHidden
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isPasswordHidden =
                                    !isPasswordHidden;
                                  });
                                },
                              ),
                              contentPadding:
                              const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 18,
                              ),
                              border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.circular(14),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // LOGIN BUTTON
                          state is AuthLoading
                              ? const Center(
                            child:
                            CircularProgressIndicator(),
                          )
                              : SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: _login,
                              style:
                              ElevatedButton.styleFrom(
                                backgroundColor:
                                const Color(0xff0057FF),
                                elevation: 3,
                                shape:
                                RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(
                                      14),
                                ),
                              ),
                              child: const Text(
                                "Sign in",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight:
                                  FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            child: const Text(
                              "Forgot password?",
                              style: TextStyle(
                                color: Colors.black54,
                              ),
                            ),
                          ),

                          const SizedBox(height: 30),

                          Center(
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Don't have an account? ",
                                  style: TextStyle(
                                    color: Colors.black54,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      createRouteAnimation(
                                        const SignupPage(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "Sign up",
                                    style: TextStyle(
                                      color: Color(0xff0057FF),
                                      fontWeight:
                                      FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _circleDesign(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xff0057FF),
          width: 4,
        ),
      ),
    );
  }

  Widget _circleOutline(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.grey.shade300,
          width: 25,
        ),
      ),
    );
  }
}