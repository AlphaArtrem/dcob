import 'package:dcob/presentation/common/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dcob/bussiness/bloc/wallet_bloc.dart';

class WalletSetupScreen extends StatefulWidget {
  const WalletSetupScreen({super.key});

  @override
  State<WalletSetupScreen> createState() => _WalletSetupScreenState();
}

class _WalletSetupScreenState extends State<WalletSetupScreen> {
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
      listenWhen: (a, b)=>  a.runtimeType != b.runtimeType,
      listener: (BuildContext context, state) {
        if (state is WalletDetailsState) {
          // Navigate to WalletCreatedScreen
          Navigator.of(context).pushNamed('/wallet_created');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Ethereum Wallet Setup'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              primaryButton(
                onTap: () {
                  // Create a new wallet and navigate to WalletCreatedScreen
                  context.read<WalletBloc>().add(CreateWallet());
                },
                text: "Create Wallet",
              ),
              const SizedBox(
                height: 10.0,
              ),
              primaryButton(
                onTap: () {
                  // Navigate to RecoverWalletScreen
                  Navigator.of(context).pushNamed('/recover_wallet');
                },
                text: 'Recover Wallet',
              )
            ],
          ),
        ),
      ),
    );
  }
}
