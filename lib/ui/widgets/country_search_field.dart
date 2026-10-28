import 'package:flutter/material.dart';

class CountrySearchField extends StatelessWidget {
  const CountrySearchField({
    required this.controller,
    required this.onChanged,
    required this.onClear,
    super.key,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Cari negara, ibu kota, bahasa...',
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: Color(0xFF78A6FF),
        ),
        suffixIcon: controller.text.isEmpty
            ? null
            : IconButton(
                tooltip: 'Hapus pencarian',
                onPressed: onClear,
                icon: const Icon(Icons.close_rounded),
              ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }
}
