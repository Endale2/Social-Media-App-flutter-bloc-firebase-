import 'package:flutter/material.dart';

class ProfileStats extends StatelessWidget {
  final int postCount;
  final int followerCount;
  final int followingCount;
  final void Function()? onTap;

  const ProfileStats({
    super.key,
    required this.followerCount,
    required this.followingCount,
    required this.postCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textStyleForCount = TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.inversePrimary,
    );

    final textStyleForLabel = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Colors.grey.shade600,
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatItem(
                "Posts", postCount, textStyleForCount, textStyleForLabel),
            _buildStatItem("Following", followingCount, textStyleForCount,
                textStyleForLabel),
            _buildStatItem("Followers", followerCount, textStyleForCount,
                textStyleForLabel),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
      String label, int count, TextStyle countStyle, TextStyle labelStyle) {
    return Column(
      children: [
        AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          child: Text(
            count.toString(),
            key: ValueKey<int>(count),
            style: countStyle,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: labelStyle),
      ],
    );
  }
}
