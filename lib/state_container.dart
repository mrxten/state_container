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
  final Widget child;
  final int order;
  final Color backgroundColor;

  StateDefinition({
    @required this.state,
    this.builder,
    this.child,
    this.order = 0,
    this.backgroundColor = Colors.transparent,
  })  : assert(state != null),
        assert(builder != null || child != null),
        assert(order != null);
}

class StateContainer extends StatefulWidget {
  final dynamic state;
  final List<StateDefinition> states;
  final Duration animationDuration;
  final StateAnimationType animationType;

  const StateContainer({
    @required this.state,
    @required this.states,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationType = StateAnimationType.FADE,
    Key key,
  })  : assert(state != null),
        assert(states != null),
        assert(animationDuration != null),
        assert(animationType != null),
        super(key: key);

  @override
  _StateContainerState createState() => _StateContainerState();
}

class _StateContainerState extends State<StateContainer> {
  StateDefinition _lastState;

  @override
  Widget build(BuildContext context) {
    final state = widget.states
        .firstWhere((e) => e.state == widget.state, orElse: () => null);
    final reverse = (state?.order ?? 0) < (_lastState?.order ?? 0);
    _lastState = state;

    final index = widget.states.indexOf(_lastState);
    final child = Container(
      color: state.backgroundColor,
      child: _lastState?.builder == null
          ? _lastState?.child
          : _lastState?.builder(context),
      key: ValueKey(index),
    );

    if (widget.animationType == StateAnimationType.FADE) {
      return AnimatedSwitcher(
        child: child,
        transitionBuilder: (child, animation) => FadeTransition(
          child: child,
          opacity: animation,
        ),
        duration: widget.animationDuration,
      );
    }
    return PageTransitionSwitcher(
      duration: widget.animationDuration,
      reverse: reverse,
      transitionBuilder: (child, animation, secondaryAnimation) {
        return SharedAxisTransition(
          child: child,
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          transitionType: _getTransitionType(),
        );
      },
      child: child,
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
