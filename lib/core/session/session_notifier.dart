import 'dart:async';

enum SessionEndReason { expired, suspended }

class SessionNotifier {
  final _controller = StreamController<SessionEndReason>.broadcast();

  Stream<SessionEndReason> get stream => _controller.stream;

  void end(SessionEndReason reason) => _controller.add(reason);
}
