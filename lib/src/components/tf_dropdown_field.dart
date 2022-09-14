part of 'tf_form.dart';

/// [TFDropdownField] widget allows the user to pick a value from a dropdown list
class TFDropdownField extends StatefulWidget {
  final String title;
  final List<TFOptionItem> items;
  final String? initialValue;
  final TextEditingController controller;
  final List<TFValidationType> validationTypes;
  final TextEditingController? relatedController;
  final TFFieldStyle? style;

  TFDropdownField({
    Key? key,
    required this.title,
    required this.items,
    required this.controller,
    this.initialValue,
    this.validationTypes = const <TFValidationType>[],
    this.relatedController, 
    this.style,
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
  final LayerLink __dropdownLink = LayerLink();
  final TextEditingController _displayController = TextEditingController();
  OverlayEntry? _dropdownOverlay;

  void _showDropdown() {
    _dropdownOverlay = _buildDropListOverlay();
    Overlay.of(context)?.insert(_dropdownOverlay!);
  }

  void _hideDropdown() {
    _dropdownOverlay?.remove();
    _dropdownOverlay = null;
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      TFOptionItem selectedItem = widget.items
          .where((element) => element.value == widget.initialValue!)
          .first;
      _displayController.text = selectedItem.title;
      widget.controller.text = widget.initialValue!;
    }
  }

  @override
  void dispose() {
    _dropdownOverlay?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: __dropdownLink,
      child: TFTextField(
        title: widget.title,
        controller: _displayController,
        validationTypes: widget.validationTypes,
        relatedController: widget.relatedController,
        readOnly: true,
        style: widget.style,
        suffix: const Icon(
          Icons.arrow_drop_down,
          color: Colors.grey,
        ),
        onTap: () {
          if (_dropdownOverlay == null) {
            _showDropdown();
          } else {
            _hideDropdown();
          }
        },
        onFocusChanged: (hasFocus) {
          if (!hasFocus) _hideDropdown();
        },
      ),
    );
  }

  OverlayEntry _buildDropListOverlay() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final activeColor = _tffStyle.activeColor;
    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: __dropdownLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height + 5.0),
          child: Material(
            elevation: 2,
            color: _tffStyle.backgroundColor,
            child: Column(
              children: List.generate(widget.items.length, (index) {
                final item = widget.items[index];
                final isSelected = widget.controller.text == item.value;
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
                    widget.controller.text = item.value;
                    _displayController.text = item.title;
                    _hideDropdown();
                  },
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
