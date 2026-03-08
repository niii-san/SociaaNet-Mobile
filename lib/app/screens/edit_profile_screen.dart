import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sociaanet/core/providers/app_providers.dart';
import 'package:go_router/go_router.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _bioController = TextEditingController();
  File? _selectedImage;
  bool _isSaving = false;
  bool _initialized = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _initFromUser() {
    if (_initialized) return;
    final user = ref.read(currentUserProvider);
    if (user != null) {
      _fullNameController.text = user.fullName;
      _usernameController.text = user.username ?? '';
      // Bio is not on User model, but on UserProfile. We'll load it.
      _initialized = true;
      _loadProfile(user.username ?? user.fullName);
    }
  }

  Future<void> _loadProfile(String username) async {
    try {
      final service = ref.read(userServiceProvider);
      final profile = await service.getUserProfile(username);
      if (mounted) {
        _bioController.text = profile['bio'] ?? '';
      }
    } catch (_) {}
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) {
      setState(() => _selectedImage = File(picked.path));
    }
  }

  Future<void> _saveProfile() async {
    setState(() => _isSaving = true);
    try {
      final userService = ref.read(userServiceProvider);
      final user = ref.read(currentUserProvider);
      if (user == null) return;

      // Update fields that changed
      if (_fullNameController.text != user.fullName) {
        await userService.updateFullName(_fullNameController.text);
      }

      if (_usernameController.text != user.username) {
        await userService.updateUsername(_usernameController.text);
      }

      if (_bioController.text.isNotEmpty) {
        await userService.updateBio(_bioController.text);
      }

      // Upload avatar if selected
      if (_selectedImage != null) {
        try {
          final userRepo = ref.read(userRepositoryProvider);
          await userRepo.uploadAvatarByPath(_selectedImage!.path);
        } catch (_) {}
      }

      // Refresh user data
      // Refresh user data
      final updatedUser = await ref.read(userServiceProvider).getCurrentUser();
      ref.read(currentUserProvider.notifier).setUser(updatedUser);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated!'), backgroundColor: Colors.green));
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: $e'), backgroundColor: Colors.red));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    _initFromUser();
    final theme = Theme.of(context);
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilledButton(
              onPressed: _isSaving ? null : _saveProfile,
              child: _isSaving
                  ? const SizedBox(width: 20, height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Save'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Avatar
            GestureDetector(
              onTap: _pickImage,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _selectedImage != null
                        ? FileImage(_selectedImage!)
                        : (user?.fullAvatarUrl != null
                            ? NetworkImage(user!.fullAvatarUrl!) as ImageProvider
                            : null),
                    child: _selectedImage == null && user?.fullAvatarUrl == null
                        ? Text(
                            user?.fullName.isNotEmpty == true ? user!.fullName[0].toUpperCase() : '?',
                            style: const TextStyle(fontSize: 32),
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text('Tap to change photo', style: theme.textTheme.bodySmall),
            const SizedBox(height: 32),

            // Full Name
            TextFormField(
              controller: _fullNameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
                prefixIcon: const Icon(Icons.person_outline),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),

            // Username
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                prefixIcon: const Icon(Icons.alternate_email),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),

            // Bio
            TextFormField(
              controller: _bioController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Bio',
                prefixIcon: const Icon(Icons.info_outline),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
