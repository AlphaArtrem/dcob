import 'dart:math';

import 'package:dcob/business/bloc/wallet_bloc.dart';
import 'package:dcob/presentation/common/buttons.dart';
import 'package:dcob/presentation/post_auth/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:web3dart/web3dart.dart';

class WalletSuccessScreen extends StatelessWidget {
  static const String route = '/wallet_success';
  const WalletSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the mnemonic from the global bloc
    final WalletDetailsState walletDetailsState =
        context.watch<WalletBloc>().state as WalletDetailsState;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet Details'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Card(
            color: Colors.white,
            elevation: 2.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Wallet Address",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    walletDetailsState.publicKey.hex,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  QrImage(
                    data: walletDetailsState.publicKey.hex,
                    version: QrVersions.auto,
                    size: 200,
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  const Text(
                    "Wallet Balance",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  FutureBuilder<EtherAmount>(
                      future: walletDetailsState.web3client
                          .getBalance(walletDetailsState.publicKey),
                      builder: (context, snapshot) {
                        return Text(
                          snapshot.data != null
                              ? '${snapshot.data!.getInWei.toInt() / pow(10, 18)} MATIC'
                              : '',
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        );
                      }),
                  const SizedBox(
                    height: 20.0,
                  ),
                  // Add a copy button
                  primaryButton(
                    onTap: () async {
                      // Copy the mnemonic to the clipboard and show a toast notification
                      await Clipboard.setData(ClipboardData(
                              text: walletDetailsState.publicKey.hex))
                          .then(
                        (value) => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Address copied to clipboard'),
                          ),
                        ),
                      );
                    },
                    text: "Copy Address",
                    isFilled: false,
                    fontSize: 14.0,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  primaryButton(
                    onTap: () {
                      // Navigate back to the home screen
                      Navigator.of(context).pushReplacementNamed(HomeScreen.route);
                    },
                    text: 'Continue',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
