import 'package:flutter/material.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';
import 'package:peliculas/src/search/search_delegate.dart';
import 'package:peliculas/src/widgets/card_swiper_widget.dart';
import 'package:peliculas/src/widgets/movie_horizontal.dart';
//import 'package:flutter_swiper/flutter_swiper.dart';

 
class HomePage extends StatelessWidget {


  final peliculasProvider = new PeliculasProvider();
 

  @override
  Widget build(BuildContext context) {

    peliculasProvider.getPopulares();

    return Scaffold(
        appBar: AppBar(
          title: Text('Películas en CINE'),
          backgroundColor: Colors.indigoAccent,
          actions: <Widget>[
           IconButton(
             icon: Icon(Icons.search), 
             onPressed: (){
               showSearch(
                 context: context, 
                 delegate: DataSearch(),
                 //query: 'Hola'
               );
             },
            )
         ],
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _swiperWidget(),
              _footer(context)
            ],
          ),
        )
      );
    
  }

 Widget _swiperWidget() {

   return FutureBuilder(
     
     future: peliculasProvider.getEnCines(),
     builder: (BuildContext context, AsyncSnapshot<List> snapshot){

       if (snapshot.hasData){
          return CardSwiper( peliculas: snapshot.data );
       } else {
         return Container(
           height: 600.0,
           child: Center(
             child: CircularProgressIndicator()
          )
         );
       }
     
     },
    );
  }

  Widget _footer(BuildContext context) {

    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 20.00),
            child: 
            Text('POPULARES', style: 
            Theme.of(context).textTheme.subhead)
            ),
          SizedBox(height: 10.00,),

          StreamBuilder(
            stream: peliculasProvider.popularesStream,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot){
              
            if (snapshot.hasData){
              return MovieHorizontal (
                peliculas: snapshot.data,
                siguientePagina: peliculasProvider.getPopulares,
                );
            } else {
              return Center(child: CircularProgressIndicator());
            }
            
            }
            ),
        ],
      ),
    );

  }
}