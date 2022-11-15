part of 'tf_form.dart';

/// [TFDropdownField] widget allows the user to pick a value from a dropdown list
class TFDropdownField extends StatefulWidget {
  final String title;
  final List<TFOptionItem> items;
  final List<TFValidationType> validationTypes;
  final TextEditingController valueController;
  final TextEditingController? relatedController;
  final TFFieldStyle? style;
  final bool enabled;

  TFDropdownField({
    Key? key,
    required this.title,
    required this.items,
    required this.valueController,
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
  State<TFDropdownField> createState() => _TFDropdownFieldState();
}

class _TFDropdownFieldState extends State<TFDropdownField> {
  final LayerLink _dropdownLink = LayerLink();
  final TextEditingController _titleController = TextEditingController();
  OverlayEntry? _dropdownOverlay;

  TextEditingController get _valueController => widget.valueController;

  void _showDropdown() {
    _dropdownOverlay = _buildDropListOverlay();
    Overlay.of(context)?.insert(_dropdownOverlay!);
  }

  void _hideDropdown() {
    _dropdownOverlay?.remove();
    _dropdownOverlay = null;
  }

  void _toggleDropdown() {
    if (_dropdownOverlay == null) {
      _showDropdown();
    } else {
      _hideDropdown();
    }
  }

  void _valueControllerListener() {
    if (_valueController.text.isNotEmpty) {
      final initialValue = _valueController.text;
      TFOptionItem selectedItem = widget.items.where((element) => element.value == initialValue).first;
      _titleController.text = selectedItem.title;
    }
  }

  @override
  void initState() {
    super.initState();
    _valueControllerListener();
    _valueController.addListener(_valueControllerListener);
  }

  @override
  void dispose() {
    _valueController.removeListener(_valueControllerListener);
    _titleController.dispose();
    _dropdownOverlay?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _dropdownLink,
      child: TFTextField(
        title: widget.title,
        controller: _titleController,
        validationTypes: widget.validationTypes,
        relatedController: widget.relatedController,
        readOnly: true,
        style: widget.style,
        enabled: widget.enabled,
        suffix: GestureDetector(
          onTap: _toggleDropdown,
          child: const Icon(
            Icons.arrow_drop_down,
            color: Colors.grey,
          ),
        ),
        onTap: _toggleDropdown,
        onFocusChanged: (hasFocus) {
          if (!hasFocus) _hideDropdown();
        },
      ),
    );
  }

  OverlayEntry _buildDropListOverlay() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    final topOffset = offset.dy + size.height + 5;

    final activeColor = _tffStyle.activeColor;
    return OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: () => _hideDropdown(),
        behavior: HitTestBehavior.translucent,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Positioned(
                left: offset.dx,
                top: topOffset,
                width: size.width,
                child: CompositedTransformFollower(
                  link: _dropdownLink,
                  showWhenUnlinked: false,
                  offset: Offset(0.0, size.height + 5.0),
                  child: Material(
                    elevation: 2,
                    color: _tffStyle.backgroundColor,
                    child: Column(
                      children: List.generate(widget.items.length, (index) {
                        final item = widget.items[index];
                        final isSelected = _valueController.text == item.value;
                        return ListTile(
                          title: Text(item.title),
                          selected: isSelected,
                          selectedColor: Colors.white,
                          selectedTileColor: activeColor,
                          trailing: isSelected
                              ? const Icon(
                                  Icons.check,
                                  size: 18,
                                )
                              : null,
                          onTap: () {
                            _valueController.text = item.value;
                            _hideDropdown();
                          },
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
