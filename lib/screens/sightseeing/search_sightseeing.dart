import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travel_suite/model/sightseeing_model.dart';
import 'package:travel_suite/services/api_exceptions.dart';
import 'package:travel_suite/services/api_service.dart';
import 'package:travel_suite/screens/sightseeing/sight_detail.dart';
import 'package:travel_suite/utils/currency_formatter.dart';
import 'package:travel_suite/utils/loader_overlay.dart';
import 'package:travel_suite/widgets/custom_text_field.dart';

class SearchSightSeeing extends StatefulWidget {
  const SearchSightSeeing({super.key});

  @override
  State<SearchSightSeeing> createState() => _SearchSightSeeingPageState();
}

class _SearchSightSeeingPageState extends State<SearchSightSeeing> {
  final TextEditingController keywordController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController dateController = TextEditingController();


  final NetworkManager _apiService = NetworkManager();

  List<SightseeingModel> items = [];

  @override
  void initState() {
    super.initState();
  }

  DateTime? _selectedDate;

  @override
  void dispose() {
    keywordController.dispose();
    cityController.dispose();
    dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    // Hide the keyboard by unfocusing the field
    FocusScope.of(context).requestFocus(FocusNode());

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(DateTime.now().year), // Set the earliest allowable date
      lastDate: DateTime(2101),  // Set the latest allowable date
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      // setState(() {
        _selectedDate = pickedDate;
        // Format the date and set it to the controller        
        dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate!);
      // });
    }
  }

  void fetchUsers() async {
    final keyword = keywordController.text.toLowerCase();
    final city = cityController.text.toLowerCase();
    final dateSearch = dateController.text.toLowerCase();
     WidgetsBinding.instance.addPostFrameCallback((_) {
      LoaderOverlay.show(context);
    });    
  try {
    final response = await _apiService.getRequest(
      '/sightseeing',
      queryParameters: {'q': keyword,'city':city,'date':dateSearch,},
    );

    // print(response.data);
    setState(() {
      LoaderOverlay.hide();
      items = (response.data['results'] as List)
          .map((e) => SightseeingModel.fromJson(e))
          .toList();
          // print(items[0].name);
      // ApiResponse<List<Sightseeing>>.fromJson(
      //       response.data,
      //       (json) => (json as List)
      // .map((e) => Sightseeing.fromJson(e))
      // .toList(),
  // );
        // List<dynamic> dynamicList = response.data['results'];
        // print(dynamicList);
        // sightSeeingList=Map<String, String>.from(dynamicList);
        // sightSeeingList.toList();
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
 
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Sightseeing'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
             // Keyword Field
             CustomTextField(
                  controller: keywordController,
                  labelText: "Keyword",
                  hintText: "Museum, fort, temple...",                  
                  ),
            const SizedBox(height: 16),
            CustomTextField(
                  controller: cityController,
                  labelText: "City",
                  hintText: "Delhi, Jaipur...",                                                    
                  ),
            const SizedBox(height: 16),
            CustomTextField(
                  controller: dateController,
                  readOnly: true,
                  suffixIcon: Icons.calendar_today,
                  labelText: "Date",
                  hintText: "Tap to select date",  
                  onTap: () {
                    _selectDate(context);
                },                                                  
                ),
            const SizedBox(height: 16),
            SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: fetchUsers,
                    child: const Text(
                      'Search',                      
                    ),
                  ),
                ),            
            const SizedBox(height: 16),
            Expanded(
              child: items.isEmpty
                  ? const Center(child: Text('No sightseeing found',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    ),
                   )
                  )
                  : ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return Card(
                          child: ListTile(
                            title:  Image.network(
                              item.masterImage,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.error);
                              },
                            ),                        
                            subtitle:Column(
                              crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start
                              children: [
                                Text(item.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),),   
                                const SizedBox(height: 5),                             
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(item.city),
                                    Text(CurrencyFormatter.format(item.finalRate)),    
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Text(item.shortDescription),                                
                                const SizedBox(height: 5),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => SightDetail(sightseeing: item)),
                                    );
                                  },
                                  child:  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Text('View details',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color:Color.fromRGBO(29, 78, 216, 1),
                                      ),),
                                      SizedBox(width: 4),
                                      Icon(Icons.arrow_forward, color:  Color.fromRGBO(29, 78, 216, 1)),
                                    ],
                                  ),
                                ),
                              ],
                             ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
 }