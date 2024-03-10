// ignore_for_file: avoid_print, use_build_context_synchronously
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:partyplanner_app/models/guest.dart';
import 'package:partyplanner_app/models/party.dart';
import 'package:partyplanner_app/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:add_2_calendar/add_2_calendar.dart' as add_2_calendar;

import '../providers/parties_provider.dart';

class CreateEditPartyPage extends StatefulWidget {
  final Party? party;
  final int? partyIndex;

  const CreateEditPartyPage({super.key, this.party, this.partyIndex});

  @override
  CreateEditPartyPageState createState() => CreateEditPartyPageState();
}

class CreateEditPartyPageState extends State<CreateEditPartyPage> {
  // Set controllers and values here to prevent them from being reset when the widget is rebuilt
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController dateController;

  bool isEdit = false;
  List<Guest>? guests = [];

  late String title;
  late String description;
  late String date;

  @override
  void initState() {
    super.initState();

    // Checking if party is set, if so set the values of the party to the textfields
    if (widget.party != null) {
      title = widget.party!.title;
      description = widget.party!.description;
      date = widget.party!.date.toString();
      guests = List<Guest>.from(widget.party?.guests as Iterable);
    } else {
      title = '';
      description = '';
      date = '';
    }

    // Initialize the controllers with the values of the party
    titleController = TextEditingController(text: title);
    descriptionController = TextEditingController(text: description);
    dateController = TextEditingController(text: date);

    // Add listeners to the controllers to update the values of the party
    titleController.addListener(() {
      title = titleController.text;
    });

    descriptionController.addListener(() {
      description = descriptionController.text;
    });

    dateController.addListener(() {
      date = dateController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Check if we're editing an existing party
    isEdit = widget.party == null ? false : true;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(isEdit ? 'Edit Party' : 'Create Party'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // The form to create or edit a party
          children: <Widget>[
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                prefixIcon: Icon(Icons.title),
              ),
            ),
            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(
                  labelText: 'Description',
                  prefixIcon: Icon(Icons.description)),
            ),
            TextFormField(
              controller: dateController,
              decoration: const InputDecoration(
                labelText: 'Date',
                prefixIcon: Icon(Icons.calendar_today),
              ),
              onTap: () {
                _selectDate();
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: Colors.blue,
              ),
              // Open contact select page for this party. Checks for permissions first
              onPressed: () async {
                bool permissionGranted =
                    await FlutterContacts.requestPermission();

                if (permissionGranted) {
                  Contact? contact = await FlutterContacts.openExternalPick();
                  if (contact != null) {
                    setState(() {
                      guests?.add(Guest(
                        name: contact.displayName.isNotEmpty
                            ? contact.displayName
                            : '',
                        email: contact.emails.isNotEmpty
                            ? contact.emails.first.address
                            : '',
                      ));
                    });
                    print(guests?.length);
                  }
                } else {
                  showSnackbar(context,
                      'Er zijn geen rechten gegeven om contacten te lezen. Ga naar instellingen om dit aan te passen.');
                }
              },
              child: const Text('Select Contacts'),
            ),
            // Show the selected guests
            const Text(
              'Selected guests:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 400,
              child: ListView.builder(
                itemCount: guests?.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(guests![index].name),
                    subtitle: Text(guests![index].email),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        // Handle delete functionality here
                        setState(() {
                          guests?.removeAt(index);
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  onPressed: () async {
                    // Save the party
                    if (titleController.text.isEmpty ||
                        descriptionController.text.isEmpty ||
                        dateController.text.isEmpty) {
                      showSnackbar(context, 'Vul alle velden in.');
                    } else {
                      Party newParty = Party(
                        id: Random().nextInt(1000000000),
                        title: titleController.text,
                        description: descriptionController.text,
                        date: DateTime.parse(dateController.text),
                        guests: guests,
                      );

                      isEdit
                          ? Provider.of<PartyList>(context, listen: false)
                              .edit(widget.partyIndex ?? 0, newParty)
                          : Provider.of<PartyList>(context, listen: false)
                              .add(newParty);

                      // device_calendar package is not working, so we use add_2_calendar package instead
                      // device_calendar should allow to add, edit and delete events from the device calendar but is inconsistent
                      // Keeping the code here incase the package is fixed in the future.

                      // await Future.delayed(const Duration(seconds: 2));

                      // // Create event to put into device calendar
                      // var eventToCreate = device_calendar.Event(
                      //   "7",
                      //   eventId: newParty.id.toString(),
                      //   title: titleController.text,
                      //   description: descriptionController.text,
                      //   start: TZDateTime.from(
                      //       DateTime.parse(dateController.text), tz.UTC),
                      //   end: TZDateTime.from(
                      //           DateTime.parse(dateController.text), tz.UTC)
                      //       .add(const Duration(hours: 2)),
                      // );
                      // print(TZDateTime.from(
                      //     DateTime.parse(dateController.text), tz.UTC));

                      // // Add the event to the device calendar
                      // final calendarPlugin = DeviceCalendarPlugin();
                      // calendarPlugin.retrieveCalendars().then((calendars) {
                      //   for (var calendar in calendars.data!) {
                      //     print(calendar.name! + calendar.id!);
                      //   }
                      // });
                      // final createEventResult = await calendarPlugin
                      //     .createOrUpdateEvent(eventToCreate);
                      // if (createEventResult!.isSuccess) {
                      //   print('Event created');
                      //   newParty.id = int.parse(createEventResult.data!);
                      //   print(createEventResult.data!);
                      // } else {
                      //   print('Event not created');
                      // }

                      // Add the event to the device calendar

                      add_2_calendar.Add2Calendar.addEvent2Cal(buildEvent(
                          titleController.text,
                          descriptionController.text,
                          DateTime.parse(dateController.text)));

                      // Return to the previous page
                      Navigator.pop(context);
                    }
                  },
                  child: Text(widget.party == null ? 'Create' : 'Update'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

// Opens date picker and puts the selected date in the date textfield in a human-readable format
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      dateController.text = picked.toString().split(' ')[0];
    }
  }

// Creates the event to put into device calendar. Currently makes an all-day event instead of setting a time.
  add_2_calendar.Event buildEvent(
      String title, String description, DateTime startDate) {
    return add_2_calendar.Event(
      title: title,
      description: description,
      startDate: startDate,
      endDate: startDate.add(const Duration(hours: 24)),
      allDay: true,
    );
  }
}
