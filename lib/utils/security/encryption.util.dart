
import 'package:encrypt/encrypt.dart';

class MyEncryption {
  // 32 lenght key
  static final key = Key.fromUtf8("A3d9f5G8h1KjLpQr");
  // Generate a random IV (initialization vector)
  static final iv = IV.fromLength(16);
  // Create an encrypter instance
  static final encrypter = Encrypter(AES(key));

  static encryptAes(String plainText) {
    return encrypter.encrypt(plainText, iv: iv).base16;
  }

  static decryptAes(String encryptedDataBase16){
    return encrypter.decrypt16(encryptedDataBase16,iv: iv);
  }
}
