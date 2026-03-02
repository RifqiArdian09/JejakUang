import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/wallet.dart';
import '../services/hive_service.dart';

final walletsProvider = StateNotifierProvider<WalletNotifier, List<Wallet>>((
  ref,
) {
  final box = Hive.box<Wallet>(HiveService.walletsBox);
  return WalletNotifier(box);
});

class WalletNotifier extends StateNotifier<List<Wallet>> {
  final Box<Wallet> _box;

  WalletNotifier(this._box) : super([]) {
    _load();
  }

  void _load() {
    state = _box.values.toList();
  }

  Future<void> addWallet(Wallet wallet) async {
    await _box.put(wallet.id, wallet);
    _load();
  }

  Future<void> updateWallet(Wallet wallet) async {
    await _box.put(wallet.id, wallet);
    _load();
  }

  Future<void> deleteWallet(String id) async {
    await _box.delete(id);
    _load();
  }
}
