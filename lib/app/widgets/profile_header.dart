import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String username;
  final String? bio;
  final String? avatarUrl;
  final int postsCount;
  final int followersCount;
  final int followingCount;
  final VoidCallback? onEditProfile;
  const ProfileHeader({super.key, required this.username, this.bio, this.avatarUrl, this.postsCount = 0, this.followersCount = 0, this.followingCount = 0, this.onEditProfile});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 40, backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null, child: avatarUrl == null ? const Icon(Icons.person, size: 40) : null),
              const SizedBox(width: 24),
              Expanded(child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                _buildStat('Posts', postsCount),
                _buildStat('Followers', followersCount),
                _buildStat('Following', followingCount),
              ])),
            ],
          ),
          const SizedBox(height: 12),
          Text(username, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          if (bio != null) Text(bio!, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildStat(String label, int count) {
    return Column(
      children: [
        Text('$count', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}
