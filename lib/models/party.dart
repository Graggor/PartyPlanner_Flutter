import 'package:partyplanner_app/models/guest.dart';
import 'dart:convert';

// Party has an ID to allow the calendar to edit it. Since the calender plugin is not working it is not used right now.
class Party {
  int id;
  final String title;
  final String description;
  final DateTime date;
  List<Guest>? guests = [];

  Party({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    this.guests,
  });

  static Map<String, dynamic> toJson(Party party) {
    return {
      'id': party.id,
      'title': party.title,
      'description': party.description,
      'date': party.date.toIso8601String(),
      'guests': jsonEncode(party.guests),
    };
  }

  factory Party.fromJson(Map<String, dynamic> json) {
    return Party(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      guests: (jsonDecode(json['guests']) as List<dynamic>)
          .map((item) => Guest.fromJson(item))
          .toList(),
    );
  }
}
