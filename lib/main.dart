import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animations Intro',
      debugShowCheckedModeBanner: false,
      home: LogoApp(),
    );
  }
}

class LogoApp extends StatefulWidget {
  @override
  _LogoAppState createState() => _LogoAppState();
}

class _LogoAppState extends State<LogoApp> with SingleTickerProviderStateMixin{
  //informa toda vez que a tela do app sera redenrizada, para que o controler possa ir animando

  AnimationController controller;
  Animation<double> animation;


  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2)
    );

    animation = CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);//não deixa ser uma curva linear
    animation.addStatusListener((status){
      if(status==AnimationStatus.completed){
        controller.reverse();
      }else if(status == AnimationStatus.dismissed){
        controller.forward();
      }
    });

    controller.forward();
  }


  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child:  KauanTransition(
        child: LogoWidget(),
        animation: animation,
      ),
    );
  }
}

/*class AnimatedLogo extends AnimatedWidget{

  AnimatedLogo(Animation<double> animation) : super(listenable: animation);//toda vez que o valor mudar ele vai saber que tem q mudar a tela

  @override
  Widget build(BuildContext context) {

    final Animation<double> animation = listenable;

    return Center(
      child: Container(
        height: animation.value,
        width: animation.value,
        child: FlutterLogo(),
      ),
    );
  }

}*/

class LogoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlutterLogo(),
    );
  }
}

class KauanTransition extends StatelessWidget {

  final Widget child;
  final Animation<double> animation;

  final sizeTween = Tween<double>(begin: 0, end: 300);//mapear um inicio e um fim fazendo uma curva
  final opacityTween = Tween<double>(begin: 0.1, end: 1);

  KauanTransition({this.child, this.animation});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(//pega a animação e toda vez que o valor dela mudar ele refaz o widget
          animation: animation,
          builder: (context, child){
            return Opacity(
              opacity: opacityTween.evaluate(animation).clamp(0.0, 1.0),
              child: Container(
                height: sizeTween.evaluate(animation),
                width: sizeTween.evaluate(animation),
                child: child,
              ),
            );
          },
          child: child,
      ),
    );
  }
}

