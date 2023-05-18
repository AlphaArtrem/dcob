import 'package:dcob/presentation/common/buttons.dart';
import 'package:dcob/business/bloc/wallet_bloc.dart';
import 'package:dcob/presentation/pre_auth/wallet_success_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WalletCreatedScreen extends StatelessWidget {
  static const String route = '/wallet_created';
  const WalletCreatedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the mnemonic from the global bloc
    String mnemonic =
        (context.watch<WalletBloc>().state as WalletDetailsState).mnemonic;
    // Split the mnemonic into a list of words
    final mnemonicWords = mnemonic.split(' ');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet Created'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Display the mnemonic in 12 round cornered boxes, two boxes in each row
          for (int i = 0; i < mnemonicWords.length; i += 2)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.grey[200],
                      ),
                      child: Text(
                        mnemonicWords[i],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.grey[200],
                      ),
                      child: Text(
                        mnemonicWords[i + 1],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(
            height: 40.0,
          ),
          // Add a copy button
          primaryButton(
            onTap: () async {
              // Copy the mnemonic to the clipboard and show a toast notification
              await Clipboard.setData(ClipboardData(text: mnemonic)).then(
                (value) => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Mnemonic copied to clipboard'),
                  ),
                ),
              );
            },
            text: "Copy Mnemonic",
            isFilled: false,
            fontSize: 14.0,
          ),
          const SizedBox(
            height: 10.0,
          ),
          // Add a continue button
          primaryButton(
            onTap: () {
              // Navigate to WalletSuccessScreen
              Navigator.of(context).pushNamed(WalletSuccessScreen.route);
            },
            text: "Continue",
          )
        ],
      ),
    );
  }
}
