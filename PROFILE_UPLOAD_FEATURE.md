# Profile Picture Upload Feature

## Overview
This feature allows users to upload and update their profile picture in the SociaaNet mobile application. The implementation includes real-time user data fetching from the API, image selection from gallery, upload functionality, and comprehensive error handling.

## Features Implemented

### 1. API Integration
- **Upload Endpoint**: `POST /api/v1/users/me/avatar`
  - Accepts multipart/form-data with image file
  - Supports JPEG, PNG, GIF, and WebP formats
  - Returns updated user profile with new avatar URL

- **View Image Endpoint**: `GET /api/v1/files/images/:imageKey`
  - Retrieves profile pictures by image key
  - Used for displaying avatars throughout the app

- **User Info Endpoint**: `GET /api/v1/users/me`
  - Fetches current user profile data
  - Loads real user information (name, username, email, avatar)

### 2. User Interface
- **Interactive Avatar**: 
  - Tap to select new image from gallery
  - Displays current profile picture or initial letter
  - Shows loading indicator during upload
  - Camera icon overlay indicating editability

- **Real Data Display**:
  - Full name from API
  - Username with @ prefix
  - Email address
  - Avatar image (or fallback initial)

- **User Feedback**:
  - Success snackbar: "Profile picture updated successfully!"
  - Error snackbar: Displays specific error message
  - Loading overlay on avatar during upload

### 3. State Management
- **Riverpod Providers**:
  - `currentUserProvider`: Global user state
  - `userProfileProvider`: Profile operation state (loading/success/error)
  - `isUserLoggedInProvider`: Derived login state

- **State Flow**:
  1. Initial: Profile screen loads
  2. Loading: Fetching user data from API
  3. Success: Display user profile
  4. Upload Loading: Image selection and upload
  5. Upload Success: Avatar updated, UI refreshed

### 4. Image Handling
- **Selection**: Uses `image_picker` package
- **Optimization**:
  - Max width: 1024px
  - Max height: 1024px
  - Quality: 85%
- **Formats**: JPEG, PNG, GIF, WebP
- **MIME Type Detection**: Automatic based on file extension

## Architecture

### Layer Structure
```
lib/features/user/
├── data/
│   ├── datasources/
│   │   └── user_datasource.dart        # API calls
│   └── repositories/
│       └── user_repository.dart        # Business logic
└── presentation/
    └── viewmodel/
        └── user_profile_viewmodel.dart # State management
```

### Data Flow
```
UI (ProfileScreen)
  ↓ User Action (tap avatar)
  ↓
ViewModel (UserProfileNotifier)
  ↓ Call repository method
  ↓
Repository (UserRepository)
  ↓ Call data source
  ↓
DataSource (UserDataSource)
  ↓ HTTP Request
  ↓
API Server
  ↓ Response
  ↓
Update State → Refresh UI
```

## Usage

### 1. Profile Screen Initialization
```dart
// Automatically fetches user data on load
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    ref.read(userProfileProvider.notifier).fetchUserInfo();
  });
}
```

### 2. Avatar Upload
```dart
// Triggered by tapping avatar
void _pickAndUploadAvatar() async {
  final image = await _imagePicker.pickImage(
    source: ImageSource.gallery,
    maxWidth: 1024,
    maxHeight: 1024,
    imageQuality: 85,
  );
  
  if (image != null) {
    await ref.read(userProfileProvider.notifier)
        .uploadAvatar(File(image.path));
  }
}
```

### 3. Display Avatar
```dart
// Shows network image or fallback initial
CircleAvatar(
  radius: 50,
  backgroundImage: fullImageUrl != null 
      ? NetworkImage(fullImageUrl) 
      : null,
  child: fullImageUrl == null
      ? Text(currentUser?.fullName.substring(0, 1).toUpperCase() ?? 'U')
      : null,
)
```

## Testing

### Test Coverage: 52 Tests

#### Unit Tests (27 tests)
- API endpoint configuration
- User model serialization/deserialization
- Auth model validation
- State management logic
- Error handling

#### Widget Tests (25 tests)
- UI component rendering
- User interactions
- State-driven UI updates
- Provider integration
- Error display

### Running Tests
```bash
# Run all tests with coverage
flutter test ./test --coverage

# View coverage report in console
flutter pub run test_cov_console
```

See [TESTING.md](./TESTING.md) for detailed test documentation.

## Dependencies

### Production Dependencies
```yaml
dependencies:
  image_picker: ^1.0.7      # Image selection from gallery/camera
  http_parser: ^4.0.2       # MIME type handling for uploads
  dio: ^5.4.0               # HTTP client (existing)
  flutter_riverpod: ^3.2.0  # State management (existing)
```

### Development Dependencies
```yaml
dev_dependencies:
  mockito: ^5.4.4            # Mocking for tests
  build_runner: ^2.4.8       # Code generation
  test_cov_console: ^0.2.2   # Coverage reporting
```

## API Requirements

### Upload Avatar
**Request**:
```http
POST /api/v1/users/me/avatar
Content-Type: multipart/form-data

avatar: <image-file>
```

**Response**:
```json
{
  "status_code": 200,
  "success": true,
  "message": "Avatar updated successfully",
  "data": {
    "_id": "user123",
    "full_name": "John Doe",
    "username": "johndoe",
    "email_address": "john@example.com",
    "avatar_url": "image_key_abc123",
    "created_at": "2024-01-01T00:00:00Z"
  }
}
```

### Get User Info
**Request**:
```http
GET /api/v1/users/me
Authorization: Bearer <token>
```

**Response**: Same structure as upload avatar response

### View Image
**Request**:
```http
GET /api/v1/files/images/:imageKey
```

**Response**: Image file (JPEG/PNG/etc.)

## Error Handling

### Scenarios Covered:
1. **Network Errors**: Displays "Failed to upload avatar: Network error"
2. **Server Errors**: Shows server error message
3. **File Selection Cancelled**: Silent (no error shown)
4. **Invalid File Format**: Caught and displayed
5. **Upload Timeout**: Shows timeout message

### Error Display:
```dart
if (state.status == UserProfileStatus.error) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Error: ${state.errorMessage}'),
      backgroundColor: Colors.red,
    ),
  );
}
```

## Performance Optimizations

1. **Image Compression**: 
   - Reduces file size before upload
   - Quality: 85% maintains visual quality
   - Max dimensions: 1024x1024

2. **Lazy Loading**:
   - User info fetched on demand
   - Avatar loaded only when visible

3. **State Caching**:
   - User data cached in `currentUserProvider`
   - Reduces unnecessary API calls

4. **Progress Indication**:
   - Visual feedback during operations
   - Prevents duplicate uploads

## Future Enhancements

### Potential Improvements:
1. **Image Cropping**: Add crop UI before upload
2. **Multiple Aspect Ratios**: Support different profile picture sizes
3. **Camera Capture**: Direct camera access
4. **Avatar Gallery**: Pre-made avatars/stickers
5. **Compression Settings**: User-controlled quality
6. **Offline Support**: Queue uploads when offline
7. **Avatar History**: View/revert to previous avatars
8. **Custom Frames**: Decorative borders/effects

## Troubleshooting

### Issue: Avatar not uploading
**Solutions**:
- Check internet connection
- Verify API endpoint is accessible
- Ensure authentication token is valid
- Check file format is supported

### Issue: Image not displaying
**Solutions**:
- Verify image URL from API response
- Check network connectivity
- Clear app cache
- Validate image key format

### Issue: Tests failing
**Solutions**:
```bash
# Clean and rebuild
flutter clean
flutter pub get

# Run tests individually
flutter test test/unit/api_endpoints_test.dart
```

## Contributing

When extending this feature:
1. Add tests for new functionality
2. Update API documentation
3. Follow existing code patterns
4. Ensure error handling
5. Update this README

## License

Part of the SociaaNet project - 5th semester social media platform.
