import 'package:dcob/presentation/post_auth/create_certificate.dart';
import 'package:dcob/presentation/splash_screen.dart';
import 'package:dcob/presentation/pre_auth/wallet_setup_screen.dart';
import 'package:dcob/presentation/pre_auth/recover_wallet_screen.dart';
import 'package:dcob/presentation/pre_auth/wallet_created_screen.dart';
import 'package:dcob/bussiness/bloc/wallet_bloc.dart';
import 'package:dcob/presentation/pre_auth/wallet_success_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WalletBloc(),
      child: MaterialApp(
        title: 'Flutter Ethereum Wallet',
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
        routes: {
          '/wallet_setup_screen': (context) => const WalletSetupScreen(),
          '/wallet_created': (context) => const WalletCreatedScreen(),
          '/wallet_success': (context) => const WalletSuccessScreen(),
          '/recover_wallet': (context) => const RecoverWalletScreen(),
          '/create_certificate': (context) => const CreateCertificateScreen(),
        },
        theme: ThemeData.light().copyWith(
          appBarTheme: const AppBarTheme(
            color: Colors.cyan,
          ),
        ),
      ),
    );
  }
}
