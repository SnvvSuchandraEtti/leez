import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
class SignUp3 extends StatefulWidget {
  const SignUp3({super.key});

  @override
  State<SignUp3> createState() => _SignUp3State();
}

class _SignUp3State extends State<SignUp3> {
  TextEditingController aadharController=TextEditingController();
  TextEditingController panController=TextEditingController();
  PlatformFile? uploadedFile;
 bool isSubmitting = false;
  Future<void> pickFile()async{
    FilePickerResult? result=await FilePicker.platform.pickFiles();
    if(result!=null){
      setState(() {
        uploadedFile=result.files.first;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.center,
            children: [
          SizedBox(height: 20,),
           Container(
                  height: 100,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/logo/leez_logo.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Create your account",
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                        buildStepCircle(1,true),
                        buildStepLine(),
                         buildStepCircle(2,true),
                        buildStepLine(),
                         buildStepCircle(3,true),
                        
                      ],),
                      SizedBox(height: 16,),
                      Align(alignment: Alignment.centerRight,
                        child: TextButton(onPressed: (){},
                        style: TextButton.styleFrom(backgroundColor: Colors.grey.shade200,
                        padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8))
                        , child:Text('Skip KYC',style: TextStyle(color: Colors.black),))),
                        TextField(
                          controller: aadharController,
                          decoration: InputDecoration(
                            labelText: 'Aadhaar Number',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 16,),
                         TextField(
                          controller: panController,
                          decoration: InputDecoration(
                            labelText: 'PAN Number',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 16,),
                        GestureDetector(
                          onTap: pickFile,
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                  
                              border: Border.all(color: Colors.black45,
                              ),
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  uploadedFile!=null?Icons.check_circle:Icons.upload_file,
                                  color: uploadedFile!=null?Colors.green:Colors.orange,
                                ),
                                SizedBox(width: 10,),
                                Expanded(
                                  child: Text(style: TextStyle(
                                    color: uploadedFile!=null?Colors.green:Colors.orange
                                  ),
                                    uploadedFile!=null?'Document uploaded: ${uploadedFile!.name}':"Tap to upload dcument"),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 8,),
                        const Text(
                  "You can continue registration without providing this document.",
                  style: TextStyle(color: Colors.grey,fontSize: 10),
                ),
        
                const SizedBox(height:32),
              
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(onPressed: (){},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade300,
                  foregroundColor: Colors.black
                )
                , child: Text('Back')),
ElevatedButton(
  onPressed: isSubmitting ? null : () async {
    setState(() => isSubmitting = true);
    await Future.delayed(Duration(seconds: 2)); // Simulate file upload or save
    setState(() => isSubmitting = false);
    // Navigate or show confirmation
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
  ),
  child: isSubmitting
      ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
      : Text('Submit'),
),

              ],
             ),
               const SizedBox(height: 20),
                const Text.rich(
                  TextSpan(
                    text: "Already have an account? ",
                    children: [
                      TextSpan(
                        text: "Sign in",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
          ],),
        ),
      ),
    );
  }
   Widget buildStepCircle(int number,bool isActive){
    return Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
            color: isActive?Colors.black:Colors.grey[300],
            shape: BoxShape.circle
        ),
        alignment: Alignment.center,
        child: Text("$number",style: TextStyle(color: isActive?Colors.white:Colors.black),),
    );
  }
  Widget buildStepLine(){
    return Container(width: 30,height: 2,color: Colors.grey[300],);
  }
}