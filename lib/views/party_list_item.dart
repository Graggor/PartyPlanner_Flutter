import 'package:flutter/material.dart';
import 'package:partyplanner_app/models/party.dart';
import 'package:partyplanner_app/utils/utils.dart';
import 'package:partyplanner_app/views/create_edit_party_page.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PartyListItem extends StatefulWidget {
  final Party party;
  final int partyIndex;

  const PartyListItem(
      {super.key, required this.party, required this.partyIndex});

  @override
  State<PartyListItem> createState() => _PartyListItemState();
}

class _PartyListItemState extends State<PartyListItem> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          child: SizedBox(
            height: 80.0,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      widget.party.title,
                      style: const TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: UnconstrainedBox(
                      child: Row(
                        children: [
                          Text(
                            '${widget.party.guests != null ? widget.party.guests?.length : 0}',
                            style: const TextStyle(
                              fontSize: 12.0, // Pas de grootte aan naar wens
                            ),
                          ),
                          const Icon(Icons.people, size: 20.0)
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.party.description,
                      style: const TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      // Zorg ervoor dat de datum in het gewenste formaat wordt weergegeven
                      widget.party.date.toString().split(' ')[0],
                      style: const TextStyle(
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          onTap: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateEditPartyPage(
                  party: widget.party,
                  partyIndex: widget.partyIndex,
                ),
              ),
            );
          },
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.2,
          child: IconButton(
            icon: const Icon(Icons.mail, size: 30.0),
            onPressed: () {
              if (widget.party.guests != null) {
                // Check of de mailadressen van de gasten geldig zijn
                // Als dat zo is, stuur dan een mail naar de gasten
                // Als dat niet zo is, toon dan een snackbar met een foutmelding
                checkMailAddresses(widget.party.guests ?? [])
                    ? openEmail()
                    : showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Let op!'),
                          content: const Text(
                              'Van een of meerdere personen ontbreken mailadressen of deze zijn ongeldig. Naar deze personen wordt geen mail gestuurd.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Annuleren'),
                            ),
                            TextButton(
                              onPressed: () {
                                openEmail();
                                Navigator.pop(context);
                              },
                              child: const Text('Doorgaan'),
                            ),
                          ],
                        ),
                      );
              } else {
                showSnackbar(context, 'Er zijn geen gasten om uit te nodigen.');
              }
            },
          ),
        )
      ],
    );
  }

// Open de mailclient met de uitnodiging voor het feest.
  void openEmail() {
    var addresses = getMailAddresses(widget.party.guests ?? []);
    if (addresses.isNotEmpty) {
      String mailLink = getMailLink(
          addresses,
          "Uitnodiging voor ${widget.party.title}",
          "Hallo!\n\nJe bent uitgenodigd voor het feest ${widget.party.title} op ${widget.party.date.toString().split(' ')[0]}.\n\nDe beschrijving voor het feestje is:\n${widget.party.description}\n\nGroetjes,\n");
      launchUrlString(mailLink);
    } else {
      showSnackbar(context, 'Er zijn geen gasten om uit te nodigen.');
    }
  }
}
