import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'johndoe',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black87,
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade700),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box_outlined, color: Colors.black87),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Profile Picture
                  Container(
                    width: 86,
                    height: 86,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                      ),
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    padding: const EdgeInsets.all(3),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage: const NetworkImage(
                        'https://i.pravatar.cc/150?img=68',
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  // Stats
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatColumn('Posts', '42'),
                        _buildStatColumn('Followers', '1.2K'),
                        _buildStatColumn('Following', '385'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Bio Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'John Doe',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '📍 San Francisco, CA\n'
                    '✨ Living my best life\n'
                    '🔗 linktr.ee/johndoe',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade800,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildActionButton('Edit Profile', false),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildActionButton('Share Profile', false),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Story Highlights
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return _HighlightItem(
                    label: index == 0 ? 'New' : 'Highlight ${index}',
                    isAdd: index == 0,
                  );
                },
              ),
            ),

            // Tab Bar
            DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  TabBar(
                    indicatorColor: const Color(0xFF667eea),
                    labelColor: Colors.black87,
                    unselectedLabelColor: Colors.grey,
                    tabs: const [
                      Tab(icon: Icon(Icons.grid_on)),
                      Tab(icon: Icon(Icons.video_collection_outlined)),
                      Tab(icon: Icon(Icons.person_pin_outlined)),
                    ],
                  ),
                  SizedBox(
                    height: 400,
                    child: TabBarView(
                      children: [
                        // Posts Grid
                        GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 2,
                            mainAxisSpacing: 2,
                          ),
                          itemCount: 15,
                          itemBuilder: (context, index) {
                            return Container(
                              color: Colors.grey.shade200,
                              child: Image.network(
                                'https://picsum.photos/200/200?random=${index + 100}',
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),
                        // Reels
                        const Center(child: Text('Reels')),
                        // Tagged
                        const Center(child: Text('Tagged Photos')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(String label, bool isPrimary) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: isPrimary ? const Color(0xFF667eea) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: isPrimary ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class _HighlightItem extends StatelessWidget {
  final String label;
  final bool isAdd;

  const _HighlightItem({
    required this.label,
    this.isAdd = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isAdd ? Colors.transparent : Colors.grey.shade200,
              border: Border.all(
                color: Colors.grey.shade300,
                width: 1,
              ),
            ),
            child: isAdd
                ? const Icon(Icons.add, size: 30, color: Colors.black54)
                : ClipOval(
                    child: Image.network(
                      'https://picsum.photos/100/100?random=${label.hashCode}',
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 70,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
