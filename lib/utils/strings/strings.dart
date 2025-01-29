import 'dart:io';

import 'package:shelfless/utils/strings/en_strings.dart';
import 'package:shelfless/utils/strings/it_strings.dart';

class Strings {
  String get librariesTitle => "";
  String get all => "";
  String get book => "";
  String get books => "";
  String get importLib => "";
  String get newLib => "";
  String get deleteLibraryTitle => "";
  String get deleteLibraryContent => "";
  String get yes => "";
  String get no => "";
  String get ok => "";
  String get confirm => "";
  String get cancel => "";
  String get authorInfo => "";
  String get genreInfo => "";
  String get publisherInfo => "";
  String get locationInfo => "";
  String get bookInfo => "";
  String get firstName => "";
  String get lastName => "";
  String get borrowedLabel => "";
  String get bookEdit => "";
  String get bookMoveTo => "";
  String get bookDeleteAction => "";
  String get bookDeleted => "";
  String get deleteBookTitle => "";
  String get deleteBookContent => "";
  String get bookInfoTitle => "";
  String get bookInfoThumbnail => "";
  String get bookInfoNoImageSelected => "";
  String get bookInfoLibrary => "";
  String get bookInfoAuthors => "";
  String get bookInfoPublishDate => "";
  String get bookInfoGenres => "";
  String get bookInfoPublisher => "";
  String get bookInfoPublishers => "";
  String get bookInfoLocation => "";
  String get insertTitle => "";
  String get editTitle => "";
  String get authorTitle => "";
  String get authorInfoFirstName => "";
  String get authorInfoLastName => "";
  String get editDone => "";
  String get bookTitle => "";
  String get addOne => "";
  String get add => "";
  String get authorAlreadyAdded => "";
  String get genreAlreadyAdded => "";
  String get selectPublishYear => "";
  String get select => "";
  String get publishers => "";
  String get locations => "";
  String get bookErrorNoTitleProvided => "";
  String get bookErrorNoAuthorProvided => "";
  String get bookErrorNoGenreProvided => "";
  String get genreTitle => "";
  String get genreInfoName => "";
  String get genreInfoColor => "";
  String get genrePickColor => "";
  String get libraryTitle => "";
  String get libraryInfoName => "";
  String get locationTitle => "";
  String get locationInfoName => "";
  String get publisherTitle => "";
  String get publisherInfoName => "";
  String get booksSectionTitle => "";
  String get genresSectionTitle => "";
  String get authorsSectionTitle => "";
  String get publishersSectionTitle => "";
  String get locationsSectionTitle => "";
  String get shareLibrary => "";
  String get exportLibrary => "";
  String get updateLibrary => "";
  String get filtersTitle => "";
  String get filtersApply => "";
  String get filtersCancel => "";
  String get filtersClear => "";
  String get filteredBooksTitle => "";
  String get noLibrariesFound => "";
  String get noAuthorsFound => "";
  String get noGenresFound => "";
  String get noLocationsFound => "";
  String get noPublishersFound => "";
  String get noBooksFound => "";
  String get search => "";
  String get warning => "";
  String get genericError => "";
  String get unreleasedFeatureAlert => "";
}

Strings get strings {
  final String locale = Platform.localeName;

  if (locale.contains("en")) {
    return EnStrings();
  } else if (locale.contains("it")) {
    return ItStrings();
  } else {
    return EnStrings();
  }
}