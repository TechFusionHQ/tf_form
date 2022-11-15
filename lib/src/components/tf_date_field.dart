part of 'tf_form.dart';

/// [TFDateField] widget allows the user to pick a DateTime from an input field
class TFDateField extends StatefulWidget {
  final String title;
  final TextEditingController controller;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final List<TFValidationType> validationTypes;
  final TextEditingController? relatedController;
  final TFFieldStyle? style;
  final bool enabled;

  TFDateField({
    Key? key,
    required this.title,
    required this.controller,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.validationTypes = const <TFValidationType>[],
    this.relatedController, 
    this.style,
    this.enabled = true,
  }) : super(key: key) {
    if (validationTypes.contains(TFValidationType.requiredIfHas) &&
        relatedController == null) {
      throw ArgumentError(
          "requiredIfHas type and relatedController should both be set.");
    }
  }

  @override
  State<TFDateField> createState() => _TFDateFieldState();
}

class _TFDateFieldState extends State<TFDateField> {
  void _showDatePicker() async {
    final now = DateTime.now();
    const range = Duration(days: 365 * 40);
    final result = await showDatePicker(
      context: context,
      initialDate: widget.initialDate ?? now,
      firstDate: widget.firstDate ?? now.subtract(range),
      lastDate: widget.lastDate ?? now.add(range),
    );
    if (result != null) {
      widget.controller.text = TFFormValidator.getDateFormat().format(result);
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialDate != null) {
      widget.controller.text = TFFormValidator.getDateFormat().format(
        widget.initialDate!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return TFTextField(
      title: widget.title,
      hintText: TFFormValidator.getDateFormat().pattern,
      controller: widget.controller,
      validationTypes: widget.validationTypes,
      relatedController: widget.relatedController,
      readOnly: true,
      style: widget.style,
      enabled: widget.enabled,
      suffix: GestureDetector(
        onTap: _showDatePicker,
        child: const Icon(
          Icons.calendar_month_outlined,
          color: Colors.grey,
        ),
      ),
      onTap: _showDatePicker,
    );
  }
}
