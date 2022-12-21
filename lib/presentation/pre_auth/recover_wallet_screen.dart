import 'package:dcob/bussiness/bloc/wallet_bloc.dart';
import 'package:dcob/presentation/common/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecoverWalletScreen extends StatefulWidget {
  const RecoverWalletScreen({super.key});

  @override
  _RecoverWalletScreenState createState() => _RecoverWalletScreenState();
}

class _RecoverWalletScreenState extends State<RecoverWalletScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<String> _mnemonicWords = List.filled(12, '');
  late final WalletBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<WalletBloc>();
    _bloc.add(LoadWallet());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WalletBloc, WalletState>(
      bloc: _bloc,
      listener: (BuildContext context, state) {
        if (state is WalletDetailsState) {
          // Navigate to WalletSuccessScreen
          Navigator.of(context).pushNamed('/wallet_success');
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
                            setState(() {
                              _mnemonicWords[i] = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 20.0,),
                      if (i + 1 < _mnemonicWords.length)
                        SizedBox(
                          width: 150.0,
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Word ${i + 2}',
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
                              setState(() {
                                _mnemonicWords[i + 1] = value;
                              });
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
                    String mnemonic = _mnemonicWords.join(' ');
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
