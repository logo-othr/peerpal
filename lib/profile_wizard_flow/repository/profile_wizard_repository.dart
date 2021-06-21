import 'package:peerpal/profile_wizard_flow/repository/data/ages.dart';

class ProfileWizardRepository {

  Future<List<int>> getAges() async {
    await _wait();
    return ages;
  }

  Future<String> getName() async {
    await _wait();
    return "Example. Load from Database.";
  }

  Future<void> _wait() => Future.delayed(const Duration(milliseconds: 300));
}
