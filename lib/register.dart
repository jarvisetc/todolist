import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todolist_1/login.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isObCure = true;
  final _validationKey = GlobalKey<FormState>();
  bool isLoading = false;
  Future register() async {
    if (_validationKey.currentState!.validate()) {
      try {
        setState(() {
          isLoading = true;
        });
        var cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);

        await FirebaseFirestore.instance
            .collection("users")
            .doc(cred.user?.uid)
            .set({
          "name": nameController.text.trim(),
          "email": emailController.text.trim(),
          "uid": cred.user?.uid
        });

        setState(() {
          isLoading = false;
        });
      } on FirebaseException catch (e) {
        print(e.message);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("${e.message}")));
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.purple,
                  ),
                )
              : SingleChildScrollView(
                  child: Form(
                    key: _validationKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          "Register",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          "Welcome to ToDo! Please Register to continue",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                        ),
                        Form(
                            child: Column(
                          children: [
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Name Field is required";
                                } else if (value.length < 3) {
                                  return "Enter a Valid name";
                                } else {
                                  return null;
                                }
                              },
                              controller: nameController,
                              decoration: const InputDecoration(
                                labelText: "Name",
                                hintText: "Enter Your name",
                                prefixIcon: Icon(
                                  Icons.person,
                                ),
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Email Field is required";
                                } else if (value.length < 3 ||
                                    !value.contains(".") &&
                                        !value.contains("@")) {
                                  return "Enter a Valid Email";
                                } else {
                                  return null;
                                }
                              },
                              controller: emailController,
                              decoration: const InputDecoration(
                                labelText: " Confirm Email",
                                hintText: "Enter Your Email",
                                prefixIcon: Icon(
                                  Icons.email_rounded,
                                ),
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Email Field is required";
                                } else if (value.length < 6) {
                                  return "Enter a Valid Email";
                                } else {
                                  return null;
                                }
                              },
                              controller: passwordController,
                              obscureText: isObCure,
                              decoration: InputDecoration(
                                labelText: "Password",
                                hintText: "Enter Your Password",
                                prefixIcon: const Icon(
                                  Icons.password_outlined,
                                ),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isObCure = !isObCure;
                                    });
                                  },
                                  child: Icon(
                                    isObCure
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                  ),
                                ),
                                border: const OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Email Field is required";
                                } else if (value.length < 3 ||
                                    !value.contains(".") &&
                                        !value.contains("@")) {
                                  return "Enter a Valid Email";
                                } else {
                                  return null;
                                }
                              },
                              controller: passwordController,
                              obscureText: isObCure,
                              decoration: InputDecoration(
                                labelText: "Confirm Password",
                                hintText: "Enter Your Password",
                                prefixIcon: const Icon(
                                  Icons.password_outlined,
                                ),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isObCure = !isObCure;
                                    });
                                  },
                                  child: Icon(
                                    isObCure
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                  ),
                                ),
                                border: const OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const SizedBox(
                              height: 100,
                            ),
                            GestureDetector(
                              onTap: register,
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                    color: Colors.purple,
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Center(
                                  child: Text(
                                    "Register",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Already Have An Account?",
                                  style: TextStyle(fontSize: 16),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginScreen()));
                                  },
                                  child: const Text(
                                    "Login",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.purple,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ))
                      ],
                    ),
                  ),
                ),
        ));
  }
}
