// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_categories_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$restaurantCategoriesHash() =>
    r'5f4d1c7a1d67b0dc37f98be66c9ca88668c42229';

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

/// See also [restaurantCategories].
@ProviderFor(restaurantCategories)
const restaurantCategoriesProvider = RestaurantCategoriesFamily();

/// See also [restaurantCategories].
class RestaurantCategoriesFamily
    extends Family<AsyncValue<List<MenuCategory>?>> {
  /// See also [restaurantCategories].
  const RestaurantCategoriesFamily();

  /// See also [restaurantCategories].
  RestaurantCategoriesProvider call(
    String restaurantId,
  ) {
    return RestaurantCategoriesProvider(
      restaurantId,
    );
  }

  @override
  RestaurantCategoriesProvider getProviderOverride(
    covariant RestaurantCategoriesProvider provider,
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
  String? get name => r'restaurantCategoriesProvider';
}

/// See also [restaurantCategories].
class RestaurantCategoriesProvider
    extends AutoDisposeFutureProvider<List<MenuCategory>?> {
  /// See also [restaurantCategories].
  RestaurantCategoriesProvider(
    String restaurantId,
  ) : this._internal(
          (ref) => restaurantCategories(
            ref as RestaurantCategoriesRef,
            restaurantId,
          ),
          from: restaurantCategoriesProvider,
          name: r'restaurantCategoriesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$restaurantCategoriesHash,
          dependencies: RestaurantCategoriesFamily._dependencies,
          allTransitiveDependencies:
              RestaurantCategoriesFamily._allTransitiveDependencies,
          restaurantId: restaurantId,
        );

  RestaurantCategoriesProvider._internal(
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
    FutureOr<List<MenuCategory>?> Function(RestaurantCategoriesRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RestaurantCategoriesProvider._internal(
        (ref) => create(ref as RestaurantCategoriesRef),
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
  AutoDisposeFutureProviderElement<List<MenuCategory>?> createElement() {
    return _RestaurantCategoriesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RestaurantCategoriesProvider &&
        other.restaurantId == restaurantId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, restaurantId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RestaurantCategoriesRef
    on AutoDisposeFutureProviderRef<List<MenuCategory>?> {
  /// The parameter `restaurantId` of this provider.
  String get restaurantId;
}

class _RestaurantCategoriesProviderElement
    extends AutoDisposeFutureProviderElement<List<MenuCategory>?>
    with RestaurantCategoriesRef {
  _RestaurantCategoriesProviderElement(super.provider);

  @override
  String get restaurantId =>
      (origin as RestaurantCategoriesProvider).restaurantId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
