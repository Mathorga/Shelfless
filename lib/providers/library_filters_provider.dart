import 'package:flutter/foundation.dart';

class LibraryFilters {
  // ###############################################################################################################################################################################
  // Filters.
  // ###############################################################################################################################################################################

  String? titleFilter;
  Set<int?> genresFilter = {};
  Set<int?> authorsFilter = {};
  Set<int?> publishersFilter = {};
  Set<int?> locationsFilter = {};
  int? startYearFilter;
  int? endYearFilter;

  // ###############################################################################################################################################################################
  // ###############################################################################################################################################################################
}

class LibraryFiltersProvider with ChangeNotifier {
  final LibraryFilters filters;

  LibraryFiltersProvider({
    LibraryFilters? inFilters,
  }) : filters = inFilters ?? LibraryFilters();

  // ###############################################################################################################################################################################
  // Filter methods.
  // ###############################################################################################################################################################################

  void addTitleFilter(String title) {
    filters.titleFilter = title.isEmpty ? null : title;

    notifyListeners();
  }

  void addAuthorsFilter(Set<int?> authorIds) {
    filters.authorsFilter.addAll(authorIds);

    notifyListeners();
  }

  void addGenresFilter(Set<int?> genreIds) {
    filters.genresFilter.addAll(genreIds);

    notifyListeners();
  }

  void addPublishersFilter(Set<int?> publisherIds) {
    filters.publishersFilter.addAll(publisherIds);

    notifyListeners();
  }

  void removeAuthorsFilter(int? authorId) {
    filters.authorsFilter.remove(authorId);

    notifyListeners();
  }

  void removeGenresFilter(int? genreIds) {
    filters.genresFilter.remove(genreIds);

    notifyListeners();
  }

  void removePublishersFilter(int? genreIds) {
    filters.genresFilter.remove(genreIds);

    notifyListeners();
  }

  // ###############################################################################################################################################################################
  // ###############################################################################################################################################################################
}