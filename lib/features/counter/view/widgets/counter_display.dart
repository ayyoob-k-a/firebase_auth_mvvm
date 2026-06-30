import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../view_model/counter_bloc.dart';

/// Displays the current count.
///
/// • Count number  → DM Serif Display (heading)
/// • Label text    → Outfit / subtitle grey (#767676)
class CounterDisplay extends StatelessWidget {
  const CounterDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CounterBloc, CounterState>(
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Subtitle — Outfit, #767676
            Text(
              'You have pushed the button this many times:',
              textAlign: TextAlign.center,
              style: AppTextStyles.subtitleLarge,
            ),
            const SizedBox(height: 16),
            // Heading — DM Serif Display, primary colour
            Text(
              '${state.model.count}',
              style: AppTextStyles.displayLarge.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        );
      },
    );
  }
}
