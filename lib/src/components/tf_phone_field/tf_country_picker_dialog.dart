import 'package:flutter/material.dart';
import 'package:tf_form/src/components/tf_phone_field/helper.dart';
import 'package:tf_form/src/models/models.dart';

class TFCountryPickerDialogStyle {
  TFCountryPickerDialogStyle({
    this.backgroundColor,
    this.countryCodeStyle,
    this.countryNameStyle,
    this.listTileDivider,
    this.padding,
    this.searchFieldInputDecoration,
    this.searchFieldPadding,
  });

  final Color? backgroundColor;
  final TextStyle? countryCodeStyle;
  final TextStyle? countryNameStyle;
  final Widget? listTileDivider;
  final EdgeInsets? padding;
  final InputDecoration? searchFieldInputDecoration;
  final EdgeInsets? searchFieldPadding;
}

class TFCountryPickerDialog extends StatefulWidget {
  const TFCountryPickerDialog({
    Key? key,
    required this.searchHint,
    required this.languageCode,
    required this.countries,
    required this.selectedCountry,
    required this.style,
  }) : super(key: key);

  final List<TFCountry> countries;
  final TFCountry selectedCountry;
  final String searchHint;
  final String languageCode;
  final TFCountryPickerDialogStyle? style;

  @override
  State<TFCountryPickerDialog> createState() => _TFCountryPickerDialogState();
}

class _TFCountryPickerDialogState extends State<TFCountryPickerDialog> {
  late List<TFCountry> _filteredCountries;
  late TFCountry _selectedCountry;

  @override
  void initState() {
    _selectedCountry = widget.selectedCountry;
    _filteredCountries = List.of(widget.countries);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(vertical: 60.0, horizontal: 24.0),
      backgroundColor: widget.style?.backgroundColor,
      child: Padding(
        padding: widget.style?.padding ?? const EdgeInsets.all(10),
        child: Column(
          children: [
            Padding(
              padding: widget.style?.searchFieldPadding ?? EdgeInsets.zero,
              child: TextField(
                style: const TextStyle(fontWeight: FontWeight.w500),
                decoration: widget.style?.searchFieldInputDecoration ??
                    InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                      labelText: widget.searchHint,
                      suffix: const Icon(Icons.search),
                    ),
                onChanged: (value) {
                  _filteredCountries = widget.countries.filter(value)
                    ..sort(
                      (a, b) => a.localizedName(widget.languageCode).compareTo(b.localizedName(widget.languageCode)),
                    );
                  if (mounted) setState(() {});
                },
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _filteredCountries.length,
                itemBuilder: (ctx, index) => Column(
                  children: [
                    ListTile(
                      leading: Text(
                        _filteredCountries[index].flag,
                        style: const TextStyle(fontSize: 18),
                      ),
                      dense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                      title: Text(
                        _filteredCountries[index].localizedName(widget.languageCode),
                        style: widget.style?.countryNameStyle ?? const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      trailing: Text(
                        '+${_filteredCountries[index].dialCode}',
                        style: widget.style?.countryCodeStyle ?? const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      onTap: () {
                        _selectedCountry = _filteredCountries[index];
                        Navigator.of(context).pop<TFCountry>(_selectedCountry);
                      },
                    ),
                    widget.style?.listTileDivider ?? const Divider(thickness: 1),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
