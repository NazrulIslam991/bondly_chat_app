part of 'route_import_path.dart';

class AppRouter {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case RouteName.splashScreen:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case RouteName.loginScreen:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case RouteName.otpScreen:
        return MaterialPageRoute(builder: (_) => OtpVerification());
      case RouteName.profileSetupScreen:
        return MaterialPageRoute(builder: (_) => ProfileSetupScreen());
      case RouteName.navbarScreen:
        return MaterialPageRoute(builder: (_) => NavbarScreen());
      case RouteName.chatScreen:
        return MaterialPageRoute(builder: (_) => ChatScreen());
      default:
        return unDefineRoute();
    }
  }

  static Route<dynamic> unDefineRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        // appBar: AppBar(title: Text(AppString.noRoute)),
        // body: Center(child: Text(AppString.noRoute)),
      ),
    );
  }
}
