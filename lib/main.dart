import 'package:flutter/material.dart';
import 'app.dart';

import 'db/database_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseManager.initialize();

  runApp(App(title: "BlackJack"));
  
}