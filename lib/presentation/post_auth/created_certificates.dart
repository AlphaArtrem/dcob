import 'dart:math';

import 'package:dcob/bussiness/bloc/wallet_bloc.dart';
import 'package:dcob/bussiness/helper/contract_helper.dart';
import 'package:dcob/data/models/certificate.dart';
import 'package:dcob/presentation/common/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web3dart/web3dart.dart';

class CreatedCertificatesScreen extends StatefulWidget {
  const CreatedCertificatesScreen({super.key});

  @override
  State<CreatedCertificatesScreen> createState() =>
      _CreatedCertificatesScreenState();
}

class _CreatedCertificatesScreenState
    extends State<CreatedCertificatesScreen> {
  @override
  Widget build(BuildContext context) {
    // Get the mnemonic from the global bloc
    final WalletDetailsState walletDetailsState =
    context.watch<WalletBloc>().state as WalletDetailsState;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Created Certificates'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FutureBuilder(
          future: ContractHelper.getCreatedCertificates(walletDetailsState),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              if (snapshot.data!.isEmpty) {
                return const Center(
                  child: Text("No certificates found"),
                );
              } else {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    Certificate certificate = snapshot.data![index];
                    return Card(
                      elevation: 5.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.network(
                            certificate.imageUrl,
                            fit: BoxFit.contain,
                          ),
                          const Divider(),
                          Text(
                            "ID : ${certificate.id}",
                            style: const TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            "From : ${certificate.issuer}",
                            style: const TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            "To : ${certificate.receiver}",
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
                    );
                  },
                  itemCount: snapshot.data!.length,
                );
              }
            } else {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.cyan,
                  ),
                );
              } else {
                return const Center(
                  child: Text("Something went wrong, could not load data"),
                );
              }
            }
          },
        ),
      ),
    );
  }
}
