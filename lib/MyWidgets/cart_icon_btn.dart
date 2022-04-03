import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartIconBtn extends StatelessWidget {
  var onPressed;

  CartIconBtn({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCountCubit,int>(
      builder: (context,state) {
        return InkWell(
          onTap: onPressed,
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
               Padding(
                 padding: const EdgeInsets.all(16.0),
                 child: Icon(Icons.shopping_cart),
               ),
              if(state >0)
              Positioned(
                child: Chip(
                  visualDensity: VisualDensity.compact,
                  labelPadding: EdgeInsets.zero,
                  backgroundColor: Colors.orange,
                  label: Text(
                    state.toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                top: 0,
                right: 0,
              ),
            ],
          ),
        );
      }
    );
  }
}

class CartCountCubit extends Cubit<int>{
  CartCountCubit(int initialState) : super(initialState);

  void setCount(int count){
    emit(count);
  }
}
