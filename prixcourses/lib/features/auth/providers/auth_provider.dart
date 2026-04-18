import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/services/api_service.dart';

class AuthState {
  final bool isAuthenticated;
  final String? userId;
  final String? email;
  final String? name;
  final String? token;

  const AuthState({
    this.isAuthenticated = false,
    this.userId,
    this.email,
    this.name,
    this.token,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    String? userId,
    String? email,
    String? name,
    String? token,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      userId: userId ?? this.userId,
      email: email ?? this.email,
      name: name ?? this.name,
      token: token ?? this.token,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final ApiService _apiService;
  final Box _authBox;

  AuthNotifier(this._apiService)
      : _authBox = Hive.box(AppConstants.authBox),
        super(const AuthState()) {
    _loadSavedAuth();
  }

  void _loadSavedAuth() {
    final savedToken = _authBox.get('token');
    if (savedToken != null) {
      _apiService.setToken(savedToken);
      state = state.copyWith(
        isAuthenticated: true,
        token: savedToken,
        userId: _authBox.get('userId'),
        email: _authBox.get('email'),
        name: _authBox.get('name'),
      );
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.register(
        name: name,
        email: email,
        password: password,
      );
      final token = response['token'] as String;
      final user = response['user'];

      await _authBox.put('token', token);
      await _authBox.put('userId', user['id']);
      await _authBox.put('email', user['email']);
      await _authBox.put('name', user['name']);

      _apiService.setToken(token);
      state = state.copyWith(
        isAuthenticated: true,
        token: token,
        userId: user['id'].toString(),
        email: user['email'],
        name: user['name'],
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.login(
        email: email,
        password: password,
      );
      final token = response['token'] as String;
      final user = response['user'];

      await _authBox.put('token', token);
      await _authBox.put('userId', user['id']);
      await _authBox.put('email', user['email']);
      await _authBox.put('name', user['name']);

      _apiService.setToken(token);
      state = state.copyWith(
        isAuthenticated: true,
        token: token,
        userId: user['id'].toString(),
        email: user['email'],
        name: user['name'],
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await _apiService.logout();
    } catch (_) {}

    await _authBox.delete('token');
    await _authBox.delete('userId');
    await _authBox.delete('email');
    await _authBox.delete('name');

    state = const AuthState();
  }
}

final apiServiceProvider = Provider((ref) => ApiService());

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(apiServiceProvider));
});
