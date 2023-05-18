import 'package:web3dart/credentials.dart';

enum VotingStatus {
  notStarted,
  inProgress,
  finished,
}

class VotingCampaignStatus {
  final EthereumAddress candidateAddress;
  final BigInt voteCount;
  final BigInt totalVoters;
  late final VotingStatus votingStatus;

  VotingCampaignStatus(
    this.candidateAddress,
    this.voteCount,
    this.totalVoters,
    bool isCandidateIssuer,
  ) {
    votingStatus = isCandidateIssuer
        ? VotingStatus.finished
        : voteCount == BigInt.zero
            ? VotingStatus.notStarted
            : VotingStatus.inProgress;
  }
}
