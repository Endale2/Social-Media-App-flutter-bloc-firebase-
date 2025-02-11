import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final void Function()? onPressed;
  final bool isFollowing;
  const FollowButton({
    super.key,
    required this.isFollowing,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          // When following, use a white background with a primary border; otherwise, fill with primary.
          backgroundColor:
              isFollowing ? Colors.white : theme.colorScheme.primary,
          // Set the text (foreground) color accordingly.
          foregroundColor:
              isFollowing ? theme.colorScheme.primary : Colors.white,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(10),
        ),
        child: Text(
          isFollowing ? "Unfollow" : "Follow",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
