import "package:flutter/material.dart";
void main(){
  runApp(_MyApp());
}
class _MyApp extends StatelessWidget{
  TextEditingController result=TextEditingController();
  @override
  Widget build(BuildContext context)
  => MaterialApp(
    home:Scaffold(
      backgroundColor: Colors.black,
      body:SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children:[
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: TextField(
                  autofocus:true,
                  controller:result,
                  readOnly:true,
                  keyboardType:TextInputType.none,
                  style:const TextStyle(fontSize:40,fontWeight:FontWeight.w500,color:Colors.white),
                  textAlign:TextAlign.right,
                  textAlignVertical:TextAlignVertical.bottom,
                  decoration:const InputDecoration(
                    hintText:"0",
                    hintStyle: TextStyle(color:Colors.grey),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide(color: Colors.amber,width:2)
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius:BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide(color: Colors.amber,width:2)
                    )
                  )
                ),
              ),
              const SizedBox(height:3),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: ElevatedButton(
                          onPressed:()=>result.text=result.text.isNotEmpty?result.text.substring(0,result.text.length-1):'',
                          onLongPress:()=>result.text='',
                          style:ElevatedButton.styleFrom(
                            backgroundColor:Colors.black,
                            shadowColor:Colors.white,
                            side:const BorderSide(color:Colors.red,width:2)
                          ),
                          child:const Icon(Icons.backspace_outlined,color:Colors.red),
                        ),
                      ),
                    ),
                    buildButtonItem("/"),
                    buildButtonItem("*"),
                    buildButtonItem("-"),
                  ],
                ),
              ),
              Expanded(
                flex:2,
                child:Row(
                  crossAxisAlignment:CrossAxisAlignment.stretch,
                  children:[
                    Expanded(
                      flex:3,
                      child: Column(
                        children:[
                          Expanded(
                            child: Row(
                              crossAxisAlignment:CrossAxisAlignment.stretch,
                              children:[
                                buildButtonItem('7'),
                                buildButtonItem('8'),
                                buildButtonItem('9'),
                              ]
                            ),
                          ),
                          Expanded(
                            child: Row(
                              crossAxisAlignment:CrossAxisAlignment.stretch,
                              children:[
                                buildButtonItem('4'),
                                buildButtonItem('5'),
                                buildButtonItem('6'),
                              ]
                            ),
                          )
                        ]
                      ),
                    ),
                    buildButtonItem("+")
                  ],
                )
              ),
              Expanded(
                flex:2,
                child:Row(
                  crossAxisAlignment:CrossAxisAlignment.stretch,
                  children:[
                    Expanded(
                      flex:2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children:[
                          Expanded(
                            child:Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children:[
                                buildButtonItem('1'),
                                buildButtonItem('2'),
                              ]
                            ),
                          ),
                          buildButtonItem('0')
                        ]
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:CrossAxisAlignment.stretch,
                        children:[
                          buildButtonItem('3'),
                          buildButtonItem('.'),
                        ]
                      ),
                    ),
                    buildButtonItem('=',Colors.green)
                  ]
                )
              )
            ]
          ),
        ),
      ),
    )
  );
  Expanded buildButtonItem([String text='',Color color=Colors.blue])
  => Expanded(
    child: Padding(
      padding: const EdgeInsets.all(3.0),
      child: ElevatedButton(
        style:ElevatedButton.styleFrom(
          side:BorderSide(width:2,color:color),
          backgroundColor: Colors.black,
          shadowColor: Colors.white,
        ),
        child:Text(
          text,
          style:TextStyle(fontSize:30,color:color)
        ),
        onPressed:()=>text!='='?result.text=result.text+text:eval()
      ),
    ),
  );
  void eval()
  {
    try{
      while(result.text.contains(RegExp(r"\*|\/")))
      {
        RegExp regex = RegExp(r'-?(?:\d+\.?|\d*\.\d+)?(?:\*|/)-?(?:\d+\.?|\d*\.\d+)');
        String x = regex.firstMatch(result.text)!.group(0)!;
        if(x.contains('*')){
          final List<String> y = x.split('*');
          result.text=result.text.replaceFirst(x,(double.parse(y[0])*double.parse(y[1])).toString());
        }else if(x.contains('/')){
          final List<String> y = x.split('/');
          result.text=result.text.replaceFirst(x,(double.parse(y[0])/double.parse(y[1])).toString());
        }
      }
      while(result.text.contains(RegExp(r"\d\+|\.\+|\d-|\.-")))
      {
        RegExp regex = RegExp(r'-?(?:\d+\.?|\d*\.?\d+)(?:\+|-)-?(?:\d+\.?|\d*\.?\d+)');
        String x = regex.firstMatch(result.text)!.group(0)!;
        if(x.contains('+')){
          final List<String> y = x.split('+');
          result.text=result.text.replaceFirst(x,(double.parse(y[0])+double.parse(y[1])).toString());
        }else if(x.contains('-')){
          final List<String> y = x.split(RegExp('(?<=.)-'));
          result.text=result.text.replaceFirst(x,(double.parse(y[0])-double.parse(y[1])).toString());
        }
      }
      double x = double.parse(result.text);
      result.text=x==x.toInt()?x.toInt().toString():double.parse(x.toStringAsFixed(10)).toString();
    }catch(e){
      if(result.text!='')
        result.text='Error';
    }
  }
}
