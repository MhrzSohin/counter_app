import 'package:counter_app/bloc/post_api_bloc/api_bloc.dart';
import 'package:counter_app/bloc/post_api_bloc/api_events.dart';
import 'package:counter_app/bloc/post_api_bloc/api_state.dart';
import 'package:counter_app/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DataFetching extends StatefulWidget {
  const DataFetching({super.key});

  @override
  State<DataFetching> createState() => _DataFetchingState();
}

class _DataFetchingState extends State<DataFetching> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ApiBloc>(context).add(PostFetchedEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Data API"),
      ),
      body: BlocConsumer<ApiBloc, ApiState>(
        listener: (context, state) {
          if (state.postStatus == PostStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("DataFetched Successfully"),
                backgroundColor: Colors.lightGreen));
          }
        },
        builder: (context, state) {
          return BlocBuilder<ApiBloc, ApiState>(
            builder: (context, state) {
              switch (state.postStatus) {
                case PostStatus.loading:
                  return const Center(child: CircularProgressIndicator());
                case PostStatus.failure:
                  return Center(child: Text(state.message.toString()));
                case PostStatus.success:
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        TextFormField(
                          onChanged: (value) {
                            BlocProvider.of<ApiBloc>(context)
                                .add(APIDataFilterEvent(value));
                          },
                          decoration: InputDecoration(
                            hintText: "Enter the text",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        Expanded(
                          child: state.searchMessage.isNotEmpty
                              ? Center(
                                  child: Text(state.searchMessage.toString()))
                              : ListView.builder(
                                  itemCount: state.tempPostList.isEmpty
                                      ? state.postlist.length
                                      : state.tempPostList.length,
                                  itemBuilder: (context, index) {
                                    if (state.tempPostList.isNotEmpty) {
                                      final item = state.tempPostList[index];
                                      return Card(
                                        child: ListTile(
                                          title: Text(item.email.toString()),
                                          subtitle: Text(item.body.toString()),
                                        ),
                                      );
                                    } else {
                                      final item = state.postlist[index];
                                      return Card(
                                        child: ListTile(
                                          title: Text(item.email.toString()),
                                          subtitle: Text(item.body.toString()),
                                        ),
                                      );
                                    }
                                  }),
                        ),
                      ],
                    ),
                  );
              }
            },
          );
        },
      ),
    );
  }
}
