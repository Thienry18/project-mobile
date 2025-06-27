import 'package:flutter/material.dart';
import 'package:projek_mobile/constants/app_text_style.dart';

class FilterMenuButton extends StatefulWidget {
  const FilterMenuButton({super.key});

  @override
  State<FilterMenuButton> createState() => _FilterMenuButtonState();
}

class _FilterMenuButtonState extends State<FilterMenuButton> {
  final GlobalKey _buttonKey = GlobalKey();
  OverlayEntry? _overlayEntry;

  Map<String, bool> priceFilters = {
    'Free': false,
    'Paid': false,
    'Discounted': false,
  };

  Map<String, bool> updateStatus = {
    'Newest': false,
    'Most Popular': false,
    'Bestseller': false,
  };

  void _toggleMenu() {
    if (_overlayEntry != null) {
      _closeMenu();
    } else {
      _showMenu();
    }
  }

  void _showMenu() {
    final RenderBox buttonRenderBox =
        _buttonKey.currentContext!.findRenderObject() as RenderBox;
    final Offset buttonPosition = buttonRenderBox.localToGlobal(Offset.zero);

    const double popupWidth = 200;
    final double leftPosition = buttonPosition.dx - popupWidth - 10;
    final double topPosition = buttonPosition.dy;

    _overlayEntry = OverlayEntry(
      builder:
          (context) => Stack(
            children: [
              // Area luar menu, klik untuk menutup
              Positioned.fill(
                child: GestureDetector(
                  onTap: _closeMenu,
                  behavior: HitTestBehavior.translucent,
                  child: const SizedBox.expand(),
                ),
              ),
              Positioned(
                left: leftPosition,
                top: topPosition,
                width: popupWidth,
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Price', style: AppTextStyles.heading),
                        ...priceFilters.entries.map(
                          (entry) => CheckboxListTile(
                            dense: true,
                            visualDensity: VisualDensity.compact,
                            contentPadding: EdgeInsets.zero,
                            title: Text(entry.key),
                            value: entry.value,
                            onChanged: (val) {
                              setState(() {
                                priceFilters[entry.key] = val ?? false;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('Update Status', style: AppTextStyles.heading),
                        ...updateStatus.entries.map(
                          (entry) => CheckboxListTile(
                            dense: true,
                            visualDensity: VisualDensity.compact,
                            contentPadding: EdgeInsets.zero,
                            title: Text(entry.key),
                            value: entry.value,
                            onChanged: (val) {
                              setState(() {
                                updateStatus[entry.key] = val ?? false;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _closeMenu() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _buttonKey,
      decoration: BoxDecoration(
        color: const Color(0xFF324EAF),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: GestureDetector(
        onTap: _toggleMenu,
        child: const Icon(Icons.tune, color: Colors.white, size: 28),
      ),
    );
  }
}
