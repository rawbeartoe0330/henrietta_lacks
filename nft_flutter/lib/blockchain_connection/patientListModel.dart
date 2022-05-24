import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';
import 'package:http/http.dart';

class PatientListModel extends ChangeNotifier {
  bool isLoading = true;
  List<Patient> patients = [];
  int patientCount = 0;
  final String _rpcUrl =
      //"https://ropsten.infura.io/v3/888f6bd30c9e47a7b445bd44148e5e21";
      "https://ropsten.infura.io/v3/505f4c8cb7544499bfa05c80baf87eac";

  final String _wsUrl =
      //"wss://ropsten.infura.io/ws/v3/888f6bd30c9e47a7b445bd44148e5e21/";
      "wss://ropsten.infura.io/ws/v3/505f4c8cb7544499bfa05c80baf87eac";

  final String _privateKey =
      //"e828afb2052989688a2440d837fa07ea88095f02a723d9a125bf4d2a6ab4ac2c";
      "904a4e4db1b8e4dfebd7074a8d8637c7741c31e4a981453e396ef3f185927cfc";

  // final String mnemonic =
  //"yellow advance belt twenty digital spoil athlete home outside lock verb maze";
  // final String _rpcUrl = "http://192.168.0.3:8454";
  // final String _wsUrl = "ws://192.168.0.3:8454/";
  // final String _privateKey =
  //     "ca06a5fe53f2d2941a51c235d2f8ceade64279d53393d9445b395ba06093c936";
  // // final String mnemonic =
  // //     "frequent saddle bottom cage cousin slogan obvious insane system erode evoke cook";

  late Web3Client _web3client;
  late String _abiCode;
  late EthereumAddress _contractAddress;
  EthereumAddress? _ownAddress;
  late DeployedContract _contract;
  EthPrivateKey? _credentials;
  late ContractFunction _patientID;
  late ContractFunction _patients;
  late ContractFunction _createPatient;
  late ContractEvent _patientCreated;

  PatientListModel() {
    intitiateSetup();
  }

  Future<void> intitiateSetup() async {
    _web3client = Web3Client(_rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(_wsUrl).cast<String>();
    });

    await getAbi();
    await getCredentials();
    await getDeployedContract();
    await getPatients();
  }

  Future<void> getAbi() async {
    String abiStringFile =
        await rootBundle.loadString("build/contracts/PatientList.json");
    var jsonAbi = jsonDecode(abiStringFile);
    _abiCode = jsonEncode(jsonAbi["abi"]);
    _contractAddress =
        EthereumAddress.fromHex(jsonAbi["networks"]["5777"]["address"]);
    print(_contractAddress);
  }

  getCredentials() async {
    _credentials = EthPrivateKey.fromHex(_privateKey);
    _ownAddress = await _credentials!.extractAddress();
  }

  Future<void> getDeployedContract() async {
    _contract = DeployedContract(
        ContractAbi.fromJson(_abiCode, "PatientList"), _contractAddress);
    _patientID = _contract.function("_tokenIds");
    _createPatient = _contract.function("createPatient");
    _patients = _contract.function("patients");
    _patientCreated = _contract.event("PatientCreated");
  }

  getPatients() async {
    List totalPatientsList = await _web3client
        .call(contract: _contract, function: _patientID, params: []);
    BigInt totalPatients = totalPatientsList[0];
    patientCount = totalPatients.toInt();
    patients.clear();
    for (var i = 0; i < totalPatients.toInt(); i++) {
      var temp = await _web3client.call(
          contract: _contract, function: _patients, params: [BigInt.from(i)]);
      patients.add(Patient(
          patientUID: temp[0],
          patientName: temp[1],
          patientInfo: temp[2],
          patientHistoy: temp[3]));
    }

    isLoading = false;
    notifyListeners();
  }

  addPatient(String patientUID, String patientName, String patientInfo,
      String patientHistory) async {
    print(_ownAddress);
    isLoading = true;
    notifyListeners(); // notifies that a change is being made to providers

    await _web3client.sendTransaction(
        _credentials!,
        Transaction.callContract(
            contract: _contract,
            function: _createPatient,
            parameters: [
              patientUID,
              patientName,
              patientInfo,
              patientHistory,
              "1"
            ]),
        chainId: 3);
//remember to change chainID when moving to ganache

    getPatients();
  }
}

class Patient {
  String patientUID;
  String patientName;
  String patientInfo;
  String patientHistoy;

  Patient(
      {required this.patientUID,
      required this.patientName,
      required this.patientInfo,
      required this.patientHistoy});
}
