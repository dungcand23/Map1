import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'state/app_notifier.dart';
import 'ui/screens/mobile_home.dart';
import 'ui/screens/web_home.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppNotifier(),
      child: MaterialApp(
        title: "Routing App",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        ),
        home: kIsWeb ? const WebHome() : const MobileHome(),
      ),
    );
  }
}
