import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';
import 'package:http/http.dart';

class SampleListModel extends ChangeNotifier {
  bool isLoading = true;
  List<Sample> samples = [];
  int sampleCount = 0;
  final String _rpcUrl =
      "https://rinkeby.infura.io/v3/888f6bd30c9e47a7b445bd44148e5e21";
  final String _wsUrl =
      "ws://rinkeby.infura.io/ws/v3/888f6bd30c9e47a7b445bd44148e5e21/";
  final String _privateKey =
      "0xe828afb2052989688a2440d837fa07ea88095f02a723d9a125bf4d2a6ab4ac2c";
  final String mnemonic =
      "frequent saddle bottom cage cousin slogan obvious insane system erode evoke cook";

  // Testing Connection:
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
  late ContractFunction _sampleID;
  late ContractFunction _samples;
  late ContractFunction _createSample;
  //late ContractEvent _sampleCreated;

  SampleListModel() {
    intitiateSetup();
  }

  Future<void> intitiateSetup() async {
    _web3client = Web3Client(_rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(_wsUrl).cast<String>();
    });

    await getAbi();
    await getCredentials();
    await getDeployedContract();
    await getSamples();
  }

  Future<void> getAbi() async {
    String abiStringFile =
        await rootBundle.loadString("build/contracts/SampleList.json");
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
        ContractAbi.fromJson(_abiCode, "SampleList"), _contractAddress);
    _sampleID = _contract.function("_tokenIds");
    _createSample = _contract.function("createSample");
    _samples = _contract.function("samples");
    //_sampleCreated = _contract.event("SampleCreated");
  }

  getSamples() async {
    List totalSamplesList = await _web3client
        .call(contract: _contract, function: _sampleID, params: []);
    BigInt totalSamples = totalSamplesList[0];
    sampleCount = totalSamples.toInt();
    samples.clear();
    for (var i = 0; i < totalSamples.toInt(); i++) {
      var temp = await _web3client.call(
          contract: _contract, function: _samples, params: [BigInt.from(i)]);
      samples.add(Sample(
          uid: temp[0],
          samName: temp[1],
          samDate: temp[2],
          samTime: temp[3],
          samLoc: temp[4],
          samUnits: temp[5]));
    }

    isLoading = false;
    notifyListeners();
  }

  addSample(String uid, String samName, String samDate, String samTime,
      String samLoc, String samUnits) async {
    isLoading = true;
    notifyListeners();
    await _web3client.sendTransaction(
        _credentials,
        Transaction.callContract(
            contract: _contract,
            function: _createSample,
            parameters: [
              uid,
              samName,
              samDate,
              samTime,
              samLoc,
              samUnits,
              uid
            ]),
        chainId: 4);

    getSamples();
  }
}

class Sample {
  String uid;
  String samName;
  String samDate;
  String samTime;
  String samLoc;
  String samUnits;

  Sample(
      {required this.uid,
      required this.samName,
      required this.samDate,
      required this.samTime,
      required this.samLoc,
      required this.samUnits});
}
