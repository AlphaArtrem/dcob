import 'package:dcob/business/bloc/wallet_bloc.dart';
import 'package:dcob/presentation/post_auth/home_screen.dart';
import 'package:dcob/presentation/pre_auth/wallet_setup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
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
        if(state is WalletNotFoundState){
          Navigator.of(context).pushReplacementNamed(WalletSetupScreen.route);
        }else if(state is WalletDetailsState){
          Navigator.of(context).pushReplacementNamed(HomeScreen.route);
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: Container(
          color: Colors.cyan,
          child: const Center(
            child: Text(
              "DCOB",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
