import 'dart:convert';
import 'package:drift/drift.dart' hide Column;
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

/// Notifier for managing posts with offline-first support.
class PostsNotifier extends StateNotifier<PostsState> {
  final Ref _ref;
  final String trackerId;

  PostsNotifier(this._ref, this.trackerId) : super(const PostsLoading()) {
    loadPosts();
  }

  bool get _isOnline => _ref.read(connectivityProvider) == ConnectivityState.online;

  PostDao get _postDao => _ref.read(postDaoProvider);

  /// Load all posts for this tracker.
  Future<void> loadPosts() async {
    if (mounted) state = const PostsLoading();

    try {
      final posts = await _postDao.getPostsForTracker(trackerId);
      final domainPosts = posts.map((p) => PostModel.fromDb(p)).toList();

      if (mounted) {
        state = PostsLoaded(domainPosts, trackerId: trackerId);
      }

      // Sync from remote if online
      if (_isOnline) {
        await _syncFromRemote();
      }
    } catch (e) {
      if (mounted) state = PostsError('Failed to load posts: $e');
    }
  }

  /// Sync posts from Supabase to local database.
  Future<void> _syncFromRemote() async {
    try {
      final response = await SupabaseConfig.client
          .from('posts')
          .select('*')
          .eq('tracker_id', trackerId)
          .order('published_date', ascending: false);

      for (final data in (response as List)) {
        final postCompanion = PostsCompanion(
          id: Value(data['id'] as String),
          trackerId: Value(data['tracker_id'] as String),
          title: Value(data['title'] as String),
          platform: Value(data['platform'] as String),
          url: Value(data['url'] as String?),
          publishedDate: Value(data['published_date'] != null
              ? DateTime.parse(data['published_date'] as String)
              : null),
          notes: Value(data['notes'] as String?),
          createdAt: Value(DateTime.parse(data['created_at'] as String)),
          updatedAt: Value(DateTime.parse(data['updated_at'] as String)),
          syncStatus: const Value('synced'),
        );
        await _postDao.insertPost(postCompanion);
      }

      // Reload from local to update UI
      final posts = await _postDao.getPostsForTracker(trackerId);
      final domainPosts = posts.map((p) => PostModel.fromDb(p)).toList();

      if (mounted) {
        state = PostsLoaded(domainPosts, trackerId: trackerId);
      }
    } catch (e) {
      // Sync failed but local data is still shown - silent fail
    }
  }

  /// Create a new post.
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

    try {
      final syncDao = _ref.read(syncDaoProvider);

      final post = PostModel.create(
        trackerId: trackerId,
        title: title.trim(),
        platform: platform,
        url: url?.trim(),
        publishedDate: publishedDate,
        notes: notes?.trim(),
      );

      // Save to local database
      final postCompanion = PostsCompanion.insert(
        id: post.id,
        trackerId: post.trackerId,
        title: post.title,
        platform: post.platform,
        url: Value(post.url),
        publishedDate: Value(post.publishedDate),
        notes: Value(post.notes),
        syncStatus: Value(_isOnline ? 'synced' : 'pending'),
      );

      await _postDao.insertPost(postCompanion);

      // Sync to remote if online
      if (_isOnline) {
        try {
          await SupabaseConfig.client.from('posts').insert(post.toMap());
          await _postDao.markAsSynced(post.id);
        } catch (e) {
          await syncDao.addToQueue(
            targetTable: 'posts',
            recordId: post.id,
            operation: 'insert',
            payload: jsonEncode(post.toMap()),
          );
        }
      } else {
        await syncDao.addToQueue(
          targetTable: 'posts',
          recordId: post.id,
          operation: 'insert',
          payload: jsonEncode(post.toMap()),
        );
      }

      await loadPosts();
      return PostResult.success(post);
    } catch (e) {
      return PostResult.error('Failed to create post: $e');
    }
  }

  /// Update an existing post.
  Future<PostResult> updatePost(PostModel post) async {
    if (post.title.trim().length < 3) {
      return PostResult.error('Title must be at least 3 characters');
    }

    try {
      final syncDao = _ref.read(syncDaoProvider);
      final updatedPost = post.copyWith(updatedAt: DateTime.now());

      // Update local
      final postCompanion = PostsCompanion(
        id: Value(updatedPost.id),
        trackerId: Value(updatedPost.trackerId),
        title: Value(updatedPost.title),
        platform: Value(updatedPost.platform),
        url: Value(updatedPost.url),
        publishedDate: Value(updatedPost.publishedDate),
        notes: Value(updatedPost.notes),
        createdAt: Value(updatedPost.createdAt),
        updatedAt: Value(updatedPost.updatedAt),
        syncStatus: Value(_isOnline ? 'synced' : 'pending'),
      );

      await _postDao.updatePost(postCompanion);

      // Sync to remote if online
      if (_isOnline) {
        try {
          await SupabaseConfig.client
              .from('posts')
              .update(updatedPost.toMap())
              .eq('id', post.id);
          await _postDao.markAsSynced(post.id);
        } catch (e) {
          await syncDao.addToQueue(
            targetTable: 'posts',
            recordId: post.id,
            operation: 'update',
            payload: jsonEncode(updatedPost.toMap()),
          );
        }
      } else {
        await syncDao.addToQueue(
          targetTable: 'posts',
          recordId: post.id,
          operation: 'update',
          payload: jsonEncode(updatedPost.toMap()),
        );
      }

      await loadPosts();
      return PostResult.success(updatedPost);
    } catch (e) {
      return PostResult.error('Failed to update post: $e');
    }
  }

  /// Delete a post.
  Future<PostResult> deletePost(String postId) async {
    try {
      final syncDao = _ref.read(syncDaoProvider);

      // Delete locally
      await _postDao.deletePost(postId);

      // Sync to remote if online
      if (_isOnline) {
        try {
          await SupabaseConfig.client.from('posts').delete().eq('id', postId);
        } catch (e) {
          await syncDao.addToQueue(
            targetTable: 'posts',
            recordId: postId,
            operation: 'delete',
            payload: '{}',
          );
        }
      } else {
        await syncDao.addToQueue(
          targetTable: 'posts',
          recordId: postId,
          operation: 'delete',
          payload: '{}',
        );
      }

      await syncDao.clearForRecord(postId);
      await loadPosts();
      return PostResult.success(null);
    } catch (e) {
      return PostResult.error('Failed to delete post: $e');
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
