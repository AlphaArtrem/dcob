import 'dart:convert';
import 'dart:io';
import 'package:dcob/bussiness/helper/api_helper.dart';
import 'package:dcob/bussiness/helper/contract_helper.dart';
import 'package:dcob/data/api_constants.dart';
import 'package:dcob/presentation/common/buttons.dart';
import 'package:dcob/bussiness/bloc/wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

class CreateCertificateScreen extends StatefulWidget {
  const CreateCertificateScreen({super.key});

  @override
  _CreateCertificateScreenState createState() =>
      _CreateCertificateScreenState();
}

class _CreateCertificateScreenState extends State<CreateCertificateScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _image, _receiverAddress;
  static final Logger _logger = Logger();
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
        actions: [
          IconButton(
            onPressed: () {
              // Navigate to WalletSuccessScreen
              Navigator.of(context).pushNamed('/wallet_success');
            },
            icon: const Icon(Icons.wallet),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
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
                onChanged: (value) {
                  setState(() {
                    _receiverAddress = value;
                  });
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
    if (_receiverAddress == null || _image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Both image and receiver address is required."),
        ),
      );
      return;
    }

    String ipfsImageUrl = await _uploadImageToIpfs();
    _mintCertificate(ipfsImageUrl);
  }

  Future<String> _uploadImageToIpfs() async {
    Map<String, dynamic> env =
        jsonDecode(await rootBundle.loadString("assets/env.json"));
    List<int> utfAuth = utf8
        .encode("${env["ipfsInfuraApiKey"]}:${env["ipfsInfuraApiSecretKey"]}");
    String base64Auth = base64.encode(utfAuth);
    Map<String, dynamic> response = await ApiHelper.uploadFile(
      ApiConstants.ipfsUploadFile,
      filePath: _image!,
      fileField: "file",
      bearerToken: base64Auth,
    );
    String hash = response["Hash"];
    String imageUrl = "https://ipfs.io/ipfs/$hash";
    return imageUrl;
  }

  void _mintCertificate(String ipfsImageUrl) async {
    await ContractHelper.query(
      contract: (context.read<WalletBloc>().state as WalletDetailsState)
          .certificateContract,
      functionName: "createCertificate",
      args: [
        _receiverAddress,
        ipfsImageUrl,
      ],
      web3client: walletDetailsState.web3client,
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('The certificate NFT was minted successfully.'),
          actions: [
            primaryButton(
              text: 'OK',
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
          content: Text('An error occurred: $error'),
          actions: [
            primaryButton(
              text: 'OK',
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
