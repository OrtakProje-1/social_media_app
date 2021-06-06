import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:images_picker/images_picker.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/mixins/picker_mixin.dart';
import 'package:social_media_app/mixins/textfield_mixin.dart';
import 'package:social_media_app/models/biografi.dart';
import 'package:social_media_app/models/my_user.dart';
import 'package:social_media_app/providers/usersBlock.dart';
import 'package:social_media_app/util/const.dart';

class EditProfileScreen extends StatefulWidget {
  final MyUser user;
  EditProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen>
    with TextFieldMixin,PickerMixin {
  TextEditingController? nameField;
  TextEditingController? hakkinda;
  TextEditingController? telefon;

  @override
  void initState() {
    nameField = TextEditingController(text: widget.user.displayName!);
    hakkinda = TextEditingController(text:widget.user.biografi?.hakkimda??"");
    telefon = TextEditingController(text: widget.user.biografi?.numara??"");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("Profilini Düzenle"),
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        children: [
          Center(
            child: Stack(
              children: [
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(widget.user.photoURL!),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 2,
                            color: Colors.white24,
                            spreadRadius: 2),
                      ],
                      border: Border.all(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          width: 3),
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: InkWell(
                        onTap: () async{
                        List<Media>? image=  await ImagesPicker.pick(
                            count: 1,
                            language: Language.English,
                            cropOpt: CropOption(
                              cropType: CropType.circle
                            ),
                            pickType: PickType.image,
                          );
                          print(image![0].thumbPath);
                        },
                        radius: 90,
                        borderRadius: BorderRadius.circular(90),
                        child: Center(
                          child: Icon(
                            Icons.camera_alt_outlined,
                            color: kPrimaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          buildTextField(
              size: MediaQuery.of(context).size,
              context: context,
              controller: nameField,
              hintText: "İsminiz"),
          buildTextField(
              size: MediaQuery.of(context).size,
              context: context,
              controller: hakkinda,
              hintText: "Hakkında"),
          buildTextField(
              size: MediaQuery.of(context).size,
              keyboardType: TextInputType.number,
              context: context,
              controller: telefon,
              hintText: "Telefon"),
              SizedBox(height: 100,),
          Align(
            alignment: Alignment.bottomCenter,
            child: TextButton.icon(
                onPressed: ()async{
                  await Provider.of<UsersBlock>(context,listen:false).updateUser(updatedUser:widget.user..biografi=Biografi(hakkimda:hakkinda!.text,numara: telefon!.text));
                  Navigator.pop(context);
                },
                style:TextButton.styleFrom(
                  shape: StadiumBorder(
                    side: BorderSide(
                      color: kPrimaryColor,
                      width: 1
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                  primary: kPrimaryColor
                ),
                icon: Icon(Icons.save_outlined),
                label: Text("Kaydet")),
          ),
        ],
      ),
    );
  }
}
