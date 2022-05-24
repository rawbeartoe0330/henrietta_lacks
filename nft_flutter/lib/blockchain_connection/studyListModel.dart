import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';
import 'package:http/http.dart';

class StudyListModel extends ChangeNotifier {
  bool isLoading = true;
  List<Study> studies = [];
  int studyCount = 0;
  final String _rpcUrl =
      "https://rinkeby.infura.io/v3/888f6bd30c9e47a7b445bd44148e5e21";
  final String _wsUrl =
      "ws://rinkeby.infura.io/ws/v3/888f6bd30c9e47a7b445bd44148e5e21/";
  final String _privateKey =
      "0xe828afb2052989688a2440d837fa07ea88095f02a723d9a125bf4d2a6ab4ac2c";
  final String mnemonic =
      "frequent saddle bottom cage cousin slogan obvious insane system erode evoke cook";
  // final String _rpcUrl = "http://192.168.0.3:8454";
  // final String _wsUrl = "ws://192.168.0.3:8454/";
  // final String _privateKey =
  //     "ca06a5fe53f2d2941a51c235d2f8ceade64279d53393d9445b395ba06093c936";
  // // final String mnemonic =
  // //     "frequent saddle bottom cage cousin slogan obvious insane system erode evoke cook";
  late Web3Client _web3client;
  late String _abiCode;
  late EthereumAddress _contractAddress;
  late EthereumAddress _ownAddress;
  late DeployedContract _contract;
  late EthPrivateKey _credentials;
  late ContractFunction _studyID;
  late ContractFunction _studies;
  late ContractFunction _createStudy;
  late ContractEvent _studyCreated;

  StudyListModel() {
    intitiateSetup();
  }

  Future<void> intitiateSetup() async {
    _web3client = Web3Client(_rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(_wsUrl).cast<String>();
    });

    await getAbi();
    await getCredentials();
    await getDeployedContract();
    await getStudies();
  }

  Future<void> getAbi() async {
    String abiStringFile =
        await rootBundle.loadString("build/contracts/StudyList.json");
    var jsonAbi = jsonDecode(abiStringFile);
    _abiCode = jsonEncode(jsonAbi["abi"]);
    _contractAddress =
        EthereumAddress.fromHex(jsonAbi["networks"]["4"]["address"]);
    print(_contractAddress);
  }

  getCredentials() async {
    _credentials = EthPrivateKey.fromHex(_privateKey);
    _ownAddress = await _credentials.extractAddress();
  }

  Future<void> getDeployedContract() async {
    _contract = DeployedContract(
        ContractAbi.fromJson(_abiCode, "StudyList"), _contractAddress);
    _studyID = _contract.function("_tokenIds");
    _createStudy = _contract.function("createStudy");
    _studies = _contract.function("studies");
    _studyCreated = _contract.event("StudyCreated");
  }

  getStudies() async {
    List totalStudiesList = await _web3client
        .call(contract: _contract, function: _studyID, params: []);
    BigInt totalStudies = totalStudiesList[0];
    studyCount = totalStudies.toInt();
    studies.clear();
    for (var i = 0; i < totalStudies.toInt(); i++) {
      var temp = await _web3client.call(
          contract: _contract, function: _studies, params: [BigInt.from(i)]);
      studies.add(Study(
          resUID: temp[0],
          studyTitle: temp[1],
          patientUID1: temp[2],
          patientUID2: temp[3],
          patientUID3: temp[4],
          patientUID4: temp[5],
          patientUID5: temp[6]));
    }

    isLoading = false;
    notifyListeners();
  }

  addStudy(
      String resUID,
      String studyTitle,
      String patientUID1,
      String patientUID2,
      String patientUID3,
      String patientUID4,
      String patientUID5) async {
    isLoading = true;
    notifyListeners();
    await _web3client.sendTransaction(
        _credentials,
        Transaction.callContract(
            contract: _contract,
            function: _createStudy,
            parameters: [
              resUID,
              studyTitle,
              patientUID1,
              patientUID2,
              patientUID3,
              patientUID4,
              patientUID5,
              resUID
            ]),
        chainId: 4);

    getStudies();
  }
}

class Study {
  String resUID;
  String studyTitle;
  String patientUID1;
  String patientUID2;
  String patientUID3;
  String patientUID4;
  String patientUID5;

  Study(
      {required this.resUID,
      required this.studyTitle,
      required this.patientUID1,
      required this.patientUID2,
      required this.patientUID3,
      required this.patientUID4,
      required this.patientUID5});
}
