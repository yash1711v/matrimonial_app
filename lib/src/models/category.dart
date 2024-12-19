
import 'package:get/get.dart';

class Category {
  final String name;
  final List<String> interests;
  final RxBool isExpanded;

  Category({required this.name, required this.interests})
      : isExpanded = false.obs;
}
