// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_details_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$restaurantDetailsHash() => r'6f325462dfe6b28f23e26cb302129757c57ec889';

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

/// See also [restaurantDetails].
@ProviderFor(restaurantDetails)
const restaurantDetailsProvider = RestaurantDetailsFamily();

/// See also [restaurantDetails].
class RestaurantDetailsFamily extends Family<AsyncValue<Restaurant?>> {
  /// See also [restaurantDetails].
  const RestaurantDetailsFamily();

  /// See also [restaurantDetails].
  RestaurantDetailsProvider call(
    String restaurantId,
  ) {
    return RestaurantDetailsProvider(
      restaurantId,
    );
  }

  @override
  RestaurantDetailsProvider getProviderOverride(
    covariant RestaurantDetailsProvider provider,
  ) {
    return call(
      provider.restaurantId,
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
  String? get name => r'restaurantDetailsProvider';
}

/// See also [restaurantDetails].
class RestaurantDetailsProvider extends AutoDisposeFutureProvider<Restaurant?> {
  /// See also [restaurantDetails].
  RestaurantDetailsProvider(
    String restaurantId,
  ) : this._internal(
          (ref) => restaurantDetails(
            ref as RestaurantDetailsRef,
            restaurantId,
          ),
          from: restaurantDetailsProvider,
          name: r'restaurantDetailsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$restaurantDetailsHash,
          dependencies: RestaurantDetailsFamily._dependencies,
          allTransitiveDependencies:
              RestaurantDetailsFamily._allTransitiveDependencies,
          restaurantId: restaurantId,
        );

  RestaurantDetailsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.restaurantId,
  }) : super.internal();

  final String restaurantId;

  @override
  Override overrideWith(
    FutureOr<Restaurant?> Function(RestaurantDetailsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RestaurantDetailsProvider._internal(
        (ref) => create(ref as RestaurantDetailsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        restaurantId: restaurantId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Restaurant?> createElement() {
    return _RestaurantDetailsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RestaurantDetailsProvider &&
        other.restaurantId == restaurantId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, restaurantId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin RestaurantDetailsRef on AutoDisposeFutureProviderRef<Restaurant?> {
  /// The parameter `restaurantId` of this provider.
  String get restaurantId;
}

class _RestaurantDetailsProviderElement
    extends AutoDisposeFutureProviderElement<Restaurant?>
    with RestaurantDetailsRef {
  _RestaurantDetailsProviderElement(super.provider);

  @override
  String get restaurantId => (origin as RestaurantDetailsProvider).restaurantId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
