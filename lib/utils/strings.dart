import 'dart:io';

class Strings {
  String get librariesTitle => "";
  String get noLibrariesFound => "";
  String get all => "";
  String get books => "";
  String get importLib => "";
  String get newLib => "";
  String get deleteLibraryTitle => "";
  String get deleteLibraryContent => "";
  String get yes => "";
  String get no => "";
}

/// English strings.
class EngStrings implements Strings {
  @override
  String get librariesTitle => "Libraries";

  @override
  String get noLibrariesFound => "No libraries found";

  @override
  String get all => "All";

  @override
  String get books => "books";

  @override
  String get importLib => "Import";

  @override
  String get newLib => "New";

  @override
  String get deleteLibraryTitle => "Delete Library";

  @override
  String get deleteLibraryContent => "Are you sure you want to delete";

  @override
  String get yes => "Yes";

  @override
  String get no => "No";
}

/// Italian strings.
class ItStrings implements Strings {
  @override
  String get librariesTitle => "Biblioteche";

  @override
  String get noLibrariesFound => "Nessuna biblioteca";

  @override
  String get all => "Tutti";

  @override
  String get books => "libri";

  @override
  String get importLib => "Importa";

  @override
  String get newLib => "Nuova";

  @override
  String get deleteLibraryTitle => "Elimina Biblioteca";

  @override
  String get deleteLibraryContent => "Vuoi davvero eliminare";

  @override
  String get yes => "Sì";

  @override
  String get no => "No";
}


Strings get strings {
  final String locale = Platform.localeName;

  if (locale.contains("en")) {
    return EngStrings();
  } else if (locale.contains("it")) {
    return ItStrings();
  } else {
    return EngStrings();
  }
}