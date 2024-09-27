// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$transactionServiceHash() =>
    r'07dc88308ae4ab8983b0032701e69723ef05b16b';

/// See also [TransactionService].
@ProviderFor(TransactionService)
final transactionServiceProvider = AutoDisposeAsyncNotifierProvider<
    TransactionService, List<Transaction>>.internal(
  TransactionService.new,
  name: r'transactionServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$transactionServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TransactionService = AutoDisposeAsyncNotifier<List<Transaction>>;
String _$budgetServiceHash() => r'19e5b3767e7d096f92b263af70a21800898627a6';

/// See also [BudgetService].
@ProviderFor(BudgetService)
final budgetServiceProvider =
    AutoDisposeAsyncNotifierProvider<BudgetService, List<Budget>>.internal(
  BudgetService.new,
  name: r'budgetServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$budgetServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$BudgetService = AutoDisposeAsyncNotifier<List<Budget>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
