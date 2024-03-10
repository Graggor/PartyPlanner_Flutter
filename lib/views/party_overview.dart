import 'package:flutter/material.dart';
import 'package:partyplanner_app/models/party.dart';
import 'package:partyplanner_app/providers/parties_provider.dart';
import 'package:partyplanner_app/views/create_edit_party_page.dart';
import 'package:partyplanner_app/views/party_list_item.dart';
import 'package:provider/provider.dart';

class PartyOverview extends StatefulWidget {
  const PartyOverview({super.key, required this.title});
  final String title;

  @override
  PartyOverviewState createState() => PartyOverviewState();
}

class PartyOverviewState extends State<PartyOverview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: Provider.of<PartyList>(context).parties.length,
        itemBuilder: (context, index) {
          return PartyListItem(
              party: Provider.of<PartyList>(context).parties[index],
              partyIndex: index);
        },
      ),
      // Adds new party.
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Party? newParty = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const CreateEditPartyPage()),
          );
          if (newParty != null) {
            setState(() {
              Provider.of<PartyList>(context, listen: false).add(newParty);
            });
          }
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
