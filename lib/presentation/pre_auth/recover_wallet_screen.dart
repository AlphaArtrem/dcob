import 'package:dcob/business/bloc/wallet_bloc.dart';
import 'package:dcob/presentation/common/buttons.dart';
import 'package:dcob/presentation/pre_auth/wallet_success_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecoverWalletScreen extends StatefulWidget {
  static const String route = '/recover_wallet';
  const RecoverWalletScreen({super.key});

  @override
  State<RecoverWalletScreen> createState() => _RecoverWalletScreenState();
}

class _RecoverWalletScreenState extends State<RecoverWalletScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _mnemonicWords =
      List.generate(12, (index) => TextEditingController());
  late final WalletBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<WalletBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WalletBloc, WalletState>(
      bloc: _bloc,
      listener: (BuildContext context, state) {
        if (state is WalletDetailsState) {
          // Navigate to WalletSuccessScreen
          Navigator.of(context).pushNamed(WalletSuccessScreen.route);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Recover Wallet'),
          centerTitle: true,
        ),
        body: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Display 12 text fields, two in each row, for the mnemonic words
              for (int i = 0; i < _mnemonicWords.length; i += 2)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 150.0,
                        child: TextFormField(
                          controller: _mnemonicWords[i],
                          decoration: InputDecoration(
                            hintText: 'Word ${i + 1}',
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            contentPadding: const EdgeInsets.only(left: 10.0),
                          ),
                          validator: (value) {
                            if (value != null && value.isEmpty) {
                              return 'Please enter a word';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            if (value.split(' ').length == 12) {
                              for (int i = 0; i < 12; i++) {
                                _mnemonicWords[i].text = value.split(' ')[i];
                              }
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 20.0,
                      ),
                      if (i + 1 < _mnemonicWords.length)
                        SizedBox(
                          width: 150.0,
                          child: TextFormField(
                            controller: _mnemonicWords[i + 1],
                            decoration: InputDecoration(
                              hintText: 'Word ${i + 2}',
                              border: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              contentPadding: const EdgeInsets.only(left: 10.0),
                            ),
                            validator: (value) {
                              if (value != null && value.isEmpty) {
                                return 'Please enter a word';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              if (value.split(' ').length == 12) {
                                for (int i = 0; i < 12; i++) {
                                  _mnemonicWords[i].text = value.split(' ')[i];
                                }
                              }
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              const SizedBox(
                height: 20.0,
              ),
              // Add a continue button
              primaryButton(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    // Join the mnemonic words into a single string and recover the wallet
                    String mnemonic = '';
                    for (int i = 0; i < _mnemonicWords.length; i++) {
                      mnemonic += _mnemonicWords[i].text +
                          (i < _mnemonicWords.length - 1 ? ' ' : '');
                    }
                    context.read<WalletBloc>().add(RecoverWallet(mnemonic));
                  }
                },
                text: 'Continue',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
