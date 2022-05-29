import 'package:hive/hive.dart';

part 'store_location.g.dart';

@HiveType(typeId: 3)
class StoreLocation extends HiveObject {
  @HiveField(0)
  String name;

  StoreLocation({
    required this.name,
  });

  @override
  String toString() {
    return name;
  }
}
