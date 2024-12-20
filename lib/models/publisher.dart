class Publisher {
  String name;

  String? website;

  Publisher({
    required this.name,
    this.website,
  });

  Publisher.fromSerializableString(String source) : name = "" {
    final List<String> parts = source.split("/");
    name = parts[0].replaceAll("_", " ");
    website = parts.length > 1 ? parts[1].isNotEmpty ? parts[1] : null : null;
  }

  /// Creates and returns a copy of [this].
  Publisher copy() {
    return Publisher(
      name: name,
      website: website,
    );
  }

  /// Copies all attributes from [other].
  void copyFrom(Publisher other) {
    name = other.name;
    website = other.website;
  }

  @override
  String toString() {
    return name + (website ?? "");
  }

  @override
  bool operator ==(Object other) => other is Publisher && other.runtimeType == runtimeType && other.name == name && other.website == website;

  @override
  int get hashCode => name.hashCode;

  String toSerializableString() {
    return "${name.replaceAll(" ", "_")}/${(website ?? "").replaceAll(" ", "_")}";
  }
}
