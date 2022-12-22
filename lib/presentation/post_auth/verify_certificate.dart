import 'dart:math';

import 'package:dcob/bussiness/bloc/wallet_bloc.dart';
import 'package:dcob/bussiness/helper/contract_helper.dart';
import 'package:dcob/data/models/certificate.dart';
import 'package:dcob/presentation/common/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:web3dart/web3dart.dart';

class VerifyCertificates extends StatefulWidget {
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
                  const SizedBox(width: 10.0,),
                  MaterialButton(
                    height: MediaQuery.of(context).size.height * 0.06,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
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
                    child: const Icon(Icons.search, color: Colors.white,),
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
                elevation: 5.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.network(
                      certificate!.imageUrl,
                      fit: BoxFit.contain,
                    ),
                    const Divider(),
                    Text(
                      "ID : ${certificate!.id}",
                      style: const TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      "From : ${certificate!.issuer}",
                      style: const TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      "To : ${certificate!.receiver}",
                      style: const TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                      ),
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
