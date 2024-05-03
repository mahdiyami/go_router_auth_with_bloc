import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(const Uninitialized()) {
    on<LoggedIn>((event, emit) {
      emit(const AuthenticationLoadInProgress());
      // Here you would write the login system code
      // For simplicity, let's assume the login is successful
      emit(const Authenticated());
    });

    on<LoggedOut>((event, emit) {
      emit(const AuthenticationLoadInProgress());
      // Here you would write the logout system code
      emit(const Unauthenticated());
    });

    on<AuthenticationStatusChecked>((event, emit)async {
      emit(const AuthenticationLoadInProgress());
      emit(const Authenticated());
    });
  }
}
