// File: lib/shared/widgets/bloc_responsive_layout.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'responsive_builder.dart';

/// BLoC-compatible responsive layout widget with listener support
class BlocResponsiveLayout<T extends BlocBase<S>, S> extends StatelessWidget {
  final Widget Function(BuildContext context, T bloc, S state, DeviceType deviceType) builder;
  final void Function(BuildContext context, S state)? listener;
  final T? bloc;

  const BlocResponsiveLayout({
    Key? key,
    required this.builder,
    this.listener,
    this.bloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<T>.value(
      value: bloc ?? context.read<T>(),
      child: BlocListener<T, S>(
        listener: listener ?? (_, __) {},
        child: BlocBuilder<T, S>(
          builder: (context, state) {
            return ResponsiveBuilder(
              builder: (context, deviceType) {
                final bloc = context.read<T>();
                return builder(context, bloc, state, deviceType);
              },
            );
          },
        ),
      ),
    );
  }
}

/// Simplified version for common use cases
class BlocResponsiveLayoutListener<T extends BlocBase<S>, S> extends StatelessWidget {
  final Widget Function(BuildContext context, DeviceType deviceType) builder;
  final void Function(BuildContext context, S state) listener;
  final T? bloc;

  const BlocResponsiveLayoutListener({
    Key? key,
    required this.builder,
    required this.listener,
    this.bloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<T>.value(
      value: bloc ?? context.read<T>(),
      child: BlocListener<T, S>(
        listener: listener,
        child: BlocBuilder<T, S>(
          builder: (context, state) {
            return ResponsiveBuilder(
              builder: (context, deviceType) {
                return builder(context, deviceType);
              },
            );
          },
        ),
      ),
    );
  }
}
