import 'package:dcob/business/bloc/wallet_bloc.dart';
import 'package:dcob/business/helper/contract_helper.dart';
import 'package:dcob/data/models/voting_campaign_status.dart';
import 'package:dcob/presentation/common/buttons.dart';
import 'package:dcob/presentation/common/dialogue.dart';
import 'package:dcob/presentation/common/web_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:web3dart/credentials.dart';

class VotingScreen extends StatefulWidget {
  static const String route = '/voting_screen';
  const VotingScreen({super.key});

  @override
  State<VotingScreen> createState() => _VotingScreenState();
}

class _VotingScreenState extends State<VotingScreen> {
  final TextEditingController _candidateAddress = TextEditingController();
  VotingCampaignStatus? status;
  late final WalletDetailsState walletDetailsState;

  @override
  void initState() {
    super.initState();
    // Get the mnemonic from the global bloc
    walletDetailsState =
        context.read<WalletBloc>().state as WalletDetailsState;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voting Campaigns'),
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
                      controller: _candidateAddress,
                      decoration: InputDecoration(
                        labelText: 'Candidate Address',
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
                      await ContractHelper.votingCampaignStatus(
                              walletDetailsState: walletDetailsState,
                              candidateAddress: EthereumAddress.fromHex(
                                  _candidateAddress.text))
                          .then((value) => setState(() {
                                status = value;
                              }))
                          .onError((error, stackTrace) => setState(() {
                                status = null;
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
            if (status != null && status!.votingStatus == VotingStatus.finished)
              Expanded(
                child: Center(
                  child: Card(
                    color: Colors.white,
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child:  Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 30,
                      ),
                      child: Text(
                        "Candidate is already an issuer."
                        "\n\nNew votes can't be casted for existing issuers.",
                        style: TextStyle(
                          color: Colors.red.shade900,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            if (status != null && status!.votingStatus != VotingStatus.finished)
              _votingStatus(),
          ],
        ),
      ),
    );
  }

  Widget _votingStatus(){
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 10.0,
                        trackShape:
                        const RoundedRectSliderTrackShape(),
                        activeTrackColor: Colors.cyan,
                        inactiveTrackColor:
                        Colors.black.withOpacity(0.25),
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 14.0,
                          pressedElevation: 8.0,
                        ),
                        thumbColor: Colors.cyan,
                        overlayColor: Colors.cyan.withOpacity(0.2),
                        overlayShape: const RoundSliderOverlayShape(
                            overlayRadius: 22.0),
                        tickMarkShape:
                        const RoundSliderTickMarkShape(),
                        activeTickMarkColor: Colors.pinkAccent,
                        inactiveTickMarkColor: Colors.white,
                        valueIndicatorShape:
                        const PaddleSliderValueIndicatorShape(),
                        valueIndicatorColor: Colors.black,
                        valueIndicatorTextStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                      child: Slider(
                        min: 0.0,
                        max: 100.0,
                        value:
                        status!.voteCount / status!.totalVoters,
                        divisions: 10,
                        label:
                        '${(status!.voteCount / status!.totalVoters).round()}',
                        onChanged: (value) {},
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Divider(thickness: 2),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        const Text(
                          "Votes Received",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          "${status!.voteCount}",
                          style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text(
                          "Votes Required",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          "${(status!.totalVoters ~/ BigInt.from(2)) + BigInt.from(1)}",
                          style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        const Text(
                          "Total Voters",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          "${status!.totalVoters}",
                          style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text(
                          "Vote Share",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          "${status!.voteCount / status!.totalVoters}%",
                          style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Divider(thickness: 2),
                ),
                primaryButton(
                  onTap: () {
                    if (!walletDetailsState.isIssuer) {
                      showDialogue(
                          title: "Access Denied!",
                          text: "You are not an issuer.");
                    } else {
                      _castVote();
                    }
                  },
                  text: status!.totalVoters < BigInt.from(5)
                      ? 'Add Issuer'
                      : status!.votingStatus ==
                      VotingStatus.notStarted
                      ? "Start Campaign"
                      : "Cast Vote",
                ),
                const SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _castVote() async {
    if (_candidateAddress.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Candidate address is required."),
        ),
      );
      return;
    }

    try {
      String transactionHash = await ContractHelper.addIssuer(
        walletDetailsState: walletDetailsState,
        candidateAddress: EthereumAddress.fromHex(_candidateAddress.text),
      );
      _candidateAddress.clear();
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
            'Your vote will be successfully casted once the transaction containing it is mined. The transaction hash is $transactionHash',
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
