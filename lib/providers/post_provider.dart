// import 'package:drift/drift.dart' hide Column; // Removed - no longer using local caching
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../core/config/supabase_config.dart';
import '../core/constants/platform_constants.dart';
import '../data/local/database.dart';
import '../data/local/daos/post_dao.dart';
import 'connectivity_provider.dart';
import 'database_provider.dart';

/// Domain model for a post.
class PostModel {
  final String id;
  final String trackerId;
  final String title;
  final String platform;
  final String? url;
  final DateTime? publishedDate;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  PostModel({
    required this.id,
    required this.trackerId,
    required this.title,
    required this.platform,
    this.url,
    this.publishedDate,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create a new post with generated ID.
  factory PostModel.create({
    required String trackerId,
    required String title,
    required String platform,
    String? url,
    DateTime? publishedDate,
    String? notes,
  }) {
    final now = DateTime.now();
    return PostModel(
      id: const Uuid().v4(),
      trackerId: trackerId,
      title: title,
      platform: platform,
      url: url,
      publishedDate: publishedDate,
      notes: notes,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Create a copy with updated fields.
  PostModel copyWith({
    String? title,
    String? platform,
    String? url,
    DateTime? publishedDate,
    String? notes,
    DateTime? updatedAt,
  }) {
    return PostModel(
      id: id,
      trackerId: trackerId,
      title: title ?? this.title,
      platform: platform ?? this.platform,
      url: url ?? this.url,
      publishedDate: publishedDate ?? this.publishedDate,
      notes: notes ?? this.notes,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  /// Convert to map for Supabase.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tracker_id': trackerId,
      'title': title,
      'platform': platform,
      'url': url,
      'published_date': publishedDate?.toIso8601String(),
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Create from database Post.
  factory PostModel.fromDb(Post post) {
    return PostModel(
      id: post.id,
      trackerId: post.trackerId,
      title: post.title,
      platform: post.platform,
      url: post.url,
      publishedDate: post.publishedDate,
      notes: post.notes,
      createdAt: post.createdAt,
      updatedAt: post.updatedAt,
    );
  }
}

/// Available platforms for posts.
/// Available platforms for posts (uses PlatformConstants as single source of truth)
class PostPlatforms {
  /// Get all available platform names
  static List<String> get all =>
      PlatformConstants.platforms.map((p) => p.name).toList();
}

/// State for posts list for a specific tracker.
sealed class PostsState {
  const PostsState();
}

class PostsLoading extends PostsState {
  const PostsLoading();
}

class PostsLoaded extends PostsState {
  final List<PostModel> posts;
  final String trackerId;

  const PostsLoaded(this.posts, {required this.trackerId});

  /// Check if there are posts.
  bool get hasPosts => posts.isNotEmpty;

  /// Get posts count.
  int get count => posts.length;
}

class PostsError extends PostsState {
  final String message;
  const PostsError(this.message);
}

/// Provider for posts of a specific tracker.
final postsProvider = StateNotifierProvider.family<PostsNotifier, PostsState, String>((ref, trackerId) {
  return PostsNotifier(ref, trackerId);
});

/// Convenience provider to get a single post by ID.
final postByIdProvider = Provider.family<PostModel?, ({String trackerId, String postId})>((ref, params) {
  final state = ref.watch(postsProvider(params.trackerId));
  if (state is PostsLoaded) {
    try {
      return state.posts.firstWhere((p) => p.id == params.postId);
    } catch (_) {
      return null;
    }
  }
  return null;
});

/// Notifier for managing posts with online-first approach.
///
/// ONLINE-FIRST ARCHITECTURE:
/// 1. Check if online → if not, return friendly error
/// 2. Write to Supabase FIRST
/// 3. If Supabase fails → return friendly error (DO NOT save locally)
/// 4. If Supabase succeeds → cache locally
/// 5. No sync queue, no syncStatus checking
class PostsNotifier extends StateNotifier<PostsState> {
  final Ref _ref;
  final String trackerId;

  PostsNotifier(this._ref, this.trackerId) : super(const PostsLoading()) {
    loadPosts();
  }

  bool get _isOnline => _ref.read(connectivityProvider) == ConnectivityState.online;

  PostDao get _postDao => _ref.read(postDaoProvider);

  /// Convert technical errors to user-friendly messages
  String _getUserFriendlyError(dynamic error, String action) {
    final errorStr = error.toString().toLowerCase();

    // Network/connectivity errors
    if (errorStr.contains('network') ||
        errorStr.contains('socket') ||
        errorStr.contains('connection') ||
        errorStr.contains('timeout')) {
      return "We couldn't $action your post. Please check your internet connection and try again.";
    }

    // Supabase/server errors
    if (errorStr.contains('postgrest') ||
        errorStr.contains('supabase') ||
        errorStr.contains('server')) {
      return "We're having trouble connecting to our servers. Please try again in a moment.";
    }

    // Authentication errors
    if (errorStr.contains('auth') ||
        errorStr.contains('token') ||
        errorStr.contains('unauthorized')) {
      return "Your session has expired. Please sign in again.";
    }

    // Generic fallback
    return "We couldn't $action your post. Please try again.";
  }

  /// Load all posts for this tracker ONLY from Supabase.
  /// ONLINE-FIRST: Never loads from local cache.
  Future<void> loadPosts() async {
    if (mounted) state = const PostsLoading();

    try {
      // Check if online
      if (!_isOnline) {
        if (mounted) {
          state = const PostsError(
            "You're offline. Please check your internet connection and try again."
          );
        }
        return;
      }

      // Load ONLY from Supabase
      final response = await SupabaseConfig.client
          .from('posts')
          .select('*')
          .eq('tracker_id', trackerId)
          .order('published_date', ascending: false);

      // Convert to domain posts
      final domainPosts = (response as List).map((data) {
        return PostModel(
          id: data['id'] as String,
          trackerId: data['tracker_id'] as String,
          title: data['title'] as String,
          platform: data['platform'] as String,
          url: data['url'] as String?,
          publishedDate: data['published_date'] != null
              ? DateTime.parse(data['published_date'] as String)
              : null,
          notes: data['notes'] as String?,
          createdAt: DateTime.parse(data['created_at'] as String),
          updatedAt: DateTime.parse(data['updated_at'] as String),
        );
      }).toList();

      if (mounted) {
        state = PostsLoaded(domainPosts, trackerId: trackerId);
      }
    } catch (e) {
      if (mounted) state = PostsError(_getUserFriendlyError(e, 'load'));
    }
  }

  /// Create a new post (ONLINE-FIRST).
  Future<PostResult> createPost({
    required String title,
    required String platform,
    String? url,
    DateTime? publishedDate,
    String? notes,
  }) async {
    // Validate title
    if (title.trim().length < 3) {
      return PostResult.error('Title must be at least 3 characters');
    }

    // 1. Check if online
    if (!_isOnline) {
      return PostResult.error(
        "You're offline. Please check your internet connection and try again."
      );
    }

    try {
      final post = PostModel.create(
        trackerId: trackerId,
        title: title.trim(),
        platform: platform,
        url: url?.trim(),
        publishedDate: publishedDate,
        notes: notes?.trim(),
      );

      // 2. Write to Supabase FIRST
      try {
        await SupabaseConfig.client.from('posts').insert(post.toMap());
      } catch (e) {
        // 3. If Supabase fails, return friendly error (DO NOT save locally)
        return PostResult.error(_getUserFriendlyError(e, 'save'));
      }

      // NO local caching - Supabase is the source of truth

      await loadPosts();
      return PostResult.success(post);
    } catch (e) {
      return PostResult.error(_getUserFriendlyError(e, 'save'));
    }
  }

  /// Update an existing post (ONLINE-FIRST).
  Future<PostResult> updatePost(PostModel post) async {
    if (post.title.trim().length < 3) {
      return PostResult.error('Title must be at least 3 characters');
    }

    // 1. Check if online
    if (!_isOnline) {
      return PostResult.error(
        "You're offline. Please check your internet connection and try again."
      );
    }

    try {
      final updatedPost = post.copyWith(updatedAt: DateTime.now());

      // 2. Write to Supabase FIRST
      try {
        await SupabaseConfig.client
            .from('posts')
            .update(updatedPost.toMap())
            .eq('id', post.id);
      } catch (e) {
        // 3. If Supabase fails, return friendly error (DO NOT save locally)
        return PostResult.error(_getUserFriendlyError(e, 'update'));
      }

      // NO local caching - Supabase is the source of truth

      await loadPosts();
      return PostResult.success(updatedPost);
    } catch (e) {
      return PostResult.error(_getUserFriendlyError(e, 'update'));
    }
  }

  /// Delete a post (ONLINE-FIRST).
  Future<PostResult> deletePost(String postId) async {
    // 1. Check if online
    if (!_isOnline) {
      return PostResult.error(
        "You're offline. Please check your internet connection and try again."
      );
    }

    try {
      // 2. Delete from Supabase FIRST
      try {
        await SupabaseConfig.client.from('posts').delete().eq('id', postId);
      } catch (e) {
        // 3. If Supabase fails, return friendly error (DO NOT delete locally)
        return PostResult.error(_getUserFriendlyError(e, 'delete'));
      }

      // NO local caching - Supabase is the source of truth

      await loadPosts();
      return PostResult.success(null);
    } catch (e) {
      return PostResult.error(_getUserFriendlyError(e, 'delete'));
    }
  }
}

/// Result of a post operation.
class PostResult {
  final bool success;
  final PostModel? post;
  final String? error;

  const PostResult({
    required this.success,
    this.post,
    this.error,
  });

  factory PostResult.success(PostModel? post) => PostResult(
        success: true,
        post: post,
      );

  factory PostResult.error(String message) => PostResult(
        success: false,
        error: message,
      );
}
