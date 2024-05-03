part of 'authentication_bloc.dart';

@immutable
sealed class AuthenticationEvent {
  const AuthenticationEvent();
}


class LoggedIn extends AuthenticationEvent {

  const LoggedIn();
}


class LoggedOut extends AuthenticationEvent {

  const LoggedOut();
}


class AuthenticationStatusChecked extends AuthenticationEvent {

  const AuthenticationStatusChecked();
}
