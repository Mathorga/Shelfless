class Author {
  final String _firstName;
  final String _lastName;

  Author(
    this._firstName,
    this._lastName,
  );

  @override
  String toString() {
    return "$_firstName $_lastName";
  }
}
