import 'package:flutter/material.dart';
import 'package:travel_suite/model/traveler_details/traveler_api_response.dart';
import 'package:travel_suite/services/api_exceptions.dart';
import 'package:travel_suite/services/api_service.dart';
import 'package:travel_suite/screens/booking/ticket_success.dart';
import 'package:travel_suite/utils/loader_overlay.dart';
import 'package:travel_suite/widgets/custom_text_field.dart';

class TravelerDetails extends StatefulWidget {
  final String sightSeeingId; 
  const TravelerDetails({super.key, required this.sightSeeingId});  

  @override
  State<TravelerDetails> createState() => _TravelerDetailsState();
}

class _TravelerDetailsState extends State<TravelerDetails> {
  final NetworkManager _apiService = NetworkManager();
  TravelerApiResponse? apiResponse;
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final notesController = TextEditingController();
  int adults = 1;
  int childrens = 0;
  int infants = 0;

  @override
  void initState() {
    super.initState();
    fetchSightDetails();
  }

  void fetchSightDetails() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      LoaderOverlay.show(context);
    });
    try {
        final response = await _apiService.getRequest(
          '/sightseeing-details/',          
          queryParameters: {'sightseeing_id': widget.sightSeeingId},
        );                
      LoaderOverlay.hide();        
        setState(() {
          apiResponse = TravelerApiResponse.fromJson(response.data);                
        });
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
Future<void> createBooking(BuildContext context) async {
  if (!_formKey.currentState!.validate()) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      LoaderOverlay.show(context);
    });
    try {      
      final response = await _apiService.post(
        '/booking-lead/create/',
        data: {
          'lead_pax_name': nameController.text,
          'email': emailController.text,
          'phone': phoneController.text,
          'adult_count': adults,
          'child_count': childrens,
          'infant_count': infants,
          'notes': notesController.text,
          'ratelistday':1
        },
      );
      LoaderOverlay.hide();
      if (!mounted) return;
      if (response.statusCode == 200 || response.statusCode == 201) {        
        Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TicketSuccess(bookingLeadId: response.data['id'])),
            );
      } else {
        // print('Failed to create booking. Status code: ${response.statusCode}');
      }
      // if response.statusCode == 200 || response.statusCode == 201) {
      //   print('Booking created successfully!');
      //   print(response.data);
      // } else {
      //   print('Failed to create booking. Status code: ${response.statusCode}');
      // }       
      // print(response.data);
     } on ApiException catch (e) {                               
            LoaderOverlay.hide();
            showMessage(e.message);
    } catch (_) {
        LoaderOverlay.hide();
        showMessage("Unexpected error occurred");
    }
}
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Traveler Details'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            apiResponse == null 
            ? Center()
            : Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.yellow.shade50,
            border: Border.all(
              color: Colors.yellow.shade300
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
           children: [ 
                Text(
                  'Travel Date',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),   
              Text(
                '${apiResponse!.rateListDay.day}-${apiResponse!.rateListDay.month}-${apiResponse!.rateListDay.year}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),          
           ],
          )
        ),
        SizedBox(height: 16),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              apiResponse == null 
              ? Center()
              // Image
            : Center(
              child: 
              // Image.network(
              //   'https://via.placeholder.com/200',
              //   height: 200,
              //   width: 200,
              //   fit: BoxFit.cover,
              // ),
              Image.network(
                   apiResponse!.sightseeing.masterImage,
                  // "https://annexindiatour.com/media/Goa/1769850286/e639efff/Goa2.JPG",
                  errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.error);
                  },
                ),                 
            ),
            SizedBox(height: 10),
            Center(
              child: 
                Text(apiResponse!.sightseeing.name),                 
            ),
            SizedBox(height: 10),
            Center(
              child: 
                Text(apiResponse!.sightseeing.city),                 
            ),
            SizedBox(height: 10),
            Center(
              child: 
                Text(apiResponse!.sightseeing.finalRate.toString()),                 
            ),
            ],
          ),
        ),
        
        SizedBox(height: 16),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Form
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                  controller: nameController,
                  labelText: "Name",
                  hintText: "Please enter your name",                                    
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                      return null;
                    },
                  ),                    
                  SizedBox(height: 16),
                  CustomTextField(
                    controller: emailController,
                    labelText: "Email",
                    hintText: "Please enter your name",                                    
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                        return null;
                      },
                  ),                    
                  SizedBox(height: 16),
                  CustomTextField(
                    controller: phoneController,
                    labelText: "Phone",
                    hintText: "Please enter your Phone Number",                                    
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                        return null;
                      },
                  ),  
                  SizedBox(height: 16),
                  // 🔢 Adults Counter
                    _counterField(
                      label: 'Adults',
                      value: adults,
                      onIncrement: () => setState(() => adults++),
                      onDecrement: () {
                        if (adults > 1) setState(() => adults--);
                      },
                    ),

                    // 🔢 Children Counter
                    _counterField(
                      label: 'Children',
                      value: childrens,
                      onIncrement: () => setState(() => childrens++),
                      onDecrement: () {
                        if (childrens > 0) setState(() => childrens--);
                      },
                    ),

                    // 🔢 Infants Counter
                    _counterField(
                      label: 'Infants',
                      value: infants,
                      onIncrement: () => setState(() => infants++),
                      onDecrement: () {
                        if (infants > 0) setState(() => infants--);
                      },
                    ),
                    CustomTextField(
                        controller: notesController,
                        labelText: "Notes",
                        hintText: "Special Request (Optional)",
                        maxLines: 3,                        
                  ), 
                  SizedBox(height: 16),                  
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          createBooking(context);
                          // if (_formKey.currentState!.validate()) {
                          //   print(emailController.text);
                          // }
                        },
                        child: const Text('Submit'),
                      ),
                    ),
                //   SizedBox(
                //   width: double.infinity,
                //   height: 50,
                //   child: ElevatedButton(
                //     onPressed: createBooking(context);
                //     child: const Text(
                //       'Submit',                      
                //     ),
                //   ),
                // ),                                   
                ],
              ),
            ),
            ],
          ),
        ),

            
          ],
        ),
      ),
    );
  }

//   @override
//   Widget build(BuildContext context) {
//   return Scaffold(
//   resizeToAvoidBottomInset: true,
//   body: 
//     apiResponse == null
//           ? Center()
//           : Padding(
//               padding: EdgeInsets.all(16),
//     child: Column(
//       children: [
        
//         // 🔒 Static top image
//         // SizedBox(
//         //   height: 220,
//         //   width: double.infinity,
//         //   child: Image.asset(
//         //     'assets/top_image.png',
//         //     fit: BoxFit.cover,
//         //   ),
//         // ),
//                 // ),
//                 Stack(
//         children: [
//               Image.network(
//                 // apiResponse!.sightseeing.masterImage,
//                 "https://annexindiatour.com/media/Goa/1769850286/e639efff/Goa2.JPG",
//                 errorBuilder: (context, error, stackTrace) {
//                   return Icon(Icons.error);
//                 },
//               ),
                
//                // Overlay container
//                   Positioned(
//                     top: 200,
//                     left: 16,
//                     right: 16,
//                     child: Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(16),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black26,
//                             blurRadius: 10,
//                             offset: Offset(0, 5),
//                           ),
//                         ],
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             apiResponse!.sightseeing.name,
//                             style: const TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),                  
//                           Text(
//                             '${apiResponse!.sightseeing.city}, ${apiResponse!.sightseeing.country}',
//                             style: const TextStyle(color: Colors.grey),
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             'Price ${apiResponse!.sightseeing.finalRate.toString()}',
//                             style: const TextStyle(color: Colors.green, fontSize: 16, fontWeight: FontWeight.bold),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//       ],
//       ),
//         // 📜 Scrollable form
//         Expanded(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: Form(
//               child: Column(
//                 children: [
//                    _textField(
//                       controller: nameController,
//                       label: 'Name',
//                     ),

//                     _textField(
//                       controller: emailController,
//                       label: 'Email',
//                       keyboardType: TextInputType.emailAddress,
//                     ),

//                     _textField(
//                       controller: phoneController,
//                       label: 'Phone',
//                       keyboardType: TextInputType.phone,
//                     ),

//                     // 🔢 Adults Counter
//                     _counterField(
//                       label: 'Adults',
//                       value: adults,
//                       onIncrement: () => setState(() => adults++),
//                       onDecrement: () {
//                         if (adults > 1) setState(() => adults--);
//                       },
//                     ),

//                     // 🔢 Children Counter
//                     _counterField(
//                       label: 'Children',
//                       value: childrens,
//                       onIncrement: () => setState(() => childrens++),
//                       onDecrement: () {
//                         if (childrens > 0) setState(() => childrens--);
//                       },
//                     ),

//                     // 🔢 Infants Counter
//                     _counterField(
//                       label: 'Infants',
//                       value: infants,
//                       onIncrement: () => setState(() => infants++),
//                       onDecrement: () {
//                         if (infants > 0) setState(() => infants--);
//                       },
//                     ),

//                     _textField(
//                       controller: notesController,
//                       label: 'Notes',
//                       maxLines: 3,
//                     ),

//                   const SizedBox(height: 12),
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: () {
//                           createBooking(context);
//                           // if (_formKey.currentState!.validate()) {
//                           //   print(emailController.text);
//                           // }
//                         },
//                         child: const Text('Submit'),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     ),
//   ),
// );
//   }

   // 🔧 Reusable Text Field
  // Widget _textField({
  //   required TextEditingController controller,
  //   required String label,
  //   TextInputType keyboardType = TextInputType.text,
  //   int maxLines = 1,
  // }) {
  //   return Padding(
  //     padding: const EdgeInsets.only(bottom: 16),
  //     child: TextFormField(
  //       controller: controller,
  //       keyboardType: keyboardType,
  //       maxLines: maxLines,
  //       decoration: InputDecoration(
  //         labelText: label,
  //         border: const OutlineInputBorder(),
  //       ),
  //       validator: (value) {
  //         if (value == null || value.isEmpty) {
  //           return '$label is required';
  //         }
  //         return null;
  //       },
  //     ),
  //   );
  // }

  // ➕➖ Counter Field
  Widget _counterField({
    required String label,
    required int value,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: SizedBox(
      height: 70,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: onDecrement,
            ),
            Text(
              value.toString(),
              style: const TextStyle(fontSize: 18),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: onIncrement,
            ),
          ],
        ),
      ),
    ),
    );
  }
 @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    notesController.dispose();
    super.dispose();
  }
}

  
