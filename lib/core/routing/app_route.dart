import 'package:e_commerce/features/login/presentation/register_screen.dart';
import 'package:e_commerce/features/login/presentation/welcome_screen.dart';
import 'package:e_commerce/features/views/product_details_screen.dart';
import 'package:e_commerce/features/views/product_list_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../features/login/presentation/login_screen.dart';
import '../../features/views/product_screen.dart';
import "routes.dart";

class AppRouter {
  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.homeScreen:
        return MaterialPageRoute(builder: (_) => const ProductScreen()); // ✅

      case Routes.loginscreen:
        return MaterialPageRoute(builder: (_) => LoginScreen()); // ✅

      // case Routes.detailscreen:
      //   return MaterialPageRoute(builder: (_) =>  ProductDetailsScreen(product: null,));
      // case Routes.createProduct:
      //   return MaterialPageRoute(builder:(_) =>   ProductDetailsScreen(product: ));
      case Routes.welcomescreen:
        return MaterialPageRoute(
          builder: (_) =>
              WelcomeScreen(), // Assuming you have a WelcomeScreen widget
        );

      case Routes.registerscreen:
        return MaterialPageRoute(builder: (_) => RegisterScreen());
     
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text("No route defined for ${settings.name}"),
            ),
          ),
        );
    }
  }
}
