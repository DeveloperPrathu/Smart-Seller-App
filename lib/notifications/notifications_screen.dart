import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants.dart';
import '../../../registration/authentication/auth_cubit.dart';
import '../models/notification_model.dart';
import '../product_details/product_details_cubit.dart';
import '../product_details/product_details_screen.dart';
import 'notifications_cubit.dart';
import 'notifications_state.dart';

class NotificationsScreen extends StatelessWidget {
  List<NotificationModel>? notifications = [];




  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationsCubit, NotificationsState>(
      listener: (context, state) {
        if (state is NotificationsFailed) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
            backgroundColor: Colors.red,
          ));

          if (state.message == UNAUTHENTICATED_USER) {
            context.read<AuthCubit>().removeToken();
          }
        }
      },
      builder: (context, state) {
        if(state is NotificationsInitial){
          BlocProvider.of<NotificationsCubit>(context).notifications();
        }
        if (state is NotificationsLoaded) {
          notifications!.clear();
          notifications!.addAll(state.notifications);
        }

        return Scaffold(
          appBar: AppBar(
            title: Text("Notifications"),
          ),
          body: ListView.builder(
            itemBuilder: (context, index) {
              if (index < notifications!.length) {
                NotificationModel notification = notifications![index];
                return ListTile(

                  leading: notification.image!=null? CachedNetworkImage(
                    imageUrl: DOMAIN_URL + notification.image!,
                    height: 90,
                    width: 90,
                    fit: BoxFit.contain,
                    errorWidget: (context, url, error) => Icon(Icons.warning),
                  ):null,
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(alignment:Alignment.centerRight,child: Text(notification.createdAt!,style: TextStyle(fontSize: 12,color: Colors.grey),)),
                      Text(notification.title!),
                    ],
                  ),
                  subtitle: Text(notification.body!),
                );
              } else {
                if (state is NotificationsLoaded && state.nextUrl != null) {
                  BlocProvider.of<NotificationsCubit>(context).loadMoreItems();
                }
                return Center(child: CircularProgressIndicator());
              }
            },
            itemCount: state is NotificationsLoading ||
                (state is NotificationsLoaded && state.nextUrl != null)
                ? notifications!.length + 1
                : notifications!.length,
          ),
        );
      },
    );
  }
}
