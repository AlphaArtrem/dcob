import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';

class ContractHelper {
  ContractHelper._();

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
    required DeployedContract contract,
    required String functionName,
    required List<dynamic> args,
    required Web3Client web3client,
  }) async {
    ContractFunction ethFunction = contract.function(functionName);
    List<dynamic> result = await web3client.call(
      contract: contract,
      function: ethFunction,
      params: args,
    );
    return result;
  }
}
