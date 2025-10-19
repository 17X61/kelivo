import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../models/backup.dart';
import '../../providers/settings_provider.dart';
import '../chat/chat_service.dart';
import 'data_sync.dart';

/// Periodically pulls the latest WebDAV backup and merges into local storage.
/// This runs only while the app is alive. It depends on SettingsProvider
/// for configuration, and ChatService for applying the restored data.
class WebDavAutoSyncService extends ChangeNotifier {
  final ChatService _chatService;
  final SettingsProvider _settings;

  late final DataSync _dataSync;

  Timer? _timer;
  bool _busy = false;
  DateTime? _lastRunAt;
  String? _lastError;

  // Snapshot of last applied settings to avoid unnecessary rescheduling
  bool _enabled = false;
  int _intervalMinutes = 60;

  WebDavAutoSyncService({required ChatService chatService, required SettingsProvider settings})
      : _chatService = chatService,
        _settings = settings {
    _dataSync = DataSync(chatService: _chatService);
    // Observe settings changes
    _settings.addListener(_onSettingsChanged);
    // Initialize from current settings
    _applyFromSettings();
  }

  bool get busy => _busy;
  DateTime? get lastRunAt => _lastRunAt;
  String? get lastError => _lastError;

  void _onSettingsChanged() {
    final nowEnabled = _settings.webDavAutoSyncEnabled;
    final nowInterval = _settings.webDavAutoSyncIntervalMinutes;
    if (nowEnabled != _enabled || nowInterval != _intervalMinutes) {
      _applyFromSettings();
    }
    // Also reschedule if WebDAV URL becomes available/changed
    // We don't diff config fields; simply reschedule on any change.
  }

  void _applyFromSettings() {
    _enabled = _settings.webDavAutoSyncEnabled;
    _intervalMinutes = _settings.webDavAutoSyncIntervalMinutes;
    _rescheduleTimer();
  }

  void _rescheduleTimer() {
    _timer?.cancel();
    _timer = null;
    if (!_enabled) return;
    // Trigger immediately then schedule periodic
    unawaited(_tick());
    final dur = Duration(minutes: _intervalMinutes <= 0 ? 60 : _intervalMinutes);
    _timer = Timer.periodic(dur, (_) => _tick());
  }

  Future<void> _tick() async {
    if (_busy) return;
    final cfg = _settings.webDavConfig;
    if (cfg.url.trim().isEmpty) return;
    _busy = true;
    _lastError = null;
    notifyListeners();
    try {
      // List remote and pick latest by lastModified or filename
      final items = await _dataSync.listBackupFiles(cfg);
      if (items.isEmpty) return;
      items.sort((a, b) {
        if (a.lastModified != null && b.lastModified != null) {
          return b.lastModified!.compareTo(a.lastModified!);
        }
        if (a.lastModified == null && b.lastModified == null) {
          return b.displayName.compareTo(a.displayName);
        }
        if (a.lastModified == null) return 1;
        return -1;
      });
      final latest = items.first;
      final lastSyncedName = _settings.webDavLastSyncedFile;
      if (lastSyncedName != null && lastSyncedName == latest.displayName) {
        _lastRunAt = DateTime.now();
        return; // nothing new
      }
      // Merge restore to avoid overriding local
      await _dataSync.restoreFromWebDav(cfg, latest, mode: RestoreMode.merge);
      _lastRunAt = DateTime.now();
      await _settings.setWebDavLastSyncedFile(latest.displayName);
    } catch (e) {
      _lastError = e.toString();
    } finally {
      _busy = false;
      notifyListeners();
    }
  }

  Future<void> triggerNow() async => _tick();

  @override
  void dispose() {
    _timer?.cancel();
    _settings.removeListener(_onSettingsChanged);
    super.dispose();
  }
}
