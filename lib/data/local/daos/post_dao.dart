import 'package:drift/drift.dart';

import '../database.dart';

/// Data access object for Posts operations.
class PostDao {
  final AppDatabase _db;

  PostDao(this._db);

  /// Get all posts for a tracker.
  Future<List<Post>> getPostsForTracker(String trackerId) async {
    return (_db.select(_db.posts)
          ..where((t) => t.trackerId.equals(trackerId))
          ..orderBy([
            (t) => OrderingTerm(expression: t.publishedDate, mode: OrderingMode.desc),
          ]))
        .get();
  }

  /// Watch posts for a tracker (reactive stream).
  Stream<List<Post>> watchPostsForTracker(String trackerId) {
    return (_db.select(_db.posts)
          ..where((t) => t.trackerId.equals(trackerId))
          ..orderBy([
            (t) => OrderingTerm(expression: t.publishedDate, mode: OrderingMode.desc),
          ]))
        .watch();
  }

  /// Get a single post by ID.
  Future<Post?> getPost(String id) async {
    return (_db.select(_db.posts)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// Insert a new post.
  Future<void> insertPost(PostsCompanion post) async {
    await _db.into(_db.posts).insert(post);
  }

  /// Update an existing post.
  Future<void> updatePost(PostsCompanion post) async {
    await (_db.update(_db.posts)..where((t) => t.id.equals(post.id.value))).write(post);
  }

  /// Delete a post.
  Future<void> deletePost(String id) async {
    await (_db.delete(_db.posts)..where((t) => t.id.equals(id))).go();
  }

  /// Mark post as synced.
  Future<void> markAsSynced(String id) async {
    await (_db.update(_db.posts)..where((t) => t.id.equals(id))).write(
      const PostsCompanion(syncStatus: Value('synced')),
    );
  }

  /// Get count of posts for a tracker.
  Future<int> getPostCount(String trackerId) async {
    final count = _db.posts.id.count();
    final query = _db.selectOnly(_db.posts)
      ..addColumns([count])
      ..where(_db.posts.trackerId.equals(trackerId));
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  /// Get ALL posts (for data recovery).
  Future<List<Post>> getAllPosts() async {
    return (_db.select(_db.posts)
          ..orderBy([
            (t) => OrderingTerm(expression: t.publishedDate, mode: OrderingMode.desc),
          ]))
        .get();
  }
}
