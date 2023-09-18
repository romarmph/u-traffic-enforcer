import 'package:dropdown_search/dropdown_search.dart';

import '../../../config/utils/exports.dart';
import '../../../model/address.dart';

class AddressForm extends StatefulWidget {
  const AddressForm({super.key});

  @override
  State<AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  final _streetController = TextEditingController();
  final _numberController = TextEditingController();
  final _addressFormKey = GlobalKey<FormState>();
  final List<Barangay> _barangays = [];
  final List<City> _cities = [];
  final List<Province> _provinces = [];

  Barangay _selectedBarangay = const Barangay(
    id: '',
    name: '',
    regionCode: '',
    provinceCode: '',
    cityCode: '',
    href: '',
  );

  City _selectedCity = const City(
    id: '',
    name: '',
    regionCode: '',
    provinceCode: '',
    href: '',
  );

  Province _selectedProvince = const Province(
    id: '',
    name: '',
    regionCode: '',
    href: '',
  );

  Future fetchAllData() async {
    final String barangaysString =
        await rootBundle.loadString('assets/barangays.json');
    List<dynamic> barangaysMap = jsonDecode(barangaysString);

    for (var element in barangaysMap) {
      Barangay barangay = Barangay.fromJson(element);
      _barangays.add(barangay);
    }

    final String citiesString =
        await rootBundle.loadString('assets/cities.json');
    List<dynamic> citiesMap = jsonDecode(citiesString);

    for (var element in citiesMap) {
      City city = City.fromJson(element);
      _cities.add(city);
    }

    final String provincesString =
        await rootBundle.loadString('assets/provinces.json');

    List<dynamic> provincesMap = jsonDecode(provincesString);

    for (var element in provincesMap) {
      Province province = Province.fromJson(element);
      _provinces.add(province);
    }
  }

  List<City> getCities({String? provinceId}) {
    if (provinceId!.isEmpty) {
      return _cities;
    } else {
      return _cities.where((city) => city.provinceCode == provinceId).toList();
    }
  }

  List<Barangay> getBarangays({String? provinceId, String? cityId}) {
    if (provinceId!.isEmpty && cityId!.isEmpty) {
      return _barangays;
    } else if (cityId!.isNotEmpty) {
      return _barangays
          .where((barangay) => barangay.cityCode == cityId)
          .toList();
    } else {
      return _barangays
          .where((barangay) => barangay.provinceCode == provinceId)
          .toList();
    }
  }

  void getAll() async {
    await fetchAllData();
  }

  @override
  void initState() {
    getAll();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double deviceHeight = MediaQuery.of(context).size.height;

    final double statusBarHeight = MediaQuery.of(context).padding.top;

    final double appBarHeight = AppBar().preferredSize.height;

    final double bodyHeight = deviceHeight - (statusBarHeight + appBarHeight);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Address"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _addressFormKey,
          child: SizedBox(
            height: bodyHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      const SizedBox(height: USpace.space12),
                      DropdownSearch<Province>(
                        autoValidateMode: AutovalidateMode.onUserInteraction,
                        items: _provinces,
                        popupProps: const PopupProps.menu(
                          showSearchBox: true,
                          searchFieldProps: TextFieldProps(
                            decoration: InputDecoration(
                              labelText: "Search province",
                            ),
                          ),
                        ),
                        dropdownDecoratorProps: const DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            labelText: "Province",
                          ),
                        ),
                        itemAsString: (item) => item.name,
                        onChanged: (value) {
                          setState(() {
                            _selectedProvince = value!;
                          });
                        },
                        validator: (value) {
                          if (value!.id.isEmpty) {
                            return "Please select a province";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: USpace.space12),
                      DropdownSearch<City>(
                        autoValidateMode: AutovalidateMode.onUserInteraction,
                        items: _selectedProvince.id.isEmpty
                            ? _cities
                            : getCities(provinceId: _selectedProvince.id),
                        popupProps: const PopupProps.menu(
                          showSearchBox: true,
                          searchFieldProps: TextFieldProps(
                            decoration: InputDecoration(
                              labelText: "Search city",
                            ),
                          ),
                        ),
                        dropdownDecoratorProps: const DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            labelText: "City",
                          ),
                        ),
                        itemAsString: (item) => item.name,
                        onChanged: (value) {
                          setState(() {
                            _selectedCity = value!;
                          });
                        },
                        validator: (value) {
                          if (value!.id.isEmpty) {
                            return "Please select a city";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: USpace.space12),
                      DropdownSearch<Barangay>(
                        autoValidateMode: AutovalidateMode.onUserInteraction,
                        items: getBarangays(
                          provinceId: _selectedProvince.id,
                          cityId: _selectedCity.id,
                        ),
                        popupProps: const PopupProps.menu(
                          showSearchBox: true,
                          searchFieldProps: TextFieldProps(
                            decoration: InputDecoration(
                              labelText: "Search barangay",
                            ),
                          ),
                        ),
                        dropdownDecoratorProps: const DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            labelText: "Barangay",
                          ),
                        ),
                        itemAsString: (item) => item.name.toUpperCase(),
                        onChanged: (value) {
                          setState(() {
                            _selectedBarangay = value!;
                          });
                        },
                        validator: (value) {
                          if (value!.id.isEmpty) {
                            return "Please select a barangay";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: USpace.space12),
                      TextFormField(
                        inputFormatters: [
                          UpperCaseTextFormatter(),
                        ],
                        controller: _streetController,
                        decoration: const InputDecoration(
                          labelText: "Street",
                        ),
                      ),
                      const SizedBox(height: USpace.space12),
                      TextFormField(
                        inputFormatters: [
                          UpperCaseTextFormatter(),
                        ],
                        controller: _numberController,
                        decoration: const InputDecoration(
                          labelText: "House No./Building",
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(USpace.space12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton(
                        child: const Text("Save"),
                        onPressed: () {
                          if (_selectedProvince.id.isEmpty) {
                            showScaffoldMessage('Please select a province');
                            return;
                          }

                          if (_selectedCity.id.isEmpty) {
                            showScaffoldMessage('Please select a city');
                            return;
                          }
                          if (_selectedBarangay.id.isEmpty) {
                            showScaffoldMessage('Please select a barangay');
                            return;
                          }

                          if (_addressFormKey.currentState!.validate()) {
                            final address = Address(
                              barangay: _selectedBarangay.name,
                              city: _selectedCity.name,
                              province: _selectedProvince.name,
                              street: _streetController.text,
                              number: _numberController.text,
                            );
                            Navigator.of(context).pop(address);
                          }
                        },
                      ),
                      TextButton(
                        child: const Text("Cancel"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showScaffoldMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: UColors.red500,
        duration: const Duration(seconds: 2),
        content: Text(message),
      ),
    );
  }
}
