// Flutter
export 'package:flutter/material.dart';
export 'package:flutter/services.dart';

// Packages
export 'package:firebase_core/firebase_core.dart';
export 'package:firebase_auth/firebase_auth.dart';
export 'package:cloud_firestore/cloud_firestore.dart';
export 'package:firebase_storage/firebase_storage.dart';
export 'package:provider/provider.dart';
export 'package:google_fonts/google_fonts.dart';
export 'package:image_cropper/image_cropper.dart';
export 'package:image_picker/image_picker.dart';
export 'package:quickalert/quickalert.dart';
export 'package:bluetooth_print/bluetooth_print.dart';
export 'package:bluetooth_print/bluetooth_print_model.dart';
export 'package:location/location.dart';
export 'package:google_geocoding_api/google_geocoding_api.dart';

///
///
/// Source code
///
///

// constants
export 'package:u_traffic_enforcer/config/constants/navigator_key.dart';
export 'package:u_traffic_enforcer/config/constants/firebase_storage.dart';

// enums
export 'package:u_traffic_enforcer/config/enums/device_connection.dart';
export 'package:u_traffic_enforcer/config/enums/field_type.dart';
export 'package:u_traffic_enforcer/config/enums/ticket_field.dart';
export 'package:u_traffic_enforcer/config/enums/ticket_status.dart';

// enums extensions
export 'package:u_traffic_enforcer/config/extensions/input_validator.dart';
export 'package:u_traffic_enforcer/config/themes/colors.dart';
export 'package:u_traffic_enforcer/config/themes/spacing.dart';
export 'package:u_traffic_enforcer/config/themes/textstyles.dart';
export 'package:u_traffic_enforcer/config/themes/components/app_bar_theme.dart';
export 'package:u_traffic_enforcer/config/themes/components/elevated_button.dart';
export 'package:u_traffic_enforcer/config/themes/components/fab.dart';
export 'package:u_traffic_enforcer/config/themes/components/input_decoration.dart';
export 'package:u_traffic_enforcer/config/themes/components/text_button.dart';
export 'package:u_traffic_enforcer/config/utils/nav_utils.dart';

// database
export 'package:u_traffic_enforcer/database/ticket_db_helper.dart';
export 'package:u_traffic_enforcer/database/violations_db_helper.dart';
export 'package:u_traffic_enforcer/database/enforcer_db_helper.dart';

// models
export 'package:u_traffic_enforcer/model/driver_model.dart';
export 'package:u_traffic_enforcer/model/enforcer_model.dart';
export 'package:u_traffic_enforcer/model/form_input_settings.dart';
export 'package:u_traffic_enforcer/model/license_detail_model.dart';
export 'package:u_traffic_enforcer/model/ticket_model.dart';
export 'package:u_traffic_enforcer/model/violation_model.dart';
export 'package:u_traffic_enforcer/model/user_model.dart';
export 'package:u_traffic_enforcer/model/location_model.dart';

// pages
export 'package:u_traffic_enforcer/pages/auth/login_page.dart';
export 'package:u_traffic_enforcer/pages/auth/register_page.dart';
export 'package:u_traffic_enforcer/pages/home/home_page.dart';
export 'package:u_traffic_enforcer/pages/home/widgets/menu_button.dart';
export 'package:u_traffic_enforcer/pages/printer/device_scan_page.dart';
export 'package:u_traffic_enforcer/pages/printer/printer_home.dart';
export 'package:u_traffic_enforcer/pages/ticket/create_ticket_page.dart';
export 'package:u_traffic_enforcer/pages/ticket/preview_page.dart';
export 'package:u_traffic_enforcer/pages/ticket/violation_select_page.dart';
export 'package:u_traffic_enforcer/pages/ticket/widgets/driver_details_form.dart';
export 'package:u_traffic_enforcer/pages/ticket/widgets/preview_list_tile.dart';
export 'package:u_traffic_enforcer/pages/ticket/widgets/text_field.dart';
export 'package:u_traffic_enforcer/pages/ticket/widgets/vehicle_details_form.dart';
export 'package:u_traffic_enforcer/pages/wrapper.dart';

// providers
export 'package:u_traffic_enforcer/providers/create_ticket_form_notifier.dart';
export 'package:u_traffic_enforcer/providers/printer_provider.dart';
export 'package:u_traffic_enforcer/providers/ticket_provider.dart';
export 'package:u_traffic_enforcer/providers/violations_provider.dart';
export 'package:u_traffic_enforcer/providers/enforcer_provider.dart';

// Services
export 'package:u_traffic_enforcer/services/auth_service.dart';
export 'package:u_traffic_enforcer/services/image_picker.dart';
export 'package:u_traffic_enforcer/services/storage_service.dart';
export 'package:u_traffic_enforcer/services/location_services.dart';

export 'package:u_traffic_enforcer/main.dart';
export 'package:u_traffic_enforcer/firebase_options.dart';
