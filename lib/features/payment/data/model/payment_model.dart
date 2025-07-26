class PaymentModel {
  final String? paymentId;
  final String? orderId;
  final String? signature;
  final String name;
  final String email;
  final String contact;
  final int amount;
  final String currency;

  PaymentModel({
    this.paymentId,
    this.orderId,
    this.signature,
    required this.name,
    required this.email,
    required this.contact,
    required this.amount,
    required this.currency,
  });

  Map<String, dynamic> toMap() {
    return {
      'paymentId': paymentId,
      'orderId': orderId,
      'signature': signature,
      'name': name,
      'email': email,
      'contact': contact,
      'amount': amount,
      'currency': currency,
    };
  }
}
