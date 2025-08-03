import 'package:e_commerce/core/routing/app_route.dart';
import 'package:e_commerce/core/routing/routes.dart';
import 'package:e_commerce/features/login/cubit/login_cubit.dart';
import 'package:e_commerce/features/login/cubit/register_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

import 'features/cubit/product_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ProductCubit(Dio())..fetchProducts()),
        BlocProvider(create: (_) => LoginCubit(Dio())),
        BlocProvider<RegisterCubit>(
          create: (context) => RegisterCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: Routes.welcomescreen,
        onGenerateRoute: AppRouter().generateRoute,
      ),
    );
  }
}
