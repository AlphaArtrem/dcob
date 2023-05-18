import 'dart:convert';
import 'dart:io';
import 'package:dcob/business/helper/api_helper.dart';
import 'package:dcob/business/helper/contract_helper.dart';
import 'package:dcob/data/static/api_constants.dart';
import 'package:dcob/presentation/common/buttons.dart';
import 'package:dcob/business/bloc/wallet_bloc.dart';
import 'package:dcob/presentation/common/web_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:web3dart/credentials.dart';

class CreateCertificateScreen extends StatefulWidget {
  static const String route = '/create_certificate';
  const CreateCertificateScreen({super.key});

  @override
  _CreateCertificateScreenState createState() =>
      _CreateCertificateScreenState();
}

class _CreateCertificateScreenState extends State<CreateCertificateScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _image;
  final TextEditingController _receiverAddress = TextEditingController();
  late final WalletDetailsState walletDetailsState;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    walletDetailsState = context.read<WalletBloc>().state as WalletDetailsState;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Certificate'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _receiverAddress,
                decoration: InputDecoration(
                    labelText: 'Receiver Address',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    )),
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return 'Please enter a receiver address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                    image: _image != null
                        ? DecorationImage(
                            image: FileImage(File(_image!)),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _image == null
                      ? const Center(
                          child: Text(
                            'Pick an Image',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : const SizedBox.shrink()),
              const SizedBox(height: 40.0),
              primaryButton(
                text: 'Pick Image',
                onTap: _pickImage,
                isFilled: false,
                fontSize: 14.0,
              ),
              const SizedBox(height: 16.0),
              primaryButton(
                text: 'Create Certificate',
                onTap: _createCertificate,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _pickImage() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = image.path;
      });
    }
  }

  void _createCertificate() async {
    if (_image == null || _receiverAddress.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Both image and receiver address is required."),
        ),
      );
      return;
    }

    try {
      String ipfsImageUrl = await ContractHelper.uploadFileToIpfs(_image!);

      String transactionHash = await ContractHelper.mintCertificate(
        ipfsImageUrl: ipfsImageUrl,
        walletDetailsState: walletDetailsState,
        receiverAddress: EthereumAddress.fromHex(_receiverAddress.text),
      );
      _receiverAddress.clear();
      setState(() {
        _image = null;
      });
      _showSuccessDialog(transactionHash);
    } catch (e) {
      Logger().d(e);
      _showErrorDialog(e);
    }
  }

  void _showSuccessDialog(String transactionHash) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Success'),
          content: Text(
            'The certificate NFT will be minted successfully once the transaction containing it is mined. The transaction hash is $transactionHash',
            textAlign: TextAlign.justify,
          ),
          actions: [
            primaryButton(
              text: 'View On Explorer',
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => WebViewScreen(
                      initialUrl:
                          "https://mumbai.polygonscan.com/tx/$transactionHash",
                    ),
                  ),
                );
              },
            ),
            primaryButton(
              text: 'Close',
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(Object error) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(
            'An error occurred: $error',
          ),
          actions: [
            primaryButton(
              text: 'Close',
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
