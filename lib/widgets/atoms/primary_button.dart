import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool loading;
  final IconData? icon;

  const PrimaryButton(
      {super.key,
      required this.label,
      required this.onPressed,
      this.loading = false,
      this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedScale(
      scale: loading ? 0.98 : 1,
      duration: const Duration(milliseconds: 120),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          elevation: 0,
        ),
        onPressed: loading ? null : onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) Icon(icon, size: 18),
            if (icon != null) const SizedBox(width: 8),
            Text(label),
            if (loading) ...[
              const SizedBox(width: 12),
              SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: theme.colorScheme.onPrimary)),
            ]
          ],
        ),
      ),
    );
  }
}
