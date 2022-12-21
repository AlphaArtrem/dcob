import 'dart:math';

import 'package:dcob/bussiness/bloc/wallet_bloc.dart';
import 'package:dcob/presentation/common/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web3dart/web3dart.dart';

class WalletSuccessScreen extends StatelessWidget {
  const WalletSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the mnemonic from the global bloc
    final WalletDetailsState walletDetailsState =
        context.watch<WalletBloc>().state as WalletDetailsState;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet Success'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Wallet address: ${walletDetailsState.publicKey.hex}\n',
              textAlign: TextAlign.center,
            ),
            FutureBuilder<EtherAmount>(
                future: walletDetailsState.web3client
                    .getBalance(walletDetailsState.publicKey),
                builder: (context, snapshot) {
                  return Text(
                    snapshot.data != null
                        ? 'Wallet balance : ${snapshot.data!.getInWei.toInt() / pow(10, 18)} ETH'
                        : '',
                    textAlign: TextAlign.center,
                  );
                }),
            const Text('\n\nWallet loaded successfully\n\n'),
            // Add a copy button
            primaryButton(
              onTap: () async {
                // Copy the mnemonic to the clipboard and show a toast notification
                await Clipboard.setData(
                        ClipboardData(text: walletDetailsState.publicKey.hex))
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
              height: 20.0,
            ),
            primaryButton(
              onTap: () {
                // Navigate back to the home screen
                Navigator.of(context).pushNamed('create_certificate');
              },
              text: 'Continue',
            ),
          ],
        ),
      ),
    );
  }
}
