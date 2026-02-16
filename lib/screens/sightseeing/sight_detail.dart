import 'package:flutter/material.dart';
import 'package:travel_suite/model/sightseeing_model.dart';
import 'package:travel_suite/model/sightseeing_detail_model.dart';
import 'package:travel_suite/services/api_exceptions.dart';
import 'package:travel_suite/services/api_service.dart';
import 'package:travel_suite/screens/booking/traveler_details.dart';
import 'package:travel_suite/utils/loader_overlay.dart';

class SightDetail extends StatefulWidget {
  final SightseeingModel sightseeing;
  const SightDetail({super.key, required this.sightseeing});


  @override
  State<SightDetail> createState() => _SightDetailState();
}

class _SightDetailState extends State<SightDetail> {
  final NetworkManager _apiService = NetworkManager();
  SightseeingDetailResponse? sightseeingDetailResponse;  
  bool isFavorite = false; // Example state

  @override
  void initState() {
    super.initState();
    fetchSightDetails();
  }
  void fetchSightDetails() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      LoaderOverlay.show(context);
    });
    // setState(() {
    //   
    // });
    // 
    try {            
        final response = await _apiService.getRequest(
          '/sightseeing/slug/${widget.sightseeing.slug}/',
          queryParameters: {'supplier_id': widget.sightseeing.supplierId,'date':'${widget.sightseeing.year}-${widget.sightseeing.month}-${widget.sightseeing.day}'},
        );                
        LoaderOverlay.hide();    
        setState(() {
          sightseeingDetailResponse = SightseeingDetailResponse.fromJson(response.data);                
       });
      //  print('name');
      //  print(sightseeingDetailResponse!.sightseeingDetail.name);
        // print('detail----${sightseeingDetailResponse!.sightseeingDetail.name}'); 
        // Navigate to home page or save token
    } on ApiException catch (e) {                               
            LoaderOverlay.hide();
            showMessage(e.message);
    } catch (_) {
      LoaderOverlay.hide();
      showMessage("Unexpected error occurred");
    }
  }

  void showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  // Widget showLoader(){
  //   return Center(
  //       child: LoaderOverlay.show(context),
  //   );
  // }

  @override
  Widget build(BuildContext context) {    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sightseeing Details'),        
      ),
      body: 
      sightseeingDetailResponse == null
          ? Center()
          : Padding(
              padding: EdgeInsets.all(16),
      child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image.network(
            //   'https://example.com/sight.jpg',
            //   width: double.infinity,
            //   height: 220,
            //   fit: BoxFit.cover,
            // ),
            sightseeingDetailResponse == null
            ? Center()
            : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sightseeingDetailResponse!.sightseeingDetail.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    sightseeingDetailResponse!.sightseeingDetail.city,
                    style: const TextStyle(
                      fontSize: 16,                      
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 120,
                    width: 150,
                    decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    border: Border.all(
                      color: Colors.green.shade300
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                      ),
                    ],
                  ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Starting from',
                          style: TextStyle(color: Colors.grey, fontSize: 15),
                        ),
                        Text(
                          sightseeingDetailResponse!.sightseeingDetail.finalRate.toString(),
                          style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold,fontSize: 20),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                        child:ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => TravelerDetails(sightSeeingId:  sightseeingDetailResponse!.sightseeingDetail.id.toString())),
                            );
                            //  Navigator.push(
                            //           context,
                            //           MaterialPageRoute(builder: (_) => TravelerDetails()),
                            //         );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green, // button color
                            foregroundColor: Colors.white, // text/icon color
                            // padding: const EdgeInsets.symmetric(
                            //   horizontal: 34, 
                            //   vertical: 12
                            //   ),                            
                          ),
                          child: const Text(
                            'Book Now',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  
                ],
              ),
            ),
          ],
        ),
          )
      );    
  }
}