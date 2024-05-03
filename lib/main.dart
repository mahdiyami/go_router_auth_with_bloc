import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_auth_with_bloc/app_router.dart';
import 'package:go_router_auth_with_bloc/auth_bloc/authentication_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthenticationBloc authBloc = AuthenticationBloc();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //create GoRouter instance
    final GoRouter router = GoRouter(
      initialLocation: AppRouter.splashPath,
      routes: [
        //path "/splash"
        //name "splash"
        GoRoute(
          path: AppRouter.splashPath,
          name: AppRouteName.splash.name,
          builder: (context, state) => const SplashPage(),
        ),
        //path "/login"
        //name "login"
        GoRoute(
          path: AppRouter.loginPath,
          name: AppRouteName.login.name,
          builder: (context, state) => const LoginPage(),
        ),
        //path "/home"
        //name "home"
        GoRoute(
          path: AppRouter.homePath,
          name: AppRouteName.home.name,
          builder: (context, state) => const HomePage(),
        ),
      ],
      // changes on the listenable will cause the router to refresh it's route
      refreshListenable: StreamToListenable([authBloc.stream]),
      //The top-level callback allows the app to redirect to a new location.
      redirect: (context, state) {
        final isAuthenticated = authBloc.state is Authenticated;
        final isUnAuthenticated = authBloc.state is Unauthenticated;

        // Redirect to the login page if the user is not authenticated, and if authenticated, do not show the login page
        if (isUnAuthenticated && !state.matchedLocation.contains(AppRouter.loginPath)) {
          return AppRouter.loginPath;
        }
        // Redirect to the home page if the user is authenticated
        else if (isAuthenticated) {
          return AppRouter.homePath;
        }
        return null;
      },
    );

    return BlocProvider<AuthenticationBloc>(
      create: (context) => authBloc,
      child: MaterialApp.router(
        title: 'Bloc with GoRouter Example',
        debugShowCheckedModeBanner: false,
        routeInformationProvider: router.routeInformationProvider,
        routerDelegate: router.routerDelegate,
        routeInformationParser: router.routeInformationParser,
        // Using GoRouter for navigation
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bloc Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('User is currently logged in'),
            ElevatedButton(
              onPressed: () {
                BlocProvider.of<AuthenticationBloc>(context).add(const LoggedOut());
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bloc Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('User is currently logged out'),
            ElevatedButton(
              onPressed: () {
                BlocProvider.of<AuthenticationBloc>(context).add(const LoggedIn());
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    // wait for 2 seconds to show splash screen
    Future.delayed(const Duration(seconds: 2), () {
      if(mounted) {
        BlocProvider.of<AuthenticationBloc>(context).add(const AuthenticationStatusChecked());
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Center(
            child: Text('Splash Page', style: TextStyle(fontSize: 20)),
          ),
          CircularProgressIndicator()
        ],
      ),
    ));
  }
}

// for convert stream to listenable
class StreamToListenable extends ChangeNotifier {
  late final List<StreamSubscription> subscriptions;

  StreamToListenable(List<Stream> streams) {
    subscriptions = [];
    for (var e in streams) {
      var s = e.asBroadcastStream().listen(_tt);
      subscriptions.add(s);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    for (var e in subscriptions) {
      e.cancel();
    }
    super.dispose();
  }

  void _tt(event) => notifyListeners();
}
