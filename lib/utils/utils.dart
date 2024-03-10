import 'package:partyplanner_app/models/guest.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

Future<void> sendMail(String email, String subject, String body) async {}

// Checks if email addresses are valid and present.
checkMailAddresses(List<Guest> guests) {
  if (guests.isEmpty) {
    return false;
  }
  for (var guest in guests) {
    if (!EmailValidator.validate(guest.email)) {
      return false;
    }
  }
  return true;
}

// Returns a list of valid email addresses to pass to the email client.
getMailAddresses(List<Guest> guests) {
  List<String> mailAddresses = [];
  for (var guest in guests) {
    if (EmailValidator.validate(guest.email)) {
      mailAddresses.add(guest.email);
    }
  }
  return mailAddresses;
}

// Creates the mailto link to pass to the email client.
getMailLink(List<String> addresses, String subject, String body) {
  var mailtoLink = 'mailto:';
  for (var address in addresses) {
    mailtoLink += '$address,';
  }
  mailtoLink += '?subject=$subject&body=$body';
  return mailtoLink;
}

// Shows a snackbar with a message.
void showSnackbar(BuildContext context, String message) {
  var snackBar = SnackBar(
    content: Text(message),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
