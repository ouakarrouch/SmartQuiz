import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';
import 'dart:typed_data'; // Pour Uint8List

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String? photoUrl; // URL de la photo actuelle
  Uint8List? _selectedImageBytes; // Bytes de l'image sélectionnée

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  // Récupérer les informations de l'utilisateur
  Future<void> _fetchUserInfo() async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId != null) {
        final response = await Supabase.instance.client
            .from('users')
            .select('last_name, first_name, email, phone, photo')
            .eq('id', userId)
            .single();

        if (response != null) {
          setState(() {
            _lastNameController.text = response['last_name'] ?? '';
            _firstNameController.text = response['first_name'] ?? '';
            _emailController.text = response['email'] ?? '';
            _phoneController.text = response['phone'] ?? '';
            photoUrl = response['photo'];
          });
        }
      }
    } catch (e) {
      print('Erreur lors de la récupération des informations de l\'utilisateur: $e');
    }
  }

  // Sélectionner une photo depuis la galerie
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _selectedImageBytes = bytes;
      });
      await _uploadImage(); // Uploader l'image après la sélection
    }
  }

  // Sélectionner une photo depuis la machine
  Future<void> _pickImageFromMachine() async {
    try {
      print('Ouverture du sélecteur de fichiers...');
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null) {
        print('Fichier sélectionné: ${result.files.first.name}');
        PlatformFile file = result.files.first;

        if (file.bytes != null) {
          setState(() {
            _selectedImageBytes = file.bytes;
          });

          print('Image sélectionnée: ${file.name}'); // Log pour vérifier
        } else {
          print('Les bytes du fichier sont null');
        }
      } else {
        print('Aucun fichier sélectionné');
      }
    } catch (e) {
      print('Erreur lors de la sélection de l\'image: $e');
    }
  }

  // Uploader l'image dans Supabase Storage
  Future<void> _uploadImage() async {
    if (_selectedImageBytes != null) {
      try {
        final userId = Supabase.instance.client.auth.currentUser?.id;
        if (userId != null) {
          // Générer un chemin unique pour le fichier
          final filePath = 'user_photos/$userId/${DateTime.now().toIso8601String()}.jpg';

          // Uploader l'image dans le bucket en utilisant les bytes
          await Supabase.instance.client.storage
              .from('user_photos')
              .uploadBinary(filePath, _selectedImageBytes!);

          // Récupérer l'URL publique de l'image
          final publicUrl = Supabase.instance.client.storage
              .from('user_photos')
              .getPublicUrl(filePath);

          print('URL de l\'image uploadée: $publicUrl'); // Log pour vérifier

          // Mettre à jour l'URL de l'image dans la base de données
          await Supabase.instance.client
              .from('users')
              .update({'photo': publicUrl})
              .eq('id', userId);

          setState(() {
            photoUrl = publicUrl; // Mettre à jour l'URL de l'image dans l'interface
          });
        }
      } catch (e) {
        print('Erreur lors de l\'upload de l\'image: $e');
      }
    }
  }

  // Enregistrer les modifications dans la base de données
  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        final userId = Supabase.instance.client.auth.currentUser?.id;
        if (userId != null) {
          // Uploader l'image si une nouvelle image est sélectionnée
          if (_selectedImageBytes != null) {
            await _uploadImage();
          }

          // Mettre à jour les informations de l'utilisateur
          await Supabase.instance.client.from('users').update({
            'last_name': _lastNameController.text,
            'first_name': _firstNameController.text,
            'email': _emailController.text,
            'phone': _phoneController.text,
          }).eq('id', userId);

          // Retourner à la page précédente
          Navigator.pop(context);
        }
      } catch (e) {
        print('Erreur lors de la mise à jour du profil: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Modifier le Profil',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF4E55A1),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4E55A1),
              Color(0xFF6A72C1),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                // Photo de l'utilisateur
                Center(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: _selectedImageBytes != null
                              ? MemoryImage(_selectedImageBytes!) // Afficher l'image sélectionnée
                              : (photoUrl != null ? NetworkImage(photoUrl!) : null), // Afficher l'image depuis l'URL
                          child: _selectedImageBytes == null && photoUrl == null
                              ? const Icon(Icons.person, size: 50) // Afficher une icône par défaut
                              : null,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _pickImageFromMachine,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Charger une photo depuis la machine',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFF4E55A1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Champ pour le nom
                TextFormField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(
                    labelText: 'Nom',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre nom';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Champ pour le prénom
                TextFormField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(
                    labelText: 'Prénom',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre prénom';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Champ pour l'e-mail
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre e-mail';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Champ pour le téléphone
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Téléphone',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre téléphone';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Bouton pour enregistrer les modifications
                ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Enregistrer',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF4E55A1),
                    ),
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