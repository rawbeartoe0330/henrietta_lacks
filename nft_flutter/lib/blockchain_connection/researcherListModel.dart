import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';
import 'package:http/http.dart';

class ResearcherListModel extends ChangeNotifier {
  bool isLoading = true;
  List<Researcher> researchers = [];
  int researcherCount = 0;
  final String _rpcUrl =
      //"https://ropsten.infura.io/v3/888f6bd30c9e47a7b445bd44148e5e21";
      "https://ropsten.infura.io/v3/505f4c8cb7544499bfa05c80baf87eac";

  final String _wsUrl =
      //"wss://ropsten.infura.io/ws/v3/888f6bd30c9e47a7b445bd44148e5e21/";
      "wss://ropsten.infura.io/ws/v3/505f4c8cb7544499bfa05c80baf87eac";

  final String _privateKey =
      //"e828afb2052989688a2440d837fa07ea88095f02a723d9a125bf4d2a6ab4ac2c";
      '904a4e4db1b8e4dfebd7074a8d8637c7741c31e4a981453e396ef3f185927cfc';

  /*final String _rpcUrl =
      "https://ropsten.infura.io/v3/888f6bd30c9e47a7b445bd44148e5e21";
  final String _wsUrl =
      "wss://ropsten.infura.io/ws/v3/888f6bd30c9e47a7b445bd44148e5e21/";
  final String _privateKey =
      "e828afb2052989688a2440d837fa07ea88095f02a723d9a125bf4d2a6ab4ac2c";
      */
  // final String mnemonic =
  //     "frequent saddle bottom cage cousin slogan obvious insane system erode evoke cook";
  // final String _rpcUrl = "http://192.168.0.3:8454";
  // final String _wsUrl = "ws://192.168.0.3:8454/";
  // final String _privateKey =
  //     "ca06a5fe53f2d2941a51c235d2f8ceade64279d53393d9445b395ba06093c936";
  // // final String mnemonic =
  // //     "frequent saddle bottom cage cousin slogan obvious insane system erode evoke cook";

  late Web3Client _web3client;
  late EthereumAddress _contractAddress;
  late EthereumAddress _ownAddress;
  DeployedContract? _contract;
  late ContractFunction _researcherID;
  late ContractFunction _researchers;
  late ContractFunction _createResearcher;
  late ContractEvent _researcherCreated;

  ResearcherListModel() {
    intitiateSetup();
  }

  Future<void> intitiateSetup() async {
    _web3client = Web3Client(_rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(_wsUrl).cast<String>();
    });

    await getAbi();
    print("Got Abi");
    await getCredentials();
    print("got credentials");
    await getDeployedContract();
    print("got contract");
    await getResearchers();
  }

  Future<void> getAbi() async {
    String abiStringFile =
        await rootBundle.loadString("build/contracts/ResearcherList.json");
    var jsonAbi = jsonDecode(abiStringFile);
    // _abiCode = jsonEncode(jsonAbi["abi"]);
    _contractAddress =
        EthereumAddress.fromHex(jsonAbi["networks"]["3"]["address"]);
    print(_contractAddress);
  }

  getCredentials() async {
    final _credentials = EthPrivateKey.fromHex(_privateKey);
    print("WAMA WAMIN GAMAMA UGA UGA YAYA");
    _ownAddress = await _credentials.extractAddress();
  }

  Future<void> getDeployedContract() async {
    // _contract = DeployedContract(
    //     ContractAbi.fromJson(_abiCode, "ResearcherList"), _contractAddress);
    _researcherID = _contract!.function("_tokenIds");
    _createResearcher = _contract!.function("createResearcher");
    _researchers = _contract!.function("researchers");
    _researcherCreated = _contract!.event("ResearcherCreated");
  }

  getResearchers() async {
    List totalResearchersList = await _web3client
        .call(contract: _contract!, function: _researcherID, params: []);
    BigInt totalResearchers = totalResearchersList[0];
    researcherCount = totalResearchers.toInt();
    researchers.clear();
    for (var i = 0; i < totalResearchers.toInt(); i++) {
      var temp = await _web3client.call(
          contract: _contract!,
          function: _researchers,
          params: [BigInt.from(i)]);
      researchers.add(Researcher(resName: temp[0], uid: temp[1]));
    }

    isLoading = false;
    notifyListeners();
  }

  //Add Researcher Works

  addResearcher(String resName, String uid) async {
    String abiStringFile =
        await rootBundle.loadString("build/contracts/ResearcherList.json");
    var jsonAbi = jsonDecode(abiStringFile);
    final abiCode = jsonEncode(jsonAbi["abi"]);
    final contract = DeployedContract(
        ContractAbi.fromJson(abiCode, "ResearcherList"), _contractAddress);
    final credentials = EthPrivateKey.fromHex(_privateKey);
    final createResearcher = contract.function("createResearcher");
    isLoading = true;
    notifyListeners();
    await _web3client.sendTransaction(
        credentials,
        Transaction.callContract(
            contract: contract,
            function: createResearcher,
            parameters: [resName, uid, "1"]),
        chainId: 3);
    // getResearchers();
  }
}

class Researcher {
  String resName;
  String uid;

  Researcher({required this.resName, required this.uid});
}
