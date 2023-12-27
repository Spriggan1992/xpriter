enum StatusType {
  success(1),
  connectionFailed(2),
  sendFailed(3);

  const StatusType(this.value);
  final int value;

  factory StatusType.fromValue(int value) => switch (value) {
        1 => StatusType.success,
        2 => StatusType.connectionFailed,
        _ => StatusType.sendFailed,
      };

  String get statusString => switch (this) {
        success => 'Connection success',
        connectionFailed => 'Connection failed',
        sendFailed => 'Send to print failed'
      };
}
