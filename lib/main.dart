import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'Shared_Preferance_Manager/Shared_preferance.dart';
import 'my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Load persisted login state into the in-memory cache
  await SharedPreserance.init();

  runApp(const MyApp());
}
