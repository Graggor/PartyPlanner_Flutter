import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:partyplanner_app/models/party.dart';
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Notifies listeners when the list of parties changes so the UI gets updated.

class PartyList extends ChangeNotifier {
  final List<Party> _parties = [];
  final LocalStorage storage = LocalStorage('parties.json');

  List<Party> get parties => _parties;

  void add(Party party) {
    _parties.add(party);
    _saveToStorage();
    notifyListeners();
  }

  void edit(int index, Party party) {
    _parties[index] = party;
    _saveToStorage();
    notifyListeners();
  }

  void remove(int index) {
    _parties.removeAt(index);
    _saveToStorage();
    notifyListeners();
  }

  encodeToJSON() {
    return jsonEncode(_parties.map((item) {
      return Party.toJson(item);
    }).toList());
  }

  _saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('parties', encodeToJSON());
  }

  loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('parties');

    if (jsonString != null) {
      final List<dynamic> json = jsonDecode(jsonString) as List<dynamic>;
      _parties.clear();
      for (var item in json) {
        _parties.add(Party.fromJson(item));
      }
      notifyListeners();
    }
  }
}
