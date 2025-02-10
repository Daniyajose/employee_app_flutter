import 'package:employee_app_flutter/utils/constants/string_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import '../data/employee.dart';
import '../logic/employee_cubit.dart';
import 'package:intl/intl.dart';
import '../utils/constants/asset_constant.dart';
import '../utils/constants/color_constants.dart';
import '../utils/date_picker.dart';

class AddEditEmployeeScreen extends StatefulWidget {
  final Employee? employee;

  const AddEditEmployeeScreen({super.key, this.employee});

  @override
  _AddEditEmployeeScreenState createState() => _AddEditEmployeeScreenState();
}

class _AddEditEmployeeScreenState extends State<AddEditEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _roleController = TextEditingController();
  String? _selectedRole;
  String? _fromDate;
  String? _toDate;
  DateTime? fromDate;
  DateTime? toDate;

  @override
  void initState() {
    super.initState();
    if (widget.employee != null) {
      _nameController.text = widget.employee!.name;
      _roleController.text = widget.employee!.role;
      _selectedRole = widget.employee!.role;
      _fromDate = widget.employee!.fromDate;
      _toDate = widget.employee!.toDate.isNotEmpty ? widget.employee!.toDate : null;
      fromDate = widget.employee!.fromDate != null
          ? DateFormat("yyyy-MM-dd").parse(widget.employee!.fromDate!)
          : DateTime.now();
      toDate = (widget.employee!.toDate != null && widget.employee!.toDate!.isNotEmpty)
          ? DateFormat("yyyy-MM-dd").parse(widget.employee!.toDate!)
          : null;
    }
  }
 void _saveEmployee() {
   FocusScope.of(context).unfocus();

   if (_formKey.currentState!.validate()) {
      var _stoDate = "";
      if(toDate != null){
        _stoDate = DateFormat('yyyy-MM-dd').format(toDate!);
      }
      fromDate ??= DateTime.now();
      final newEmployee = Employee(
        id: widget.employee?.id,
        name: _nameController.text,
        role: _selectedRole?? "",
        fromDate: DateFormat('yyyy-MM-dd').format(fromDate!),
        toDate: _stoDate, // Empty string for current employees
      );

      final cubit = context.read<EmployeeCubit>();
      if (widget.employee == null) {
        cubit.addEmployee(newEmployee);
      } else {
        cubit.updateEmployee(newEmployee);
      }

      if(widget.employee == null){
        if(mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Saved Successfully"),
            backgroundColor: Colors.green,
          ),
        );
        }
        _resetForm();
      }else{
        if(mounted) {
          ScaffoldMessenger.of(context).showSnackBar(

          const SnackBar(
            content: Text("Updated Successfully"),
            backgroundColor: Colors.green,
          ),
        );
          Navigator.pop(context);
        }

      }

    }
  }


  void _resetForm() {
    _nameController.clear();
    _selectedRole = null;
    fromDate = DateTime.now();
    toDate = null;
    setState(() {});
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Force close the keyboard
      },
      child: Scaffold(
        appBar: _buildAppBar(),
        body: Form(
          key: _formKey,
          child: KeyboardDismissOnTap(
            child: Column(
              children: [
                const SizedBox(height: 16),
                _buildInputField(
                  controller: _nameController,
                  hintText: "Employee Name",
                  iconPath: ImageAssetPath.person,
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus(); // Dismiss keyboard when tapping role picker
                    _selectRolePicker();
                  },
                  child: _selectRolePicker(),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus(); // Dismiss keyboard when tapping date range picker
                    _selectDateRangePicker();
                  },
                  child: _selectDateRangePicker(),
                ),
                const SizedBox(height: 24),
                const Spacer(),
                _divider(),
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        widget.employee == null ? "Add Employee Details" : "Edit Employee Details",
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.blue,
      automaticallyImplyLeading: false,
      actions: widget.employee != null
          ? [
        IconButton(
          icon: Image.asset(
            ImageAssetPath.delete,
            width: 24,
            height: 24,
            color: Colors.white,
          ),
          onPressed: () => _deleteEmployee(context, widget.employee!),
        ),
      ]
          : null,
    );
  }

  Widget _buildInputField({required TextEditingController controller, required String hintText, required String iconPath}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 5.0),
      child: Container(
        height: 45,
        padding: const EdgeInsets.only(left: 8),
        decoration: _boxDecoration(),
        child: Row(
          children: [
            Image.asset(iconPath, width: 24, height: 24),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: controller,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: const TextStyle(color: textColorRole, fontSize: 16, fontWeight: FontWeight.normal),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _selectRolePicker() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () => _showRolePicker(context),
        child: Container(
          height: 45,
          padding: const EdgeInsets.only(left: 8),
          decoration: _boxDecoration(),
          child: Row(
            children: [
              Image.asset(ImageAssetPath.role, width: 24, height: 24),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  _selectedRole ?? "Select Role",
                  style: TextStyle(
                    color: _selectedRole != null && _selectedRole!.isNotEmpty ? black : textColorRole,
                    fontSize: 16,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Image.asset(ImageAssetPath.dropdown),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _selectDateRangePicker() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 5.0),
      child: Row(
        children: [
          _buildDatePicker(true),
          const SizedBox(width: 20),
          Image.asset(ImageAssetPath.arrowRight, width: 24, height: 24),
          const SizedBox(width: 20),
          _buildDatePicker(false),
        ],
      ),
    );
  }

  Widget _buildDatePicker(bool isStartDate) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _selectDate(context, isStartDate),
        child: Container(
          height: 45,
          padding: const EdgeInsets.only(left: 8),
          decoration: _boxDecoration(),
          child: Row(
            children: [
              Image.asset(ImageAssetPath.datePicker, width: 24, height: 24),
              const SizedBox(width: 12),
              Text(
                isStartDate
                    ? (fromDate != null && DateFormat('d MMM yyyy').format(fromDate!) != DateFormat('d MMM yyyy').format(DateTime.now())? DateFormat('d MMM yyyy').format(fromDate!) : 'Today')
                    : (toDate != null ? DateFormat('d MMM yyyy').format(toDate!) : 'No date'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _actionButton(Strings.cancel, Colors.blue.shade50, Colors.blue, () => Navigator.pop(context)),
          const SizedBox(width: 8),
          _actionButton(Strings.save, Colors.blue, Colors.white, validateField),
        ],
      ),
    );
  }

  Widget _actionButton(String text, Color bgColor, Color textColor, VoidCallback onPressed) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: onPressed,
      child: Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      border: Border.all(color: bordercolor, width: 1.0),
      color: white,
      borderRadius: BorderRadius.circular(3),
    );
  }

  Widget _divider() {
    return const Divider(
      height: 0.1,
      color: bordercolor,
    );
  }

  void _showRolePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _selectRoleItem(context, "Product Designer"),
                  _selectRoleItem(context, "Flutter Developer"),
                  _selectRoleItem(context, "QA Tester"),
                  _selectRoleItem(context, "Product Owner"),
                  _selectRoleItem(context, "Senior Software Developer"),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _selectRoleItem(BuildContext context, String role) {
    return Column(
      children: [
        ListTile(
          title: Text(role, textAlign: TextAlign.center),
          onTap: () {
            setState(() {
              // Update the selected role
              _selectedRole = role;
            });
            Navigator.pop(context);
          },
        ),
       _divider()
      ],
    );
  }


  void _selectDate(BuildContext context, bool isFromDate) async {
    FocusScope.of(context).unfocus();

    DateTime? pickedDate = await DatePickerHelper.selectDate(
      context: context,
      initialDate: isFromDate ? fromDate : toDate,
      isFromDate: isFromDate,
      firstDate: isFromDate ? DateTime(2020) : (fromDate != null ? fromDate!.add(Duration(days: 1)) : DateTime(2020)),
      employees : widget.employee
    );

    if (pickedDate != null) {
      setState(() {
        if (isFromDate) {
          fromDate = pickedDate;
          // Reset toDate if it's before fromDate
          if (toDate != null && toDate!.isBefore(fromDate!)) {
            toDate = null;
          }
        } else {
          toDate = pickedDate;
        }
      });
    }else{
      fromDate= DateTime.now();
      toDate = null;
    }
  }

  void _deleteEmployee(BuildContext context, Employee employee) {
    final cubit = context.read<EmployeeCubit>();
    cubit.deleteEmployee(employee.id!);
    Navigator.pop(context);
  }

  void validateField() {

      if (_nameController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please enter the employee name"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (_selectedRole == null || _selectedRole!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please select a role"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      _saveEmployee();
  }
}


