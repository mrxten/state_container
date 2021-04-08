library state_container;

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

enum StateAnimationType {
  FADE,
  AXIS_HORIZONTAL,
  AXIS_VERTICAL,
  AXIS_SCALED,
}

class StateDefinition {
  final dynamic state;
  final WidgetBuilder builder;
  final int order;
  final Color? backgroundColor;

  StateDefinition({
    required this.state,
    required this.builder,
    this.order = 0,
    this.backgroundColor = Colors.transparent,
  });
}

class StateContainer extends StatefulWidget {
  final dynamic state;
  final List<StateDefinition> stateDefinitions;
  final Duration animationDuration;
  final StateAnimationType animationType;
  final Color? transitionColor;

  const StateContainer({
    required this.state,
    required this.stateDefinitions,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationType = StateAnimationType.FADE,
    this.transitionColor = Colors.transparent,
    Key? key,
  })  : assert(state != null),
        super(key: key);

  @override
  _StateContainerState createState() => _StateContainerState();
}

class _StateContainerState extends State<StateContainer> {
  StateDefinition? _lastState;

  @override
  Widget build(BuildContext context) {
    final StateDefinition state = widget.stateDefinitions.firstWhere(
      (e) => e.state == widget.state,
      orElse: () => StateDefinition(
        state: null,
        builder: (context) => SizedBox.shrink(),
      ),
    );
    final reverse = state.order < (_lastState?.order ?? 0);
    _lastState = state;

    final index = widget.stateDefinitions.indexOf(_lastState!);
    final child = Container(
      color: _lastState!.backgroundColor,
      child: _lastState!.builder(context),
      key: ValueKey(index),
    );

    return PageTransitionSwitcher(
      duration: widget.animationDuration,
      reverse: reverse,
      child: child,
      transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
        if (widget.animationType == StateAnimationType.FADE) {
          return FadeTransition(
            opacity: Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(primaryAnimation),
            child: child,
          );
        }
        return SharedAxisTransition(
          child: child,
          animation: primaryAnimation,
          secondaryAnimation: secondaryAnimation,
          transitionType: _getTransitionType(),
          fillColor: widget.transitionColor,
        );
      },
    );
  }

  SharedAxisTransitionType _getTransitionType() {
    switch (widget.animationType) {
      case StateAnimationType.AXIS_HORIZONTAL:
        return SharedAxisTransitionType.horizontal;
      case StateAnimationType.AXIS_VERTICAL:
        return SharedAxisTransitionType.vertical;
      case StateAnimationType.AXIS_SCALED:
        return SharedAxisTransitionType.scaled;
      default:
        throw ArgumentError();
    }
  }
}
