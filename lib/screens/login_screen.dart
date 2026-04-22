import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool loading = false;

  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(_controller);

    _controller.forward();
  }

  // EMAIL LOGIN
  Future<void> login() async {

    if (!formKey.currentState!.validate()) return;

    setState(() {
      loading = true;
    });

    try {

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      Navigator.pushReplacementNamed(context, "/dashboard");

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );

    }

    setState(() {
      loading = false;
    });

  }

  // GOOGLE LOGIN
  Future<void> signInWithGoogle() async {

    try {

      GoogleAuthProvider googleProvider = GoogleAuthProvider();

      await FirebaseAuth.instance.signInWithPopup(googleProvider);

      Navigator.pushReplacementNamed(context, "/dashboard");

    } catch (e) {

      // ignore popup close error
      if (e.toString().contains('popup-closed-by-user')) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );

    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xffdfeaf4),

      body: Center(

        child: FadeTransition(

          opacity: _fade,

          child: SlideTransition(

            position: _slide,

            child: Container(

              width: 350,
              padding: const EdgeInsets.all(30),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  )
                ],
              ),

              child: Form(

                key: formKey,

                child: Column(

                  mainAxisSize: MainAxisSize.min,

                  children: [

                    const Icon(
                      Icons.menu_book_rounded,
                      size: 60,
                      color: Colors.blue,
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "Library Login",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 25),

                    // EMAIL
                    TextFormField(

                      controller: emailController,

                      decoration: InputDecoration(
                        hintText: "Email",
                        prefixIcon: const Icon(Icons.email_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),

                      validator: (value) {
                        if (value!.isEmpty) return "Enter Email";
                        if (!value.contains("@")) return "Enter valid email";
                        return null;
                      },
                    ),

                    const SizedBox(height: 15),

                    // PASSWORD
                    TextFormField(

                      controller: passwordController,
                      obscureText: true,

                      decoration: InputDecoration(
                        hintText: "Password",
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),

                      validator: (value) {
                        if (value!.isEmpty) return "Enter Password";
                        if (value.length < 6) return "Minimum 6 characters";
                        return null;
                      },
                    ),

                    const SizedBox(height: 22),

                    // LOGIN BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 48,

                      child: ElevatedButton(

                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),

                        onPressed: loading ? null : login,

                        child: loading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                "Login",
                                style: TextStyle(fontSize: 16),
                              ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // GOOGLE LOGIN
                    SizedBox(
                      width: double.infinity,
                      height: 48,

                      child: OutlinedButton.icon(

                        icon: Image.network(
                          "https://cdn-icons-png.flaticon.com/512/300/300221.png",
                          height: 20,
                        ),

                        label: const Text(
                          "Sign in with Google",
                          style: TextStyle(fontSize: 15),
                        ),

                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),

                        onPressed: signInWithGoogle,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // CREATE ACCOUNT
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/register");
                      },
                      child: const Text("Create Account"),
                    ),

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}