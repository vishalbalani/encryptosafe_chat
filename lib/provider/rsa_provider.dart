import 'dart:math';

Map<String, dynamic> generateRSAKeys() {
  final Random random = Random.secure();

  // Step 1: Choose three distinct prime numbers, p1, p2, and p3
  final int p1 = getPrimeNumber(random);
  final int p2 = getPrimeNumber(random);
  final int p3 = getPrimeNumber(random);

  // Step 2: Compute n (the modulus for the public and private keys)
  final int n = p1 * p2 * p3;

  // Step 3: Compute the totient of n (Euler's totient function)
  final int phi = (p1 - 1) * (p2 - 1) * (p3 - 1);

  // Step 4: Choose an integer e such that 1 < e < phi(n) and gcd(e, phi(n)) = 1
  int e;
  do {
    e = random.nextInt(phi - 2) + 2; // e must be greater than 1
  } while (gcd(e, phi) != 1);

  // Step 5: Compute d, the modular multiplicative inverse of e modulo phi(n)
  final int d = modInverse(e, phi);

  // Public key: (e, n)
  // Private key: (d, n)
  return {
    'public': {'e': e, 'n': n},
    'private': {'d': d, 'n': n}
  };
}

int getPrimeNumber(Random random) {
  // Generate a random prime number (for simplicity, this function is not optimized)
  int candidate = random.nextInt(100) + 50; // Adjust the range as needed

  while (!isPrime(candidate)) {
    candidate++;
  }

  return candidate;
}

bool isPrime(int number) {
  if (number < 2) return false;
  for (int i = 2; i <= sqrt(number); i++) {
    if (number % i == 0) {
      return false;
    }
  }
  return true;
}

int gcd(int a, int b) {
  while (b != 0) {
    final int temp = b;
    b = a % b;
    a = temp;
  }
  return a;
}

int modInverse(int a, int m) {
  int m0 = m, t, q;
  int x0 = 0, x1 = 1;

  if (m == 1) return 0;

  // Apply extended Euclid Algorithm
  while (a > 1) {
    q = a ~/ m;
    t = m;

    m = a % m;
    a = t;
    t = x0;

    x0 = x1 - q * x0;
    x1 = t;
  }

  // Make x1 positive
  if (x1 < 0) {
    x1 += m0;
  }

  return x1;
}

int modPow(int base, int exponent, int modulus) {
  int result = 1;
  base = base % modulus;

  while (exponent > 0) {
    if (exponent % 2 == 1) {
      result = (result * base) % modulus;
    }

    exponent = exponent >> 1;
    base = (base * base) % modulus;
  }

  return result;
}

int encryptMessage(int message, int e, int n, int position) {
  // Add the position of the character to the character itself
  int modifiedMessage = message + position;

  return modPow(modifiedMessage, e, n);
}

int decryptMessage(int message, int d, int n, int position) {
  int decryptedMessage = modPow(message, d, n);

  // To retrieve the original character, subtract the position
  return (decryptedMessage - position) % 256; // Assuming ASCII characters
}

String encrypt(String plaintext, Map<String, dynamic>? publicKey) {
  if (publicKey == null || publicKey['e'] == null || publicKey['n'] == null) {
    // Handle the case where the publicKey or its values are null
    return ''; // Return an appropriate value or handle the error
  }

  final List<int> encryptedMessage = [];

  for (int i = 0; i < plaintext.length; i++) {
    final charCode = plaintext.codeUnitAt(i);
    encryptedMessage
        .add(encryptMessage(charCode, publicKey['e']!, publicKey['n']!, i));
    // Use 'publicKey['e']!' and 'publicKey['n']!' with '!' to assert non-null values
  }

  return encryptedMessage.join(',');
}

String decrypt(String ciphertext, Map<String, dynamic> privateKey) {
  final List<int> ciphertextList =
      ciphertext.split(',').map((e) => int.parse(e)).toList();

  final List<String> decryptedMessage = [];

  for (int i = 0; i < ciphertextList.length; i++) {
    final charCode =
        decryptMessage(ciphertextList[i], privateKey['d'], privateKey['n'], i);
    decryptedMessage.add(String.fromCharCode(charCode));
  }

  return decryptedMessage.join();
}
