import 'package:ditonton/presentation/bloc/tv/airing_today/airing_today_bloc.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AiringTodayTvPage extends StatefulWidget {
  static const routeName = '/airing-today-tv';

  const AiringTodayTvPage({super.key});

  @override
  State<AiringTodayTvPage> createState() => _AiringTodayTvPageState();
}

class _AiringTodayTvPageState extends State<AiringTodayTvPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<AiringTodayBloc>().add(FetchAiringTodayTv());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Airing Today Tv'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<AiringTodayBloc, AiringTodayState>(
              builder: (context, state) {
                if (state is AiringTodayLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is AiringTodayHasData) {
                  return Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        final tv = state.result[index];
                        return TvCardList(tv);
                      },
                      itemCount: state.result.length,
                    ),
                  );
                } else if (state is AiringTodayError) {
                  return Expanded(
                    child: Center(
                      key: const Key('error_message'),
                      child: Text(state.message),
                    ),
                  );
                } else {
                  return Expanded(
                    child: Container(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
