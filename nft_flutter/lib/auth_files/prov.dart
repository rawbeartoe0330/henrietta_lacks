import 'package:flutter/material.dart';
import 'package:nft_flutter/auth_files/auth.dart';

class Prov extends InheritedWidget {
  final AuthService auth;
  Prov({Key? key, Widget? child, required this.auth})
      : super(key: key, child: child!);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static Prov? of(BuildContext context) =>
      (context.dependOnInheritedWidgetOfExactType<Prov>());
}
