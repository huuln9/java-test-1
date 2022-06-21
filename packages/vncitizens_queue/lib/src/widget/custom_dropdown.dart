import 'package:flutter/material.dart';

import '../model/agency_model.dart';

class CustomDropdown<T> extends StatefulWidget {
  final String title;

  final void Function(AgencyModel, int)? onChange;

  final List<DropdownItem<AgencyModel>> items;
  final DropdownStyle? dropdownStyle;
  final ScrollController? scrollController;

  final DropdownButtonStyle? dropdownButtonStyle;

  final Icon? icon;
  final bool hideIcon;

  final bool leadingIcon;

  const CustomDropdown({
    Key? key,
    this.hideIcon = false,
    required this.title,
    required this.items,
    this.dropdownStyle,
    this.dropdownButtonStyle,
    this.icon,
    this.leadingIcon = false,
    this.scrollController,
    this.onChange,
  }) : super(key: key);

  @override
  _CustomDropdownState<T> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>>
    with TickerProviderStateMixin {
  final LayerLink _layerLink = LayerLink();
  late OverlayEntry _overlayEntry;
  bool _isOpen = false;
  int _currentIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _rotateAnimation = Tween(begin: 0.0, end: 0.5).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  Widget build(BuildContext context) {
    var style = widget.dropdownButtonStyle;
    return CompositedTransformTarget(
      link: _layerLink,
      child: SizedBox(
        width: style?.width,
        height: style?.height,
        child: InputDecorator(
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 5, vertical: 5),
            labelText: widget.title,
            border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          ),
          child: MaterialButton(
            onPressed: _toggleDropdown,
            child: Row(
              mainAxisAlignment:
              style?.mainAxisAlignment ?? MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              textDirection:
              widget.leadingIcon ? TextDirection.rtl : TextDirection.ltr,
              children: [
                if (_currentIndex == -1) ...[
                  Text(widget.title),
                ] else
                  ...[
                    widget.items[_currentIndex],
                  ],
                if (!widget.hideIcon)
                  RotationTransition(
                    turns: _rotateAnimation,
                    child: widget.icon ?? const Icon(Icons.arrow_drop_down),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;

    var offset = renderBox.localToGlobal(Offset.zero);
    var topOffset = offset.dy + size.height + 5;
    return OverlayEntry(
      builder: (context) =>
          GestureDetector(
            onTap: () => _toggleDropdown(close: true),
            behavior: HitTestBehavior.translucent,
            child: SizedBox(
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: Stack(
                children: [
                  Positioned(
                    left: offset.dx,
                    top: topOffset,
                    width: widget.dropdownStyle?.width ?? size.width,
                    child: CompositedTransformFollower(
                      offset: widget.dropdownStyle?.offset ??
                          Offset(0, size.height + 5),
                      link: _layerLink,
                      showWhenUnlinked: false,
                      child: Material(
                        elevation: widget.dropdownStyle?.elevation ?? 0,
                        borderRadius:
                        widget.dropdownStyle?.borderRadius ?? BorderRadius.zero,
                        color: widget.dropdownStyle?.color,
                        child: SizeTransition(
                          axisAlignment: 1,
                          sizeFactor: _expandAnimation,
                          child: ConstrainedBox(
                            constraints: widget.dropdownStyle?.constraints ??
                                BoxConstraints(
                                  maxHeight: MediaQuery
                                      .of(context)
                                      .size
                                      .height -
                                      topOffset -
                                      15,
                                ),
                            child: ListView.builder(
                              padding:
                              widget.dropdownStyle?.padding ?? EdgeInsets.zero,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                var item = widget.items.elementAt(index);
                                return InkWell(
                                  onTap: () {
                                     setState(() => _currentIndex = item.key as int);
                                    widget.onChange!(item.value, item.key as int);
                                    _toggleDropdown();
                                  },
                                  child: Text(
                                      item.value.name!
                                  ),
                                );
                              },
                              controller: widget.scrollController,
                              itemCount: widget.items.length,
                            ),
                          ),
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

  Widget _buildItemList(item) {
    return InkWell(
      onTap: () {
        setState(() {
          _currentIndex = item.key;
          widget.onChange!(item.value.value, item.key);
        });
        _toggleDropdown();
      },
      child: item.value as Widget,
    );
  }

  void _toggleDropdown({bool close = false}) async {
    if (_isOpen || close) {
      await _animationController.reverse();
      _overlayEntry.remove();
      setState(() {
        _isOpen = false;
      });
    } else {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context)?.insert(_overlayEntry);
      setState(() => _isOpen = true);
      _animationController.forward();
    }
  }
}

class DropdownItem<T> extends StatelessWidget {
  final T value;
  final Widget child;

  const DropdownItem({Key? key, required this.value, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

class DropdownButtonStyle {
  final MainAxisAlignment? mainAxisAlignment;
  final OutlinedBorder? shape;
  final double? elevation;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final BoxConstraints? constraints;
  final double? width;
  final double? height;
  final Color? primaryColor;

  const DropdownButtonStyle({
    this.mainAxisAlignment,
    this.backgroundColor,
    this.primaryColor,
    this.constraints,
    this.height,
    this.width,
    this.elevation,
    this.padding,
    this.shape,
  });
}

class DropdownStyle {
  final BorderRadius? borderRadius;
  final double? elevation;
  final Color? color;
  final EdgeInsets? padding;
  final BoxConstraints? constraints;

  final Offset? offset;

  final double? width;

  const DropdownStyle({
    this.constraints,
    this.offset,
    this.width,
    this.elevation,
    this.color,
    this.padding,
    this.borderRadius,
  });
}
