// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$restaurantHash() => r'2bc4fbe70f4e8a49aca660100b51d8f2d5754dfe';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [restaurant].
@ProviderFor(restaurant)
const restaurantProvider = RestaurantFamily();

/// See also [restaurant].
class RestaurantFamily extends Family<AsyncValue<Restaurant?>> {
  /// See also [restaurant].
  const RestaurantFamily();

  /// See also [restaurant].
  RestaurantProvider call(
    String uid,
  ) {
    return RestaurantProvider(
      uid,
    );
  }

  @override
  RestaurantProvider getProviderOverride(
    covariant RestaurantProvider provider,
  ) {
    return call(
      provider.uid,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'restaurantProvider';
}

/// See also [restaurant].
class RestaurantProvider extends AutoDisposeFutureProvider<Restaurant?> {
  /// See also [restaurant].
  RestaurantProvider(
    String uid,
  ) : this._internal(
          (ref) => restaurant(
            ref as RestaurantRef,
            uid,
          ),
          from: restaurantProvider,
          name: r'restaurantProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$restaurantHash,
          dependencies: RestaurantFamily._dependencies,
          allTransitiveDependencies:
              RestaurantFamily._allTransitiveDependencies,
          uid: uid,
        );

  RestaurantProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.uid,
  }) : super.internal();

  final String uid;

  @override
  Override overrideWith(
    FutureOr<Restaurant?> Function(RestaurantRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RestaurantProvider._internal(
        (ref) => create(ref as RestaurantRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        uid: uid,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Restaurant?> createElement() {
    return _RestaurantProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RestaurantProvider && other.uid == uid;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, uid.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RestaurantRef on AutoDisposeFutureProviderRef<Restaurant?> {
  /// The parameter `uid` of this provider.
  String get uid;
}

class _RestaurantProviderElement
    extends AutoDisposeFutureProviderElement<Restaurant?> with RestaurantRef {
  _RestaurantProviderElement(super.provider);

  @override
  String get uid => (origin as RestaurantProvider).uid;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
