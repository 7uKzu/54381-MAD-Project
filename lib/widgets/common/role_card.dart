import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RoleCard extends StatefulWidget {
  final String label;
  final IconData icon;
  final String route;
  const RoleCard(
      {super.key,
      required this.label,
      required this.icon,
      required this.route});

  @override
  State<RoleCard> createState() => _RoleCardState();
}

class _RoleCardState extends State<RoleCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = _hover
        ? theme.colorScheme.primary.withValues(alpha: 0.08)
        : theme.colorScheme.surface;
    return Semantics(
      label: '${widget.label} dashboard',
      button: true,
      child: InkWell(
        onTap: () => context.go(widget.route),
        onHover: (v) => setState(() => _hover = v),
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: bg,
            border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.2)),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(widget.icon, color: theme.colorScheme.primary),
            const SizedBox(height: 8),
            Text(widget.label, style: theme.textTheme.labelLarge),
          ]),
        ),
      ),
    );
  }
}
