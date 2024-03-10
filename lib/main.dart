import 'package:flutter/material.dart';
import 'package:partyplanner_app/providers/parties_provider.dart';
import 'package:partyplanner_app/views/party_overview.dart';
import 'package:partyplanner_app/views/create_edit_party_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => PartyList(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Reads parties from localstorage using parties_provider.dart as soon as the app starts.
    Provider.of<PartyList>(context, listen: false).loadFromStorage();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Party Planner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PartyOverview(title: 'Party Planner'),
      onGenerateRoute: (settings) {
        if (settings.name == '/create') {
          return MaterialPageRoute(
            builder: (context) => const CreateEditPartyPage(),
          );
        }
        return null;
      },
    );
  }
}
