import 'package:my_smartstore/models/page_item_model.dart';

abstract class PageItemsState {}

class PageItemsInitial extends PageItemsState{}
class PageItemsLoading extends PageItemsState{}
class PageItemsLoaded extends PageItemsState{
  PageItemModel pageItemModel;

  PageItemsLoaded(this.pageItemModel);
}
class PageItemsFailed extends PageItemsState{
  String message;

  PageItemsFailed(this.message);
}

