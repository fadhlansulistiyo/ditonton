import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/tv/airing_today_tv_notifier.dart';

class AiringTodayTvPage extends StatefulWidget {
  static const ROUTE_NAME = '/airing-today-tv';

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
        context.read<AiringTodayTvNotifier>().fetchAiringTodayTv();
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
        child: Consumer<AiringTodayTvNotifier>(
          builder: (context, data, child) {
            if (data.state == RequestState.Loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (data.state == RequestState.Loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = data.tv[index];
                  return TvCardList(tv);
                },
                itemCount: data.tv.length,
              );
            } else {
              return Center(
                key: const Key('error_message'),
                child: Text(data.message),
              );
            }
          },
        ),
      ),
    );
  }
}
