import 'package:flutter/material.dart';
class HourlyForecastItem extends StatelessWidget {
  final String time;
  final String temp;
  final IconData icon;
  const HourlyForecastItem({super.key, required this.time, required this.temp, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
                      elevation: 0,
                      child: Container(
                        width: 100,
                        padding:const  EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12)
                        ),
                        child:  Column(
                          
                          children: [
                            Text(time,style:const  TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow:TextOverflow.ellipsis),
                            const SizedBox(height: 4),
                            Icon(icon,size: 32,),
                            const  SizedBox(height: 4),
                             Text(temp,
                              style: const  TextStyle(
                                fontSize: 16,
                                
                                ),
                                ),
                      
                      
                          ],
                        ),
                      ),
                    );
  }
}
