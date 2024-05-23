import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/Additoinal_Info_Item.dart';
import 'package:weather_app/hourly_forecast_item.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/secrets.dart';
class Weatherscreen extends StatefulWidget {
  const Weatherscreen({super.key});

  @override
  State<Weatherscreen> createState() => _WeatherscreenState();
}

class _WeatherscreenState extends State<Weatherscreen> {
  late Future<Map<String,dynamic>> weather;
  Future<Map<String,dynamic>> getCurrentWeather() async{
    try{
      String cityName='London';
    final res = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/forecast?q=$cityName,uk&APPID=$OpenWeatherApiKey'),
    );
   final data = jsonDecode(res.body);
   if(int.parse(data['cod'])!=200){
    throw 'An unexpected error occured';
   }
 
  
   return data;
    }
    catch(e)
    {
      throw e.toString();
    }

    
    
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title:const Text('Know the Weather',style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
        ) ,
        centerTitle: true,
        actions:  [
          IconButton(
            onPressed: () {
              setState(() {
                
              });
            }, icon: const Icon(Icons.refresh))

        ],
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder:(context,snapshot) {
         
          if(snapshot.connectionState== ConnectionState.waiting)
          {
            return const  Center(child:  CircularProgressIndicator.adaptive());
          }
          if (snapshot.hasError){
            return Center(child: Text(snapshot.error.toString()));
          }
          final data =snapshot.data!;
          final currentTemp=  data['list'][0]['main']['temp'];
          final currentSky=data['list'][0]['weather'][0]['main'];
          final currentWeatherData =data['list'][0];
          final currentPressure= currentWeatherData['main']['pressure'];
          final currentWindSpeed=currentWeatherData['wind']['speed'];
          final currentHumidity = currentWeatherData['main']['humidity'];
          
          return Padding(
          padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10,sigmaY: 10),
                      
                      child: Padding(
                        padding: const  EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text('$currentTemp k',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold
                              ),
                              ),
                              Icon(
                                currentSky=='cloud' || currentSky=='Rain' ? Icons.cloud : Icons.sunny
                                 ,size: 64),
                              Text(currentSky,style: const  TextStyle(
                                fontSize: 16,                           
                              ),)                                
                          ],
                        ),
                      ),
                    ),
                  ) ,           
                ),
              ),
              const SizedBox(height: 20),
              const Text('Weather Forecast',style: 
              TextStyle(
                fontSize: 24,fontWeight: FontWeight.bold),),
              const SizedBox(height: 8,),

          
              SizedBox(
                height: 120,

                child: ListView.builder(
                  
                  itemCount: 5,
                  scrollDirection: Axis.horizontal,
                  itemBuilder:(context,index){
                    final hourlyforecastitem=data['list'][index+1];
                    final hourlySky=data['list'][index+1]['weather'][0]['main'];
                    final time =DateTime.parse(hourlyforecastitem['dt_txt']);
                    return HourlyForecastItem(time:DateFormat.Hm().format(time), 
                    temp: hourlyforecastitem['main']['temp'].toString(),
                     icon:  hourlySky =='cloud' ||
                           hourlySky =='Rain'?
                          Icons.cloud : Icons.sunny,
                );
              
              
                  },),
              ),

              const SizedBox(height: 16,) ,
              const Text('Additional Information',style: 
              TextStyle(
                fontSize: 24,fontWeight: FontWeight.bold),),
                const SizedBox(height: 16,) ,
              Row(
                mainAxisAlignment:MainAxisAlignment.spaceAround,
                children: [
                  AdditonalInfoItem(
                   icon: Icons.water_drop,
                   label:"Humidity",
                   value: currentHumidity.toString(),
                  ),
                  AdditonalInfoItem(
                    icon: Icons.air,
                    label: 'Wind Speed',
                    value: currentWindSpeed.toString(),
                  ),
                  AdditonalInfoItem(
                    icon: Icons.beach_access,
                    label: 'Pressure',
                    value: currentPressure.toString(),
                  )
                  ],
              )
             ],
                
            ),
          );
        },
      ),
      );
  }
}

