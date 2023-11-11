part of '../tf_form.dart';

class TFPhoneField extends StatefulWidget {
  final bool autofocus;
  final bool enabled;
  final bool readOnly;
  final bool showCountryFlag;
  final Function()? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final List<TFCountry> countries;
  final String languageCode;
  final String searchHint;
  final String? hintText;
  final String? initialCountryCode;
  final String? invalidNumberMessage;
  final TextEditingController controller;
  final TextInputAction? textInputAction;
  final TextStyle? style;
  final TFCountryPickerDialogStyle? pickerDialogStyle;
  final ValueChanged<TFCountry>? onCountryChanged;
  final ValueChanged<TFPhoneNumber>? onChanged;
  final List<TFValidationType> validationTypes;

  const TFPhoneField({
    Key? key,
    required this.controller,
    this.autofocus = false,
    this.countries = defaultCountries,
    this.enabled = true,
    this.hintText,
    this.initialCountryCode,
    this.inputFormatters,
    this.invalidNumberMessage = 'Invalid Mobile Number',
    this.languageCode = 'en',
    this.onChanged,
    this.onCountryChanged,
    this.onTap,
    this.pickerDialogStyle,
    this.readOnly = false,
    this.searchHint = 'Search country',
    this.showCountryFlag = true,
    this.style,
    this.textInputAction,
    this.validationTypes = const [],
  }) : super(key: key);

  @override
  State<TFPhoneField> createState() => _TFPhoneFieldState();
}

class _TFPhoneFieldState extends State<TFPhoneField> {
  late List<TFCountry> _allCountries;
  late TFCountry _selectedCountry;
  late String _phoneNumber;

  String? validatorMessage;

  @override
  void initState() {
    super.initState();
    _allCountries = widget.countries;
    _phoneNumber = widget.controller.text;

    _cleanPhoneNumber();
  }

  void _cleanPhoneNumber() {
    if (_phoneNumber.startsWith('+')) {
      _phoneNumber = _phoneNumber.substring(1);
    }
    if (widget.initialCountryCode == null) {
      _selectedCountry = _allCountries.firstWhere(
        (country) => _phoneNumber.startsWith(country.dialCode),
        orElse: () => _allCountries.first,
      );
    } else {
      _selectedCountry = _allCountries.firstWhere(
        (item) => item.code == widget.initialCountryCode,
        orElse: () => _allCountries.first,
      );
    }
    _phoneNumber = _phoneNumber.replaceFirst(RegExp("^${_selectedCountry.dialCode}"), "");
    widget.controller.text = _phoneNumber;
    widget.onCountryChanged?.call(_selectedCountry);
  }

  Future<void> _pickCountry() async {
    final selectedCountry = await showDialog<TFCountry>(
      context: context,
      useRootNavigator: false,
      builder: (context) => TFCountryPickerDialog(
        languageCode: widget.languageCode.toLowerCase(),
        style: widget.pickerDialogStyle,
        searchHint: widget.searchHint,
        countries: _allCountries,
        selectedCountry: _selectedCountry,
      ),
    );
    if (selectedCountry != null && mounted) {
      setState(() => _selectedCountry = selectedCountry);
      widget.onCountryChanged?.call(_selectedCountry);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TFTextField(
      validationTypes: widget.validationTypes,
      hintText: widget.hintText,
      autofillHints: const [AutofillHints.telephoneNumberNational],
      readOnly: widget.readOnly,
      onTap: widget.onTap,
      controller: widget.controller,
      prefix: _buildCountryFlagButton(),
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.number,
      enabled: widget.enabled,
      autoFocus: widget.autofocus,
      textInputAction: widget.textInputAction ?? TextInputAction.next,
      showDoneButton: false,
      onChanged: (value) async {
        _phoneNumber = value;
        widget.onChanged?.call(TFPhoneNumber(
          country: _selectedCountry,
          number: _phoneNumber,
        ));
      },
    );
  }

  Widget _buildCountryFlagButton() {
    return InkWell(
      onTap: widget.enabled ? _pickCountry : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.showCountryFlag)
            Text(
              _selectedCountry.flag,
              style: _tffStyle.fieldStyle.contentStyle?.copyWith(fontSize: 18),
            ),
          const Icon(
            Icons.arrow_drop_down,
            color: Colors.grey,
          )
          // Text(
          //   "+${_selectedCountry.dialCode}",
          //   style: _tffStyle.fieldStyle.contentStyle,
          // ),
        ],
      ),
    );
  }
}
