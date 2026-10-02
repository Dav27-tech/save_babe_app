import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_keys.dart';
import '../services/local_storage_service.dart';
import 'app_user_state.dart';

class AppUserNotifier extends StateNotifier<AppUserState> {
  AppUserNotifier(this._storageService) : super(const AppUserState()) {
    load();
  }

  final LocalStorageService _storageService;
  static const String _stateStorageKey = 'savebabe-state-v1';

  Future<void> load() async {
    try {
      final raw = _storageService.get<String>(AppKeys.userStateBox, _stateStorageKey);
      if (raw != null && raw.isNotEmpty) {
        final map = jsonDecode(raw) as Map<dynamic, dynamic>;
        state = AppUserState.fromJson(map);
      }
    } catch (_) {
      // Fallback sur l'\''état initial en cas d'\''erreur
    }
  }

  Future<void> _persist() async {
    try {
      final raw = jsonEncode(state.toJson());
      await _storageService.save(AppKeys.userStateBox, _stateStorageKey, raw);
    } catch (_) {}
  }

  Future<void> update(AppUserState Function(AppUserState current) updater) async {
    state = updater(state);
    await _persist();
  }

  Future<void> setOnboardingData({
    required String name,
    required String contact,
    required String lmp,
    required String firstPregnancy,
    required String center,
    required ConsentSettings consent,
  }) async {
    state = state.copyWith(
      name: name,
      contact: contact,
      lmp: lmp,
      firstPregnancy: firstPregnancy,
      center: center,
      consent: consent,
      onboarded: true,
    );
    await _persist();
  }

  Future<void> addAppointment(Appointment appt) async {
    final list = [...state.appointments, appt];
    state = state.copyWith(appointments: list);
    await _persist();
  }

  Future<void> removeAppointment(String id) async {
    final list = state.appointments.where((a) => a.id != id).toList();
    state = state.copyWith(appointments: list);
    await _persist();
  }

  Future<void> addMeasure(Measure measure) async {
    final list = [measure, ...state.measures];
    state = state.copyWith(measures: list);
    await _persist();
  }

  Future<void> setHealthRecords(List<HealthRecord> records) async {
    state = state.copyWith(record: records);
    await _persist();
  }

  Future<void> addHealthRecord(HealthRecord record) async {
    final list = [...state.record, record];
    state = state.copyWith(record: list);
    await _persist();
  }

  Future<void> setPartner(Partner? partner) async {
    state = state.copyWith(
      partner: partner,
      clearPartner: partner == null,
    );
    await _persist();
  }

  Future<void> setBaby(Baby? baby) async {
    state = state.copyWith(
      baby: baby,
      clearBaby: baby == null,
    );
    await _persist();
  }

  Future<void> addBabyLog(BabyLogEntry entry) async {
    final list = [entry, ...state.babyLog];
    state = state.copyWith(babyLog: list);
    await _persist();
  }

  Future<void> setAiPrivacy(AiPrivacySettings settings) async {
    state = state.copyWith(aiPrivacy: settings);
    await _persist();
  }

  Future<void> setTheme(String theme) async {
    state = state.copyWith(theme: theme);
    await _persist();
  }

  Future<void> setLanguage(String language, String country) async {
    state = state.copyWith(language: language, country: country);
    await _persist();
  }

  Future<void> reset() async {
    await _storageService.clear(AppKeys.userStateBox);
    state = const AppUserState();
    await _persist();
  }
}
