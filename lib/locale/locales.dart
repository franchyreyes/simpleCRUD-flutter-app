import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter_app/l10n/messages_all.dart';



class AppLocalizations {
  static Future<AppLocalizations> load(Locale locale) async {
    final String name =
    locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
   // print("dd" + name);
    final String localeName = Intl.canonicalizedLocale(name);

    return await initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      //print(Intl.defaultLocale);
      return AppLocalizations();
    });
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  String title() {
    return Intl.message(
      'Movies',
      name: 'title',
      desc: 'Title for the Demo application',
    );
  }

  String titleLabel() {
    return Intl.message(
      'title',
      name: 'titleLabel',
      desc: 'titleLabel for the Demo application',
    );
  }

  String descriptionLabel() {
    return Intl.message(
      'description',
      name: 'descriptionLabel',
      desc: 'descriptionLabel for the Demo application',
    );
  }
  String add() {
    return Intl.message(
      'Add new Movies',
      name: 'add',
      desc: 'add for the Demo application',
    );
  }

}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    //print(locale.languageCode);
    return ['es', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}