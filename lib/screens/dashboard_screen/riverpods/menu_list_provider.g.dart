// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$menuListHash() => r'9df4d621a88cec26157040b5d51035a9e543660b';

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

/// See also [menuList].
@ProviderFor(menuList)
const menuListProvider = MenuListFamily();

/// See also [menuList].
class MenuListFamily extends Family<AsyncValue<List<Menu>>> {
  /// See also [menuList].
  const MenuListFamily();

  /// See also [menuList].
  MenuListProvider call(
    String uid,
    String? category,
  ) {
    return MenuListProvider(
      uid,
      category,
    );
  }

  @override
  MenuListProvider getProviderOverride(
    covariant MenuListProvider provider,
  ) {
    return call(
      provider.uid,
      provider.category,
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
  String? get name => r'menuListProvider';
}

/// See also [menuList].
class MenuListProvider extends AutoDisposeFutureProvider<List<Menu>> {
  /// See also [menuList].
  MenuListProvider(
    String uid,
    String? category,
  ) : this._internal(
          (ref) => menuList(
            ref as MenuListRef,
            uid,
            category,
          ),
          from: menuListProvider,
          name: r'menuListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$menuListHash,
          dependencies: MenuListFamily._dependencies,
          allTransitiveDependencies: MenuListFamily._allTransitiveDependencies,
          uid: uid,
          category: category,
        );

  MenuListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.uid,
    required this.category,
  }) : super.internal();

  final String uid;
  final String? category;

  @override
  Override overrideWith(
    FutureOr<List<Menu>> Function(MenuListRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MenuListProvider._internal(
        (ref) => create(ref as MenuListRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        uid: uid,
        category: category,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Menu>> createElement() {
    return _MenuListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MenuListProvider &&
        other.uid == uid &&
        other.category == category;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, uid.hashCode);
    hash = _SystemHash.combine(hash, category.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin MenuListRef on AutoDisposeFutureProviderRef<List<Menu>> {
  /// The parameter `uid` of this provider.
  String get uid;

  /// The parameter `category` of this provider.
  String? get category;
}

class _MenuListProviderElement
    extends AutoDisposeFutureProviderElement<List<Menu>> with MenuListRef {
  _MenuListProviderElement(super.provider);

  @override
  String get uid => (origin as MenuListProvider).uid;
  @override
  String? get category => (origin as MenuListProvider).category;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
