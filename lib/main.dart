import 'package:dcob/presentation/post_auth/create_certificate.dart';
import 'package:dcob/presentation/post_auth/created_certificates.dart';
import 'package:dcob/presentation/post_auth/home_screen.dart';
import 'package:dcob/presentation/post_auth/received_certificates.dart';
import 'package:dcob/presentation/post_auth/verify_certificate.dart';
import 'package:dcob/presentation/post_auth/voting_screen.dart';
import 'package:dcob/presentation/splash_screen.dart';
import 'package:dcob/presentation/pre_auth/wallet_setup_screen.dart';
import 'package:dcob/presentation/pre_auth/recover_wallet_screen.dart';
import 'package:dcob/presentation/pre_auth/wallet_created_screen.dart';
import 'package:dcob/business/bloc/wallet_bloc.dart';
import 'package:dcob/presentation/pre_auth/wallet_success_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final GlobalKey<NavigatorState> navigationKey = GlobalKey();

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
        navigatorKey: navigationKey,
        title: 'DCOB',
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
        routes: {
          WalletSetupScreen.route : (context) => const WalletSetupScreen(),
          WalletCreatedScreen.route : (context) => const WalletCreatedScreen(),
          WalletSuccessScreen.route : (context) => const WalletSuccessScreen(),
          RecoverWalletScreen.route : (context) => const RecoverWalletScreen(),
          CreateCertificateScreen.route : (context) => const CreateCertificateScreen(),
          CreatedCertificatesScreen.route: (context) =>
              const CreatedCertificatesScreen(),
          ReceivedCertificatesScreen.route: (context) =>
              const ReceivedCertificatesScreen(),
          HomeScreen.route: (context) => const HomeScreen(),
          VerifyCertificates.route: (context) => const VerifyCertificates(),
          VotingScreen.route : (context) => const VotingScreen(),
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
