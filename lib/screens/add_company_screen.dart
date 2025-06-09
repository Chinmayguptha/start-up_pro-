import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../models/company_model.dart';
import '../models/funding_model.dart';
import 'dart:ui';

class AddCompanyScreen extends StatefulWidget {
  const AddCompanyScreen({Key? key}) : super(key: key);

  @override
  State<AddCompanyScreen> createState() => _AddCompanyScreenState();
}

class _AddCompanyScreenState extends State<AddCompanyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _domainController = TextEditingController();
  final _founderController = TextEditingController();
  final _locationController = TextEditingController();
  final _yearController = TextEditingController();
  final _stageController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _logoUrlController = TextEditingController();
  
  // Funding details
  final _fundingAmountController = TextEditingController();
  final _fundingRoundController = TextEditingController();
  final _fundingDateController = TextEditingController();
  final _leadInvestorController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _domainController.dispose();
    _founderController.dispose();
    _locationController.dispose();
    _yearController.dispose();
    _stageController.dispose();
    _descriptionController.dispose();
    _logoUrlController.dispose();
    _fundingAmountController.dispose();
    _fundingRoundController.dispose();
    _fundingDateController.dispose();
    _leadInvestorController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Create new company
      final company = CompanyModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        domain: _domainController.text,
        founder: _founderController.text,
        location: _locationController.text,
        yearFounded: int.parse(_yearController.text),
        stage: _stageController.text,
        description: _descriptionController.text,
        logoUrl: _logoUrlController.text,
        fundingRounds: [],
      );

      // Add funding round if provided
      if (_fundingAmountController.text.isNotEmpty) {
        final funding = FundingModel(
          round: _fundingRoundController.text,
          amount: double.parse(_fundingAmountController.text),
          date: _fundingDateController.text,
          leadInvestor: _leadInvestorController.text.isEmpty 
              ? null 
              : _leadInvestorController.text,
          companyId: company.id,
        );
        company.fundingRounds.add(funding);
      }

      Navigator.pop(context, company);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isWeb = kIsWeb;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Company'),
        actions: [
          TextButton(
            onPressed: _submitForm,
            child: const Text('Save'),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.primary.withOpacity(0.1),
              colorScheme.surface,
              colorScheme.secondary.withOpacity(0.1),
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Company Information',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Company Name',
                    hintText: 'Enter company name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter company name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _domainController,
                  decoration: const InputDecoration(
                    labelText: 'Domain',
                    hintText: 'Enter company domain',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter company domain';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _founderController,
                  decoration: const InputDecoration(
                    labelText: 'Founder',
                    hintText: 'Enter founder name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter founder name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(
                    labelText: 'Location',
                    hintText: 'Enter company location',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter company location';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _yearController,
                  decoration: const InputDecoration(
                    labelText: 'Year Founded',
                    hintText: 'Enter year founded',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter year founded';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid year';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _stageController,
                  decoration: const InputDecoration(
                    labelText: 'Stage',
                    hintText: 'Enter company stage',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter company stage';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Enter company description',
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter company description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _logoUrlController,
                  decoration: const InputDecoration(
                    labelText: 'Logo URL',
                    hintText: 'Enter company logo URL',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter company logo URL';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                Text(
                  'Initial Funding Round (Optional)',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _fundingAmountController,
                  decoration: const InputDecoration(
                    labelText: 'Funding Amount (M)',
                    hintText: 'Enter funding amount in millions',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _fundingRoundController,
                  decoration: const InputDecoration(
                    labelText: 'Round',
                    hintText: 'Enter funding round (e.g., Seed, Series A)',
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _fundingDateController,
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    hintText: 'Enter funding date (YYYY-MM-DD)',
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _leadInvestorController,
                  decoration: const InputDecoration(
                    labelText: 'Lead Investor',
                    hintText: 'Enter lead investor name',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 