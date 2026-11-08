import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/portfolio_service.dart';
import '../widgets/page_header.dart';

class EditPortfolioPage extends StatefulWidget {
  final Map<String, dynamic> dataEdit;

  const EditPortfolioPage({super.key, required this.dataEdit});

  @override
  State<EditPortfolioPage> createState() => _EditPortfolioPageState();
}

class _EditPortfolioPageState extends State<EditPortfolioPage> {
  final _formKey = GlobalKey<FormState>();
  final PortfolioService _service = PortfolioService();
  final ImagePicker _picker = ImagePicker();

  late final TextEditingController _nameController;
  late final TextEditingController _yearController;
  late final TextEditingController _technologyController;
  late final TextEditingController _descriptionController;

  String _category = 'Website';
  File? _imageFile;
  Uint8List? _imageBytes;
  String? _imageName;
  bool _saving = false;

  bool get _isEditing => true;

  bool get _isDummy =>
      widget.dataEdit['isDummy'] == true || widget.dataEdit['id'] == null;

  final List<String> _categories = [
    'Website',
    'Mobile App',
    'UI/UX',
    'Desktop App',
    'Lainnya',
  ];

  @override
  void initState() {
    super.initState();

    final data = widget.dataEdit;

    _nameController = TextEditingController(
      text: (data['name'] ?? '').toString(),
    );

    _yearController = TextEditingController(
      text: (data['year'] ?? '').toString(),
    );

    _technologyController = TextEditingController(
      text: (data['technology'] ?? '').toString(),
    );

    _descriptionController = TextEditingController(
      text: (data['description'] ?? '').toString(),
    );

    final savedCategory = (data['category'] ?? '').toString();

    if (_categories.contains(savedCategory)) {
      _category = savedCategory;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _yearController.dispose();
    _technologyController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (pickedFile == null) return;

      final bytes = await pickedFile.readAsBytes();

      if (!mounted) return;

      setState(() {
        _imageName = pickedFile.name;
        _imageBytes = bytes;

        if (!kIsWeb) {
          _imageFile = File(pickedFile.path);
        }
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memilih gambar: $e')));
    }
  }

  Widget _buildImagePreview() {
    if (_imageBytes != null) {
      return Image.memory(
        _imageBytes!,
        height: 190,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }

    final oldImage = widget.dataEdit['image']?.toString() ?? '';
    final oldImageBytes = widget.dataEdit['imageBytes'];
    if (_imageBytes == null && oldImageBytes is Uint8List) {
      return Image.memory(oldImageBytes, height: 190, width: double.infinity, fit: BoxFit.cover);
    }

    if (_isEditing && oldImage.isNotEmpty) {
      final isAsset = oldImage.startsWith('assets/');

      if (isAsset) {
        return Image.asset(
          oldImage,
          height: 190,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _imagePlaceholder(),
        );
      }

      return Image.network(
        PortfolioService.imageUrl(oldImage),
        height: 190,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _imagePlaceholder(),
      );
    }

    return _imagePlaceholder();
  }

  Widget _imagePlaceholder() {
    return Container(
      height: 190,
      width: double.infinity,
      color: const Color(0xFFEAF4FF),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_photo_alternate_outlined,
            size: 48,
            color: Color(0xFF0077B6),
          ),
          SizedBox(height: 8),
          Text('Pilih gambar karya'),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator:
            validator ??
            (value) {
              if (value == null || value.trim().isEmpty) {
                return '$label wajib diisi';
              }
              return null;
            },
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          alignLabelWithHint: maxLines > 1,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(13)),
        ),
      ),
    );
  }

  Future<void> _savePortfolio() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    try {
      if (_isDummy) {
        final updated = <String, dynamic>{
          ...widget.dataEdit,
          'name': _nameController.text.trim(),
          'category': _category,
          'year': _yearController.text.trim(),
          'technology': _technologyController.text.trim(),
          'description': _descriptionController.text.trim(),
          'isDummy': true,
        };

        if (_imageBytes != null) {
          updated['imageBytes'] = _imageBytes;
          updated['imageName'] = _imageName;
        }

        if (!mounted) return;
        Navigator.pop(context, updated);
        return;
      }

      final success = await _service.editPortfolio(
        id: widget.dataEdit['id'].toString(),
        name: _nameController.text.trim(),
        category: _category,
        year: _yearController.text.trim(),
        technology: _technologyController.text.trim(),
        description: _descriptionController.text.trim(),
        imageFile: _imageFile,
        imageBytes: _imageBytes,
        imageName: _imageName,
      );

      if (!mounted) return;

      if (success) {
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menyimpan perubahan. Periksa API PHP.')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan perubahan: $e')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StickyPageHeader(title: 'Edit Portofolio', subtitle: 'Lengkapi detail karya mahasiswa', icon: Icons.add_box_rounded, showBackButton: true),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'Informasi Karya',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              'Lengkapi informasi karya dan pilih gambar yang sesuai.',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: _buildImagePreview(),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _saving ? null : _pickImage,
              icon: const Icon(Icons.photo_library_outlined),
              label: const Text('Pilih Foto Karya'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF0077B6),
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 22),
            _buildTextField(
              label: 'Nama Karya',
              controller: _nameController,
              icon: Icons.work_outline,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: DropdownButtonFormField<String>(
                initialValue: _category,
                decoration: InputDecoration(
                  labelText: 'Kategori',
                  prefixIcon: const Icon(Icons.category_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: _saving
                    ? null
                    : (value) {
                        if (value != null) {
                          setState(() => _category = value);
                        }
                      },
              ),
            ),
            _buildTextField(
              label: 'Tahun',
              controller: _yearController,
              icon: Icons.calendar_today_outlined,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Tahun wajib diisi';
                }

                if (int.tryParse(value.trim()) == null) {
                  return 'Tahun harus berupa angka';
                }

                return null;
              },
            ),
            _buildTextField(
              label: 'Teknologi',
              controller: _technologyController,
              icon: Icons.code_rounded,
            ),
            _buildTextField(
              label: 'Deskripsi',
              controller: _descriptionController,
              icon: Icons.description_outlined,
              maxLines: 4,
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 52,
              child: FilledButton.icon(
                onPressed: _saving ? null : _savePortfolio,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF0077B6),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
                icon: _saving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.save_outlined),
                label: Text(_saving ? 'Menyimpan...' : 'Simpan Perubahan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
