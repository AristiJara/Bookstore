import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bookshop/core/utils/secure_storage.dart';
import 'package:bookshop/providers/user_provider.dart';
import 'package:bookshop/providers/token_provider.dart';
import 'app.dart';
import 'models/user.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final User? user = await SecureStorage.readUser();
  final tokens = await SecureStorage.readTokens();
  final accessToken = tokens['access'];

  runApp(
    ProviderScope(
      overrides: [
        userProvider.overrideWith((ref) => UserNotifier()..setUser(user)),
        tokenProvider.overrideWith((ref) => accessToken),
      ],
      child: const MyApp(),
    ),
  );
}