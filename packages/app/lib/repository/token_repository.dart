import 'package:external_todo/api.dart';
import 'package:riverpod/riverpod.dart';

abstract class ITokenRepository {
  Authentication createAuthentication();
}

class TokenRepository implements ITokenRepository {
  String _getIdToken() {
    return 'test';
  }

  @override
  Authentication createAuthentication() {
    final authentication = HttpBearerAuth();
    authentication.accessToken = _getIdToken;

    return authentication;
  }
}

final tokenRepositoryProvider = Provider.autoDispose<ITokenRepository>(
  (ref) => TokenRepository(),
);
