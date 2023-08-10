/// An abstraction over a resource provided by the mobile backend. Only
/// two states are possible: success or failure.
/// ResourceSuccess is a wrapper over the data returned by the backend.
/// ResourceFailure is a wrapper over the exception thrown by the mobile backend.
abstract class PeppermintResource<T1> {
  /// helper method to process a resource.
  /// [onSuccess] called when the Resource is a ResourceSuccess.
  /// Exposes the wrapped data.
  /// [onFailure] called when the Resource is a ResourceFailure.
  /// Exposes the wrapped [Error].
  R when<R>(
      {required R Function(T1 data) onSuccess,
      required R Function(String errorMessage) onFailure}) {
    if (this is PepperSourceSuccess<T1>) {
      return onSuccess(getDataOrThrow());
    } else if (this is PepperSourceFailure<T1>) {
      return onFailure(getErrorOrThrow());
    } else {
      throw ArgumentError('Invalid sealed class instance');
    }
  }

  /// Quick helper method to check if Resource has data.
  bool get hasData => getDataOrNull() != null;

  /// Returns data.
  /// Use [getDataOrNull] if you're unsure if it's a success.
  /// Use [getDataOrThrow] if you need direct throw exception.
  /// When you call this, make sure you've secured it with [hasData]
  T1 get data => (this as PepperSourceSuccess<T1>).data;

  /// helper method to get the data from a Resource.
  /// returns null if the Resource is a ResourceFailure.
  T1? getDataOrNull() {
    if (this is PepperSourceSuccess<T1>) {
      return (this as PepperSourceSuccess<T1>).data;
    }
    return null;
  }

  /// helper method to get the data from a Resource.
  /// throws [ArgumentError] if the Resource is a ResourceFailure.
  T1 getDataOrThrow() {
    if (this is PepperSourceSuccess<T1>) {
      return (this as PepperSourceSuccess<T1>).data;
    }
    throw ArgumentError(
        'getDataOrThrow // The Resource is not a ResourceSuccess');
  }

  /// Quick helper method to check if Resource has error.
  bool get hasError => getErrorOrNull() != null;

  /// Returns data.
  /// Use [getErrorOrNull] if you're unsure if it's a success.
  /// Use [getErrorOrThrow] if you need direct throw exception.
  /// When you call this, make sure you've secured it with [hasError]
  String get error => (this as PepperSourceFailure<T1>).error;

  /// helper method to get an exception from a Resource.
  /// returns null if the Resource is a ResourceSuccess.
  String? getErrorOrNull() {
    if (this is PepperSourceFailure<T1>) {
      return (this as PepperSourceFailure<T1>).error;
    }
    return null;
  }

  /// helper method to get an exception from a Resource.
  /// throws [ArgumentError] if the Resource is a ResourceSuccess.
  String getErrorOrThrow() {
    if (this is PepperSourceFailure<T1>) {
      return (this as PepperSourceFailure<T1>).error;
    }
    throw ArgumentError(
        'getExceptionOrThrow() // The Resource is not a ResourceFailure');
  }

  /// casts a ResourceFailure to another type to overcome Dart type inference
  /// limitations.
  PeppermintResource<OtherType> castFailure<OtherType>() {
    if (this is PepperSourceFailure<T1>) {
      return getErrorOrThrow().toResourceFailure<OtherType>();
    }
    throw "Cannot cast ResourceSuccess to another type";
  }
}

/// A wrapper over the data returned by the mobile backend. Signifies a successful
/// scenario.
class PepperSourceSuccess<T1> extends PeppermintResource<T1> {
  @override
  final T1 data;

  PepperSourceSuccess(this.data);
}

/// A wrapper over an error thrown by the mobile backend. Signifies that something
/// went wrong when executing the operation.
class PepperSourceFailure<T1> extends PeppermintResource<T1> {
  @override
  final String error;

  PepperSourceFailure(this.error);
}

extension ResourceExtensions<T1> on PeppermintResource<T1> {}

extension ResourceDataExtensions<T1> on T1 {
  /// helper method to convert data to a ResourceSuccess.
  PeppermintResource<T1> toResourceSuccess() {
    if (this is Error) {
      throw "Cannot convert Error to ResourceSuccess; convert to ResourceFailure instead";
    }

    if (this is Exception) {
      throw "Cannot convert Exception to ResourceSuccess; convert to ResourceFailure instead";
    }

    return PepperSourceSuccess(this);
  }
}

extension ResourceErrorExtensions on String {
  /// helper method to convert an exception to a ResourceFailure.
  PeppermintResource<T1> toResourceFailure<T1>() {
    return PepperSourceFailure(this);
  }
}
