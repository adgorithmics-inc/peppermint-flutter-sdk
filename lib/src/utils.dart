class Utils{
  Utils._();

  /// Trim private key string.
  /// This is used because web3dart package sometimes create unwanted 00
  /// in front of generated private key string
  static String getPrettyPrivateKey(privateKey) {
    if (privateKey == null) return privateKey;
    if (privateKey.length > 64) {
      privateKey =
          privateKey.substring(privateKey.length - 64, privateKey.length);
    }
    return privateKey;
  }
}