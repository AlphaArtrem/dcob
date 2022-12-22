import 'dart:math';

import 'package:dcob/bussiness/bloc/wallet_bloc.dart';
import 'package:dcob/presentation/common/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web3dart/web3dart.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const Map<String, String> _titleToScreens = {
    "Received Certificates": "/received_certificates",
    "Created Certificates": "/created_certificates",
    "Create Certificate": "/create_certificate",
    "Wallet Details": "/wallet_success",
    "Verify Certificates": "/verify_certificate",
    "Voting": "",
    "Voting Status": "",
  };

  static const Map<String, IconData> _titleToIcon = {
    "Received Certificates": Icons.card_membership,
    "Created Certificates": Icons.list_alt,
    "Create Certificate": Icons.add_card,
    "Wallet Details": Icons.account_balance_wallet,
    "Verify Certificates": Icons.search,
    "Voting": Icons.how_to_vote,
    "Voting Status": Icons.stacked_bar_chart,
  };

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    // Get the mnemonic from the global bloc
    final WalletDetailsState walletDetailsState =
        context.watch<WalletBloc>().state as WalletDetailsState;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          FutureBuilder<EtherAmount>(
            future: walletDetailsState.web3client
                .getBalance(walletDetailsState.publicKey),
            builder: (context, snapshot) {
              return Center(
                child: Text(
                  snapshot.data != null
                      ? '${(snapshot.data!.getInWei.toInt() / pow(10, 18)).toStringAsFixed(4)} ETH  '
                      : '',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          children: List.generate(
            HomeScreen._titleToScreens.length,
            (index) => MaterialButton(
              color: Colors.cyan,
              onPressed: () {
                String screen =
                    HomeScreen._titleToScreens.values.elementAt(index);
                if (screen.isEmpty) {
                  _showDialogue(
                    text:
                        'This feature is coming soon. You can currently use this feature using smart contract API on EtherScan.',
                    title: "Coming Soon!",
                  );
                } else {
                  if ((screen == "/create_certificate" ||
                          screen == "/created_certificates") &&
                      !walletDetailsState.isIssuer) {
                    return _showDialogue(
                        title: "Access Denied!",
                        text: "You are not an issuer.");
                  }
                  Navigator.pushNamed(context, screen);
                }
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    HomeScreen._titleToIcon.values.elementAt(index),
                    color: Colors.white,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    HomeScreen._titleToIcon.keys.elementAt(index),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDialogue({required String title, required String text}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(
            text,
            textAlign: TextAlign.justify,
          ),
          actions: [
            primaryButton(
              text: 'Close',
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
