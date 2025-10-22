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

  LibraryFilters({
    this.titleFilter,
    Set<int?>? inGenresFilter,
    Set<int?>? inAuthorsFilter,
    Set<int?>? inPublishersFilter,
    Set<int?>? inLocationsFilter,
    this.startYearFilter,
    this.endYearFilter,
  })  : genresFilter = inGenresFilter ?? {},
        authorsFilter = inAuthorsFilter ?? {},
        publishersFilter = inPublishersFilter ?? {},
        locationsFilter = inLocationsFilter ?? {};

  /// Tells whether any filter is currently active or not.
  bool get isActive =>
      titleFilter != null ||
      genresFilter.isNotEmpty ||
      authorsFilter.isNotEmpty ||
      publishersFilter.isNotEmpty ||
      locationsFilter.isNotEmpty ||
      startYearFilter != null ||
      endYearFilter != null;

  void clear() {
    titleFilter = null;
    genresFilter.clear();
    authorsFilter.clear();
    publishersFilter.clear();
    locationsFilter.clear();
    startYearFilter = null;
    endYearFilter = null;
  }

  /// Creates and returns a copy of [this].
  LibraryFilters copy() {
    return LibraryFilters(
      titleFilter: titleFilter,
      inGenresFilter: {...genresFilter},
      inAuthorsFilter: {...authorsFilter},
      inPublishersFilter: {...publishersFilter},
      inLocationsFilter: {...locationsFilter},
      startYearFilter: startYearFilter,
      endYearFilter: endYearFilter,
    );
  }

  /// Copies all attributes from [other].
  void copyFrom(LibraryFilters other) {
    titleFilter = other.titleFilter;
    genresFilter = {...other.genresFilter};
    authorsFilter = {...other.authorsFilter};
    publishersFilter = {...other.publishersFilter};
    locationsFilter = {...other.locationsFilter};
    startYearFilter = other.startYearFilter;
    endYearFilter = other.endYearFilter;
  }
}
