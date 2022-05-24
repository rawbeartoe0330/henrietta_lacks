// import 'package:flutter/material.dart';

// class TypesTable extends StatefulWidget {
//   const TypesTable({Key? key}) : super(key: key);

//   @override
//   _TypesTableState createState() => _TypesTableState();
// }

// class _TypesTableState extends State<TypesTable> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(elevation: 0.0, title: Text("Categories")),
//         body: Container(
//             padding: EdgeInsets.only(left: 10, right: 10, top: 20),
//             child: DataTable(columns: [
//               DataColumn(
//                   label: Text('Type',
//                       style: TextStyle(
//                           fontSize: 18, fontWeight: FontWeight.bold))),
//               DataColumn(
//                   label: Text('Cases',
//                       style: TextStyle(
//                           fontSize: 18, fontWeight: FontWeight.bold))),
//               DataColumn(
//                   label: Text('Samples',
//                       style: TextStyle(
//                           fontSize: 18, fontWeight: FontWeight.bold))),
//             ], rows: [
//               DataRow(cells: [
//                 DataCell(InkWell(
//                   child: Text('Sarcoma'),
//                   onTap: () {
//                     Navigator.of(context).push(
//                         MaterialPageRoute(builder: (context) => PatientList()));
//                   },
//                 )),
//                 DataCell(Text('1048')),
//                 DataCell(Text('1200')),
//               ]),
//               DataRow(cells: [
//                 DataCell(InkWell(
//                   child: Text('Mesothelioma'),
//                   onTap: () {
//                     Navigator.of(context).push(
//                         MaterialPageRoute(builder: (context) => PatientList()));
//                   },
//                 )),
//                 DataCell(Text('276')),
//                 DataCell(Text('400')),
//               ]),
//               DataRow(cells: [
//                 DataCell(InkWell(
//                   child: Text('Melanoma'),
//                   onTap: () {
//                     Navigator.of(context).push(
//                         MaterialPageRoute(builder: (context) => PatientList()));
//                   },
//                 )),
//                 DataCell(Text('421')),
//                 DataCell(Text('700')),
//               ]),
//               DataRow(cells: [
//                 DataCell(InkWell(
//                   child: Text('Blastoma'),
//                   onTap: () {
//                     Navigator.of(context).push(
//                         MaterialPageRoute(builder: (context) => PatientList()));
//                   },
//                 )),
//                 DataCell(Text('49')),
//                 DataCell(Text('90')),
//               ])
//             ])));
//   }
// }
