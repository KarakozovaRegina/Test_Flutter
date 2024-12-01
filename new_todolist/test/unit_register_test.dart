import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:new_todolist/service/firebase_authentication.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();


    test('User Sign Up - Success', () async {
      final authService = AuthService();

      String email = 'test@example.com';
      String password = 'password123';
      String confirmPassword = 'password123';

      await authService.singUp(email, password, confirmPassword);

      try {
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: authService.encryptPassword(password),
        );

        expect(userCredential.user?.email, email);
      } catch (e) {
        fail('Sign Up failed: $e');
      }
    });

}