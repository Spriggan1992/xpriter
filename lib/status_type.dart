enum StatusType {
  success(1),
  connectionFailed(2),
  sendFailed(3),
  interrupt(4);

  const StatusType(this.value);
  final int value;

  factory StatusType.fromValue(int value) => switch (value) {
        1 => StatusType.success,
        2 => StatusType.connectionFailed,
        3 => StatusType.sendFailed,
        _ => StatusType.interrupt,
      };

  String get statusString => switch (this) {
        success => 'Connection success',
        connectionFailed => 'Connection failed',
        sendFailed => 'Send to print failed',
        interrupt => 'Connection has disconnected'
      };
}
