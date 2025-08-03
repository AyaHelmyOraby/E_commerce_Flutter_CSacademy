import 'package:e_commerce/core/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/register_cubit.dart';
import '../cubit/register_states.dart';

class RegisterScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('✅ Registration successful!')),
            );
            Navigator.pushReplacementNamed(context, Routes.loginscreen);
          } else if (state is RegisterFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('❌ ${state.error}')),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Form(
                key: _formKey,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Image.asset(
                      "assets/images/ecommerce.jpg",
                      height: 100,
                      width: 100,
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Register",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        labelText: "Username",
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) =>
                          val!.isEmpty ? "Enter username" : null,
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) => val!.isEmpty ? "Enter email" : null,
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) =>
                          val!.isEmpty ? "Enter password" : null,
                    ),
                    SizedBox(height: 25),
                    ElevatedButton(
                      onPressed: state is RegisterLoading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                context.read<RegisterCubit>().register(
                                      username: usernameController.text,
                                      email: emailController.text,
                                      password: passwordController.text,
                                    );
                              }
                              Navigator.pushReplacementNamed(
                                  context, Routes.homeScreen);
                            },
                      child: state is RegisterLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text("Register"),
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
}
