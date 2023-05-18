import 'dart:convert';

import 'package:bip39/bip39.dart' as bip39;
import 'package:dart_bip32_bip44/dart_bip32_bip44.dart';
import 'package:dcob/bussiness/helper/contract_helper.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

// Global bloc to contain wallet credentials
class WalletBloc extends Bloc<WalletEvent, WalletState> {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static const String _mnemonicKey = "mnemonic";
  static const String contractAddress =
      "0x40D63a97D9E56E18882F267f2B91C4718A820690";
  static const String abiPath = "contracts/abi/abi.json";

  WalletBloc() : super(WalletNotFoundState()) {
    on<LoadWallet>(_loadWallet);

    on<CreateWallet>(_createWallet);

    on<RecoverWallet>(_recoverWallet);
  }

  Future<WalletDetailsState> _getWallet(String mnemonic) async {
    String seed = bip39.mnemonicToSeedHex(mnemonic);
    Chain chain = Chain.seed(seed);
    ExtendedKey key = chain.forPath("m/44'/60'/0'/0/0");
    String privateKeyHex = key.privateKeyHex().substring(2);
    EthPrivateKey privateKey = EthPrivateKey.fromHex(privateKeyHex);
    EthereumAddress publicKey = privateKey.address;
    String env = await rootBundle.loadString("assets/env.json");
    WalletDetailsState walletDetailsState = WalletDetailsState(
      mnemonic: mnemonic,
      privateKey: privateKey,
      publicKey: publicKey,
      web3client: Web3Client(
        jsonDecode(env)["infuraRpc"],
        Client(),
      ),
      certificateContract: await ContractHelper.loadContract(
        abiJsonPath: abiPath,
        contractAddress: contractAddress,
        name: "CERT",
      ),
      isIssuer: false,
    );
    return WalletDetailsState(
      mnemonic: mnemonic,
      privateKey: privateKey,
      publicKey: publicKey,
      web3client: walletDetailsState.web3client,
      certificateContract: walletDetailsState.certificateContract,
      isIssuer: await ContractHelper.isIssuer(walletDetailsState),
    );
  }

  void _loadWallet(LoadWallet event, Emitter emit) async {
    //await _storage.deleteAll();
    // Read the mnemonic from flutter_secure_storage
    String? mnemonic = await _storage.read(key: _mnemonicKey);
    if (mnemonic != null) {
      emit(await _getWallet(mnemonic));
    } else {
      emit(WalletNotFoundState());
    }
  }

  void _createWallet(CreateWallet event, Emitter emit) async {
    String mnemonic = bip39.generateMnemonic();
    await _storage.write(key: _mnemonicKey, value: mnemonic);
    emit(await _getWallet(mnemonic));
  }

  void _recoverWallet(RecoverWallet event, Emitter emit) async {
    String mnemonic = bip39.generateMnemonic();
    await _storage.write(key: _mnemonicKey, value: mnemonic);
    emit(await _getWallet(mnemonic));
  }
}

// Events for the WalletDetailsBloc
abstract class WalletEvent {}

class LoadWallet extends WalletEvent {}

class CreateWallet extends WalletEvent {}

class RecoverWallet extends WalletEvent {
  final String mnemonic;
  RecoverWallet(this.mnemonic);
}

abstract class WalletState {}

class WalletNotFoundState extends WalletState {}

// State for the WalletDetailsBloc
class WalletDetailsState extends WalletState {
  final String mnemonic;
  final EthPrivateKey privateKey;
  final EthereumAddress publicKey;
  final Web3Client web3client;
  final DeployedContract certificateContract;
  final bool isIssuer;

  WalletDetailsState({
    required this.mnemonic,
    required this.privateKey,
    required this.publicKey,
    required this.web3client,
    required this.certificateContract,
    required this.isIssuer,
  });
}
