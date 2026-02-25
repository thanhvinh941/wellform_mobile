import 'package:flutter/material.dart';

class AvatarPopoverButton extends StatefulWidget {
  const AvatarPopoverButton({
    super.key,
    required this.avatarImageProvider,
    required this.fullName,
    required this.email,
    this.onProfile,
    this.onSettings,
    this.onLogout,
    this.popoverWidth = 260,
    this.verticalOffset = 12, // khoảng cách từ avatar tới popover
    this.borderRadius = 16,
  });

  final ImageProvider avatarImageProvider;
  final String fullName;
  final String email;
  final VoidCallback? onProfile;
  final VoidCallback? onSettings;
  final VoidCallback? onLogout;

  final double popoverWidth;
  final double verticalOffset;
  final double borderRadius;

  @override
  State<AvatarPopoverButton> createState() => _AvatarPopoverButtonState();
}

class _AvatarPopoverButtonState extends State<AvatarPopoverButton> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _entry;

  void _toggle() {
    if (_entry != null) {
      _hide();
    } else {
      _show();
    }
  }

  void _show() {
    final overlay = Overlay.of(context);

    final scheme = Theme.of(context).colorScheme;

    _entry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            // Tap bên ngoài để đóng
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _hide,
              ),
            ),
            // Popover bám theo avatar
            CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(
                // canh phải avatar → popover lệch phải (âm để nút/avatar nằm sát góc trên phải popover)
                - (widget.popoverWidth - 40), // 40 ~ kích thước avatar
                widget.verticalOffset,
              ),
              child: Material(
                elevation: 8,
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(widget.borderRadius),
                child: Container(
                  width: widget.popoverWidth,
                  decoration: BoxDecoration(
                    color: scheme.surface,
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                    border: Border.all(
                      color: scheme.outlineVariant.withOpacity(0.5),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header: avatar + name + email (không có icon menu trong popover)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 22,
                              backgroundImage: widget.avatarImageProvider,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.fullName,
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    widget.email,
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.8),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1),

                      // Menu items
                      _MenuItem(
                        icon: Icons.person_outline,
                        label: 'Profile',
                        onTap: () {
                          _hide();
                          widget.onProfile?.call();
                        },
                      ),
                      _MenuItem(
                        icon: Icons.settings_outlined,
                        label: 'Settings',
                        onTap: () {
                          _hide();
                          widget.onSettings?.call();
                        },
                      ),
                      _MenuItem(
                        icon: Icons.logout,
                        label: 'Logout',
                        onTap: () {
                          _hide();
                          widget.onLogout?.call();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    overlay.insert(_entry!);
  }

  void _hide() {
    _entry?.remove();
    _entry = null;
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _hide();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Nút avatar trên AppBar
    return CompositedTransformTarget(
      link: _layerLink,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: _toggle,
        child: CircleAvatar(
          radius: 20,
          backgroundImage: widget.avatarImageProvider,
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: scheme.secondaryContainer.withOpacity(0.35),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Icon(icon, color: scheme.onSecondaryContainer),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}