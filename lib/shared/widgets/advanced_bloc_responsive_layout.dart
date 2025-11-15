import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'responsive_builder.dart';

/// Advanced BLoC responsive layout with multiple listeners
class AdvancedBlocResponsiveLayout<T extends BlocBase<S>, S>
    extends StatelessWidget {
  final Widget Function(
      BuildContext context, T bloc, S state, DeviceType deviceType) builder;
  final List<BlocListenerCondition<T, S>> listeners;
  final T? bloc;

  const AdvancedBlocResponsiveLayout({
    Key? key,
    required this.builder,
    this.listeners = const [],
    this.bloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<T>.value(
      value: bloc ?? context.read<T>(),
      child: _buildWithListeners(context),
    );
  }

  Widget _buildWithListeners(BuildContext context) {
    if (listeners.isEmpty) {
      return _buildBuilder(context);
    }

    Widget widget = _buildBuilder(context);

    // Wrap with listeners in reverse order
    for (final listener in listeners.reversed) {
      widget = BlocListener<T, S>(
        listener: listener.listener,
        listenWhen: listener.listenWhen,
        child: widget,
      );
    }

    return widget;
  }

  Widget _buildBuilder(BuildContext context) {
    return BlocBuilder<T, S>(
      builder: (context, state) {
        return ResponsiveBuilder(
          builder: (context, deviceType) {
            final bloc = context.read<T>();
            return builder(context, bloc, state, deviceType);
          },
        );
      },
    );
  }
}

/// Helper class for listener conditions
class BlocListenerCondition<T extends BlocBase<S>, S> {
  final void Function(BuildContext context, S state) listener;
  final bool Function(S previous, S current)? listenWhen;

  const BlocListenerCondition({
    required this.listener,
    this.listenWhen,
  });
}
