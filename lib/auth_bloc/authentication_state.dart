part of 'authentication_bloc.dart';

@immutable
sealed class AuthenticationState {
  const AuthenticationState();
}
class Uninitialized extends AuthenticationState {
  const Uninitialized();
}
class Unauthenticated extends AuthenticationState {
  const Unauthenticated();
}

class Authenticated extends AuthenticationState {
  const Authenticated();
}

class AuthenticationLoadInProgress extends AuthenticationState {
  const AuthenticationLoadInProgress();
}
