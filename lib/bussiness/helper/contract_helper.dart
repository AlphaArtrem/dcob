import 'dart:convert';

import 'package:dcob/bussiness/bloc/wallet_bloc.dart';
import 'package:dcob/bussiness/helper/api_helper.dart';
import 'package:dcob/data/static/api_constants.dart';
import 'package:dcob/data/models/certificate.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:web3dart/web3dart.dart';

class ContractHelper {
  ContractHelper._();

  static final Logger _logger = Logger();

  static Future<DeployedContract> loadContract({
    required String abiJsonPath,
    required String contractAddress,
    required String name,
  }) async {
    String abi = await rootBundle.loadString(abiJsonPath);
    DeployedContract contract = DeployedContract(
      ContractAbi.fromJson(
        abi,
        name,
      ),
      EthereumAddress.fromHex(contractAddress),
    );
    return contract;
  }

  static Future<List<dynamic>> query({
    required WalletDetailsState walletDetailsState,
    required String functionName,
    required List<dynamic> args,
  }) async {
    ContractFunction ethFunction =
        walletDetailsState.certificateContract.function(functionName);
    List<dynamic> result = await walletDetailsState.web3client.call(
      contract: walletDetailsState.certificateContract,
      function: ethFunction,
      params: args,
      sender: walletDetailsState.publicKey,
    );
    return result;
  }

  static Future<String> submit({
    required WalletDetailsState walletDetailsState,
    required String functionName,
    required List<dynamic> args,
  }) async {
    ContractFunction ethFunction =
        walletDetailsState.certificateContract.function(functionName);
    Transaction transaction = Transaction.callContract(
      contract: walletDetailsState.certificateContract,
      function: ethFunction,
      parameters: args,
    );
    String result = await walletDetailsState.web3client.sendTransaction(
      walletDetailsState.privateKey,
      transaction,
      chainId: 5,
    );
    return result;
  }

  static Future<String> uploadImageToIpfs(String filePath) async {
    Map<String, dynamic> env =
        jsonDecode(await rootBundle.loadString("assets/env.json"));
    List<int> utfAuth = utf8
        .encode("${env["ipfsInfuraApiKey"]}:${env["ipfsInfuraApiSecretKey"]}");
    String base64Auth = base64.encode(utfAuth);
    Map<String, dynamic> response = await ApiHelper.uploadFile(
      ApiConstants.ipfsUploadFile,
      filePath: filePath,
      fileField: "file",
      bearerToken: base64Auth,
    );
    String hash = response["Hash"];
    String imageUrl = "https://ipfs.io/ipfs/$hash";
    return imageUrl;
  }

  static Future<String> mintCertificate({
    required String ipfsImageUrl,
    required WalletDetailsState walletDetailsState,
    required EthereumAddress receiverAddress,
  }) async {
    String transactionHash = await submit(
      walletDetailsState: walletDetailsState,
      functionName: "createCertificate",
      args: [
        receiverAddress,
        ipfsImageUrl,
      ],
    );
    return transactionHash;
  }

  static Future<bool> isIssuer(WalletDetailsState walletDetailsState) async {
    List<dynamic> result = await query(
      walletDetailsState: walletDetailsState,
      functionName: "isIssuer",
      args: [walletDetailsState.publicKey],
    );
    return result[0];
  }

  static Future<Certificate> getCertificateById({
    required WalletDetailsState walletDetailsState,
    required BigInt id,
  }) async {
    return Certificate(
      issuer: await getCertificateIssuer(
        walletDetailsState: walletDetailsState,
        id: id,
      ),
      receiver: walletDetailsState.publicKey,
      imageUrl: await getCertificateImage(
        walletDetailsState: walletDetailsState,
        id: id,
      ),
      id: id,
    );
  }

  static Future<List<Certificate>> getCreatedCertificates(
      WalletDetailsState walletDetailsState) async {
    List<dynamic> result = await query(
      walletDetailsState: walletDetailsState,
      functionName: "getCreatedCertificates",
      args: [walletDetailsState.publicKey],
    );

    List<Certificate> certificates = [];
    for (BigInt id in result[0]) {
      certificates.add(await getCertificateById(
        walletDetailsState: walletDetailsState,
        id: id,
      ));
    }
    return certificates;
  }

  static Future<List<Certificate>> getReceivedCertificates(
      WalletDetailsState walletDetailsState) async {
    List<dynamic> result = await query(
      walletDetailsState: walletDetailsState,
      functionName: "getReceivedCertificates",
      args: [walletDetailsState.publicKey],
    );

    List<Certificate> certificates = [];
    for (BigInt id in result[0]) {
      certificates.add(await getCertificateById(
        walletDetailsState: walletDetailsState,
        id: id,
      ));
    }
    return certificates;
  }

  static Future<EthereumAddress> getCertificateIssuer({
    required WalletDetailsState walletDetailsState,
    required BigInt id,
  }) async {
    try {
      List<dynamic> result = await query(
        walletDetailsState: walletDetailsState,
        functionName: "getCertificateIssuer",
        args: [id],
      );
      return result[0];
    } catch (e) {
      _logger.d(e);
      rethrow;
    }
  }

  static Future<String> getCertificateImage({
    required WalletDetailsState walletDetailsState,
    required BigInt id,
  }) async {
    List<dynamic> result = await query(
      walletDetailsState: walletDetailsState,
      functionName: "tokenURI",
      args: [id],
    );
    return result[0];
  }
}
