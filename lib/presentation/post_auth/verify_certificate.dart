import 'package:cached_network_image/cached_network_image.dart';
import 'package:dcob/business/bloc/wallet_bloc.dart';
import 'package:dcob/business/helper/contract_helper.dart';
import 'package:dcob/data/models/certificate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerifyCertificates extends StatefulWidget {
  static const String route = '/verify_certificate';
  const VerifyCertificates({super.key});

  @override
  State<VerifyCertificates> createState() => _VerifyCertificatesState();
}

class _VerifyCertificatesState extends State<VerifyCertificates> {
  final TextEditingController _certificateID = TextEditingController();
  Certificate? certificate;

  @override
  Widget build(BuildContext context) {
    // Get the mnemonic from the global bloc
    final WalletDetailsState walletDetailsState =
        context.watch<WalletBloc>().state as WalletDetailsState;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Certificates'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.06,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _certificateID,
                      decoration: InputDecoration(
                        labelText: 'Certificate ID',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  MaterialButton(
                    height: MediaQuery.of(context).size.height * 0.06,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                    onPressed: () async {
                      await ContractHelper.getCertificateById(
                              walletDetailsState: walletDetailsState,
                              id: BigInt.parse(_certificateID.text))
                          .then((value) => setState(() {
                                certificate = value;
                              }))
                          .onError((error, stackTrace) => setState(() {
                                certificate = null;
                              }));
                    },
                    color: Colors.cyan,
                    child: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            if (_certificateID.text.isNotEmpty && certificate == null)
              const Expanded(
                  child: Text(
                "Certificate Not Found",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                  fontSize: 18.0,
                ),
              ))
            else if (certificate != null)
              Card(
                color: Colors.white,
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                        top: 20.0,
                      ),
                      child: CachedNetworkImage(
                        imageUrl: certificate!.imageUrl,
                        fit: BoxFit.contain,
                        imageBuilder: (_, provider) {
                          return Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: provider,
                                fit: BoxFit.fill,
                              ),
                              border: Border.all(color: Colors.grey),
                            ),
                            height: MediaQuery.of(context).size.height * 0.3,
                          );
                        },
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Divider(thickness: 2),
                    ),
                    const Text(
                      "Certificate ID",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      "#${certificate!.id}",
                      style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    const Text(
                      "From",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      '${certificate!.issuer.hex.substring(0, 8)}....${certificate!.issuer.hex.substring(certificate!.issuer.hex.length - 8)}',
                      style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    const Text(
                      "To",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      '${certificate!.receiver.hex.substring(0, 8)}....${certificate!.receiver.hex.substring(certificate!.receiver.hex.length - 8)}',
                      style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                    const SizedBox(
                      height: 7.5,
                    ),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}
