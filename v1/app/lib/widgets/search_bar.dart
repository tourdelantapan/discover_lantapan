import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  Function onChanged;
  String searchKey;
  String? label;
  SearchBar({
    Key? key,
    this.label,
    required this.searchKey,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        initialValue: searchKey,
        onChanged: (e) => onChanged(e),
        decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(7)),
            hintText: label ?? "Search",
            prefixIcon: const Icon(Icons.search_rounded)));
  }
}
