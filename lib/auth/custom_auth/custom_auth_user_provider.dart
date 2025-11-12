import 'package:rxdart/rxdart.dart';

import 'custom_auth_manager.dart';

class Proyecto1608XproDigitalTVAuthUser {
  Proyecto1608XproDigitalTVAuthUser({required this.loggedIn, this.uid});

  bool loggedIn;
  String? uid;
}

/// Generates a stream of the authenticated user.
BehaviorSubject<Proyecto1608XproDigitalTVAuthUser>
    proyecto1608XproDigitalTVAuthUserSubject =
    BehaviorSubject.seeded(Proyecto1608XproDigitalTVAuthUser(loggedIn: false));
Stream<Proyecto1608XproDigitalTVAuthUser>
    proyecto1608XproDigitalTVAuthUserStream() =>
        proyecto1608XproDigitalTVAuthUserSubject
            .asBroadcastStream()
            .map((user) => currentUser = user);
