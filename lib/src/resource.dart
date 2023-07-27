/// An abstraction over a resource provided by the mobile backend. Only
/// two states are possible: success or failure.
/// ResourceSuccess is a wrapper over the data returned by the backend.
/// ResourceFailure is a wrapper over the exception thrown by the mobile backend.
abstract class Resource<T1> {
  /// helper method to process a resource.
  /// [onSuccess] called when the Resource is a ResourceSuccess.
  /// Exposes the wrapped data.
  /// [onFailure] called when the Resource is a ResourceFailure.
  /// Exposes the wrapped [Error].
  R when<R>(
      {required R Function(T1) onSuccess,
      required R Function(String) onFailure}) {
    if (this is ResourceSuccess<T1>) {
      return onSuccess(getDataOrThrow());
    } else if (this is ResourceFailure<T1>) {
      return onFailure(getErrorOrThrow());
    } else {
      throw ArgumentError('Invalid sealed class instance');
    }
  }

  /// helper method to get the data from a Resource.
  /// returns null if the Resource is a ResourceFailure.
  T1? getDataOrNull() {
    if (this is ResourceSuccess<T1>) {
      return (this as ResourceSuccess<T1>).data;
    }
    return null;
  }

  /// helper method to get the data from a Resource.
  /// throws [ArgumentError] if the Resource is a ResourceFailure.
  T1 getDataOrThrow() {
    if (this is ResourceSuccess<T1>) {
      return (this as ResourceSuccess<T1>).data;
    }
    throw ArgumentError(
        'getDataOrThrow // The Resource is not a ResourceSuccess');
  }

  /// helper method to get an exception from a Resource.
  /// returns null if the Resource is a ResourceSuccess.
  String? getErrorOrNull() {
    if (this is ResourceFailure<T1>) {
      return (this as ResourceFailure<T1>).error;
    }
    return null;
  }

  /// helper method to get an exception from a Resource.
  /// throws [ArgumentError] if the Resource is a ResourceSuccess.
  String getErrorOrThrow() {
    if (this is ResourceFailure<T1>) {
      return (this as ResourceFailure<T1>).error;
    }
    throw ArgumentError(
        'getExceptionOrThrow() // The Resource is not a ResourceFailure');
  }

  /// casts a ResourceFailure to another type to overcome Dart type inference
  /// limitations.
  Resource<OtherType> castFailure<OtherType>() {
    if (this is ResourceFailure<T1>) {
      return getErrorOrThrow().toResourceFailure<OtherType>();
    }
    throw "Cannot cast ResourceSuccess to another type";
  }
}

/// A wrapper over the data returned by the mobile backend. Signifies a successful
/// scenario.
class ResourceSuccess<T1> extends Resource<T1> {
  final T1 data;

  ResourceSuccess(this.data);
}

/// A wrapper over an error thrown by the mobile backend. Signifies that something
/// went wrong when executing the operation.
class ResourceFailure<T1> extends Resource<T1> {
  final String error;

  ResourceFailure(this.error);
}

extension ResourceExtensions<T1> on Resource<T1> {}

extension ResourceDataExtensions<T1> on T1 {
  /// helper method to convert data to a ResourceSuccess.
  Resource<T1> toResourceSuccess() {
    if (this is Error) {
      throw "Cannot convert Error to ResourceSuccess; convert to ResourceFailure instead";
    }

    if (this is Exception) {
      throw "Cannot convert Exception to ResourceSuccess; convert to ResourceFailure instead";
    }

    return ResourceSuccess(this);
  }
}

extension ResourceErrorExtensions on String {
  /// helper method to convert an exception to a ResourceFailure.
  Resource<T1> toResourceFailure<T1>() {
    return ResourceFailure(this);
  }
}
