import 'package:cached_network_image/cached_network_image.dart';
import 'package:dcob/business/bloc/wallet_bloc.dart';
import 'package:dcob/business/helper/contract_helper.dart';
import 'package:dcob/data/models/certificate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreatedCertificatesScreen extends StatefulWidget {
  static const String route = '/created_certificate';
  const CreatedCertificatesScreen({super.key});

  @override
  State<CreatedCertificatesScreen> createState() =>
      _CreatedCertificatesScreenState();
}

class _CreatedCertificatesScreenState extends State<CreatedCertificatesScreen> {
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
                              imageUrl: certificate.imageUrl,
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
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
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
                            "#${certificate.id}",
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
                            '${certificate.issuer.hex.substring(0, 8)}....${certificate.issuer.hex.substring(certificate.issuer.hex.length - 8)}',
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
                            '${certificate.receiver.hex.substring(0, 8)}....${certificate.receiver.hex.substring(certificate.receiver.hex.length - 8)}',
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
