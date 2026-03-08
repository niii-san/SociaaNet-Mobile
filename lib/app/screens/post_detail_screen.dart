import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sociaanet/core/models/models.dart';
import 'package:sociaanet/core/providers/app_providers.dart';
import 'package:sociaanet/app/widgets/post_card.dart';

class PostDetailScreen extends ConsumerStatefulWidget {
  final String postId;
  const PostDetailScreen({super.key, required this.postId});

  @override
  ConsumerState<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends ConsumerState<PostDetailScreen> {
  FeedPost? _post;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPost();
  }

  Future<void> _loadPost() async {
    setState(() { _isLoading = true; _error = null; });
    try {
      final service = ref.read(postServiceProvider);
      final post = await service.getPostById(widget.postId);
      if (mounted) setState(() { _post = FeedPost.fromPost(post); _isLoading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 48, color: Theme.of(context).colorScheme.error),
                      const SizedBox(height: 12),
                      Text('Failed to load post', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      FilledButton(onPressed: _loadPost, child: const Text('Retry')),
                    ],
                  ),
                )
              : _post != null
                  ? SingleChildScrollView(
                      child: PostCard(
                        post: _post!,
                        onPostUpdated: (updated) => setState(() => _post = updated),
                      ),
                    )
                  : const SizedBox.shrink(),
    );
  }
}
