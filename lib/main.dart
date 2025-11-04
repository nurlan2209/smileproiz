import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smileproiz/screens/home_screen.dart';
import 'package:smileproiz/screens/catalog_screen.dart';
import 'package:smileproiz/screens/product_screen.dart';
import 'package:smileproiz/screens/cart_screen.dart';
import 'package:smileproiz/screens/profile_screen.dart';
import 'package:smileproiz/screens/checkout_screen.dart';
import 'package:smileproiz/screens/login_screen.dart';
import 'package:smileproiz/screens/register_screen.dart';
import 'package:smileproiz/provider/cart_provider.dart';
import 'package:smileproiz/screens/admin_screen.dart';
import 'package:smileproiz/screens/delivery_addresses_screen.dart';
import 'package:smileproiz/screens/payment_methods_screen.dart';
import 'package:smileproiz/screens/account_settings_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MØRK STORE',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF00FF87),
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
        fontFamily: 'SF Pro Display',
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF00FF87),
          secondary: const Color(0xFF00D9FF),
          surface: const Color(0xFF1A1A1A),
          background: const Color(0xFF0A0A0A),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0A0A0A),
          elevation: 0,
        ),
      ),
      initialRoute: '/', // Убедитесь, что это HomeScreen
      routes: {
        '/': (context) => const HomeScreen(), // Главный экран с BottomNavigation
        '/catalog': (context) => const CatalogScreen(),
        '/product': (context) => const ProductScreen(),
        '/cart': (context) => const CartScreen(),
        '/admin': (context) => const AdminScreen(), // 🆕 Админка
        '/delivery-addresses': (context) => const DeliveryAddressesScreen(),
        '/payment-methods': (context) => const PaymentMethodsScreen(),
        '/account-settings': (context) => const AccountSettingsScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/checkout': (context) => const CheckoutScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
      },
    );
  }
}