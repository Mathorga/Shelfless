import 'dart:io';

import 'package:shelfless/utils/shared_prefs_helper.dart';
import 'package:shelfless/utils/shared_prefs_keys.dart';
import 'package:shelfless/utils/strings/en_strings.dart';
import 'package:shelfless/utils/strings/it_strings.dart';

enum AppLocale {
  en,
  it,
  system;

  String get label => switch (this) {
        AppLocale.en => "English",
        AppLocale.it => "Italiano",
        AppLocale.system => "System default",
      };
}

abstract class Strings {
  String get welcomeHeader;
  String get welcomeSubtitle;
  String get welcomeSuggestion;
  String get welcomeActionCreate;
  String get welcomeActionImport;
  String get settings;
  String get setitngsSectionTitle;
  String get settingDefaultCover;
  String get settingTitlesCapitalization;
  String get settingAppLanguage;
  String get legalsSectionTitle;
  String get privacyPolicyLabel;
  String get licensesLabel;
  String get supportLabel;
  String get librariesTitle;
  String get othersTitle;
  String get all;
  String get book;
  String get books;
  String get importLib;
  String get newLib;
  String get addLibraryTitle;
  String get deleteLibraryTitle;
  String get deleteLibraryContent;
  String get imageSourceTitle;
  String get imageSourceCamera;
  String get imageSourceGallery;
  String get yes;
  String get no;
  String get ok;
  String get confirm;
  String get cancel;
  String get genericCannotDelete;
  String get cannotDeleteAuthorContent;
  String get authorDeleted;
  String get deleteAuthorTitle;
  String get deleteAuthorContent;
  String get cannotDeleteGenreContent;
  String get genreDeleted;
  String get deleteGenreTitle;
  String get deleteGenreContent;
  String get cannotDeletePublisherContent;
  String get publisherDeleted;
  String get deletePublisherTitle;
  String get deletePublisherContent;
  String get cannotDeleteLocationContent;
  String get locationDeleted;
  String get deleteLocationTitle;
  String get deleteLocationContent;
  String get authorInfo;
  String get genreInfo;
  String get publisherInfo;
  String get locationInfo;
  String get bookInfo;
  String get firstName;
  String get lastName;
  String get bookEdit;
  String get bookMoveTo;
  String get bookMoveToNoLibrary;
  String get bookMoveToDescription;
  String get bookMarkOutAction;
  String get bookMarkInAction;
  String get bookDeleteAction;
  String get bookDeleted;
  String get deleteBookTitle;
  String get deleteBookContent;
  String get bookInfoTitle;
  String get bookInfoCover;
  String get bookInfoNotes;
  String get bookInfoNoImageSelected;
  String get bookInfoLibrary;
  String get bookInfoAuthors;
  String get bookInfoPublishYear;
  String get bookInfoGenres;
  String get bookInfoPublisher;
  String get bookInfoPublishers;
  String get bookInfoLocation;
  String get bookInfoLocations;
  String get insertTitle;
  String get editTitle;
  String get deleteTitle;
  String get authorTitle;
  String get authorInfoFirstName;
  String get authorInfoLastName;
  String get authorInfoHomeland;
  String get editDone;
  String get bookTitle;
  String get addOne;
  String get add;
  String get authorAlreadyAdded;
  String get genreAlreadyAdded;
  String get selectPublishYear;
  String get select;
  String get publishers;
  String get locations;
  String get bookErrorNoTitleProvided;
  String get bookErrorNoAuthorProvided;
  String get bookErrorNoGenreProvided;
  String get libraryErrorNoNameProvided;
  String get genreTitle;
  String get genreInfoName;
  String get genreInfoColor;
  String get genrePickColor;
  String get libraryTitle;
  String get libraryInfoName;
  String get locationTitle;
  String get locationInfoName;
  String get publisherTitle;
  String get publisherInfoName;
  String get booksSectionTitle;
  String get genresSectionTitle;
  String get authorsSectionTitle;
  String get publishersSectionTitle;
  String get locationsSectionTitle;
  String get librarySortBy;
  String get libraryShare;
  String get libraryExport;
  String get libraryUpdate;
  String get sortByTitleAsc;
  String get sortByTitleDesc;
  String get sortByPublishYearAsc;
  String get sortByPublishYearDesc;
  String get filtersTitle;
  String get filtersApply;
  String get filtersCancel;
  String get filtersClear;
  String get filteredBooksTitle;
  String get noLibrariesFound;
  String get noAuthorsFound;
  String get noGenresFound;
  String get noLocationsFound;
  String get noPublishersFound;
  String get noBooksFound;
  String get search;
  String get genericConfirmTitle;
  String get genericConfirmContent;
  String get cancelConfirmContent;
  String get genericInfo;
  String get genericWarning;
  String get genericErrorTitle;
  String get genericErrorContent;
  String get unexpectedErrorContent;
  String get imageReadErrorContent;
  String get unreleasedFeatureAlert;
  String get coverDescription;
  String get cropImageTitle;
  String textCapitalizationSentences();
  String textCapitalizationWords();
  String textCapitalizationCharacters();
  String textCapitalizationNone();
}

Strings get strings {
  // Read setting from shared preferences.
  final int localePref = SharedPrefsHelper.instance.data.getInt(SharedPrefsKeys.appLocale) ?? AppLocale.system.index;

  switch (AppLocale.values[localePref]) {
    case AppLocale.it:
      return ItStrings();
    case AppLocale.en:
      return EnStrings();
    case AppLocale.system:
      final String locale = Platform.localeName;

      if (locale.contains("en")) {
        return EnStrings();
      } else if (locale.contains("it")) {
        return ItStrings();
      } else {
        return EnStrings();
      }
  }
  
}
