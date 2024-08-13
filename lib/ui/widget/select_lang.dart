import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:icoc_admin_pannel/constants.dart';

class SelectLanguageWidget extends StatefulWidget {
  final TextEditingController langController;
  const SelectLanguageWidget({super.key, required this.langController});

  @override
  State<SelectLanguageWidget> createState() => _SelectLanguageWidgetState();
}

class _SelectLanguageWidgetState extends State<SelectLanguageWidget> {
  @override
  void initState() {
    if (widget.langController.text.isEmpty) {
      Future.delayed(Duration.zero).then((_) {
        setState(() {
          widget.langController.text =
              View.of(context).platformDispatcher.locale.languageCode;
        });
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> languages = languagesCodes.keys.toList();

    return Row(
      children: [
        const Text('Language: '),
        DropdownButton<String>(
          elevation: 0,
          underline: const SizedBox.shrink(),
          value: widget.langController.text.isNotEmpty
              ? widget.langController.text
              : 'ru',
          onChanged: (String? newValue) {
            setState(() {
              widget.langController.text = newValue ?? '';
            });
          },
          items: languages.map<DropdownMenuItem<String>>((String language) {
            return DropdownMenuItem<String>(
              value: language,
              child: Row(
                children: [
                  CountryFlag.fromCountryCode(
                    handleLanguage(language),
                    width: 20,
                    height: 15,
                  ),
                  const SizedBox(width: 8),
                  Text(language),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  String handleLanguage(String language) {
    if (language == 'uk') return 'ua';
    if (language == 'en') {
      return 'us';
    } else {
      return language;
    }
  }
}
