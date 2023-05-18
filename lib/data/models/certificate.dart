import 'package:web3dart/credentials.dart';

class Certificate {
  final BigInt id;
  final EthereumAddress issuer;
  final EthereumAddress receiver;
  final String imageUrl;

  Certificate({
    required this.issuer,
    required this.receiver,
    required this.imageUrl,
    required this.id,
  });
}
