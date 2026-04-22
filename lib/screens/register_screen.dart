import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool loading = false;

  Future<void> register() async {

    if(!formKey.currentState!.validate()) return;

    setState(() {
      loading = true;
    });

    try{

      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registration Successful"))
      );

      Navigator.pop(context);

    } catch(e){

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()))
      );

    }

    setState(() {
      loading = false;
    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.blue.shade50,

      body: Center(

        child: SingleChildScrollView(

          child: Container(

            width: 350,
            padding: const EdgeInsets.all(25),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 10
                )
              ]
            ),

            child: Form(
              key: formKey,
              child: Column(

                mainAxisSize: MainAxisSize.min,

                children: [

                  const Icon(
                    Icons.person_add,
                    size: 60,
                    color: Colors.blue,
                  ),

                  const SizedBox(height:10),

                  const Text(
                    "Create Account",
                    style: TextStyle(
                      fontSize:22,
                      fontWeight: FontWeight.bold
                    ),
                  ),

                  const SizedBox(height:20),

                  // EMAIL
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (value){
                      if(value!.isEmpty) return "Enter Email";
                      if(!value.contains("@")) return "Enter valid email";
                      return null;
                    },
                  ),

                  const SizedBox(height:12),

                  // PASSWORD
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Password",
                      prefixIcon: Icon(Icons.lock),
                    ),
                    validator: (value){
                      if(value!.isEmpty) return "Enter Password";
                      if(value.length < 6) return "Minimum 6 characters";
                      return null;
                    },
                  ),

                  const SizedBox(height:20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: loading ? null : register,
                      child: loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Register"),
                    ),
                  ),

                  const SizedBox(height:10),

                  TextButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: const Text("Already have account? Login"),
                  )

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}