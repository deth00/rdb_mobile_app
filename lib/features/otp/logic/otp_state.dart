enum OtpStatus { idle, sending, sent, verifying, success, error }

class OtpState {
  final OtpStatus status;
  final String? errorMessage;
  final int resendSecondsLeft;
  final int otpExpiresIn;

  OtpState({
    this.status = OtpStatus.idle,
    this.errorMessage,
    this.resendSecondsLeft = 0,
    this.otpExpiresIn = 0, // ค่า default
  });

  OtpState copyWith({
    OtpStatus? status,
    String? errorMessage,
    int? resendSecondsLeft,
    int? otpExpiresIn,
  }) {
    return OtpState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      resendSecondsLeft: resendSecondsLeft ?? this.resendSecondsLeft,
      otpExpiresIn: otpExpiresIn ?? this.otpExpiresIn,
    );
  }
}
