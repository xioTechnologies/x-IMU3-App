import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MultiValueListenableBuilder<A, B> extends StatelessWidget {
  final ValueListenable<A> listenableA;
  final ValueListenable<B> listenableB;
  final Widget Function(BuildContext, A, B, Widget?) builder;
  final Widget? child;

  const MultiValueListenableBuilder({
    Key? key,
    required this.listenableA,
    required this.listenableB,
    required this.builder,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<A>(
      valueListenable: listenableA,
      builder: (context, valueA, _) {
        return ValueListenableBuilder<B>(
          valueListenable: listenableB,
          builder: (context, valueB, _) {
            return builder(context, valueA, valueB, child);
          },
        );
      },
    );
  }
}
