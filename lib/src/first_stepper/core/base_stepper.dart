import 'package:flutter/material.dart';

import '../../core/dotted_line.dart';
import 'base_indicator.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:scroll_to_index/scroll_to_index.dart';


/// Callback is fired when a step is reached.
typedef OnStepReached = void Function(int index);

class BaseStepper extends StatefulWidget {
  /// Each child defines a step. Hence, total number of children determines the total number of steps.
  final List<Widget>? children;
  
  //title of each step
  final List<String>? titles;
  
  //fix the maxwidth of steppers
  final double maxwidth;

  /// Whether to enable or disable the next and previous buttons.
  final bool nextPreviousButtonsDisabled;

  /// Whether to allow tapping a step to move to that step or not.
  final bool stepTappingDisabled;

  /// Icon to be used for the previous button.
  final Icon? previousButtonIcon;

  /// Icon to be used for the next button.
  final Icon? nextButtonIcon;

  /// This callback provides the __index__ of the step that is reached.
  final OnStepReached? onStepReached;

  /// Whether to show the steps horizontally or vertically. __Note: Ensure horizontal stepper goes inside a column and vertical goes inside a row.__
  final Axis direction;

  /// The color of the step when it is not reached.
  final Color? stepColor;

  /// The color of a step when it is reached.
  final Color? activeStepColor;

  /// The border color of a step when it is reached.
  final Color? activeStepBorderColor;

  /// The color of the line that separates the steps.
  final Color? lineColor;

  /// The length of the line that separates the steps.
  final double lineLength;

  /// The radius of individual dot within the line that separates the steps.
  final double lineDotRadius;

  /// The radius of a step.
  final double stepRadius;

  /// The animation effect to show when a step is reached.
  final Curve stepReachedAnimationEffect;

  /// The duration of the animation effect to show when a step is reached.
  final Duration stepReachedAnimationDuration;

  /// Whether the stepping is enabled or disabled.
  final bool steppingEnabled;

  /// Amount of padding on each side of the child widget.
  final double padding;

  /// Amount of margin on each side of the step.
  final double margin;

  /// The width of the active step border.
  final double activeStepBorderWidth;

  /// Whether to disable scrolling or not.
  final scrollingDisabled;

  /// The step that is currently active.
  final int activeStep;

  /// Specifies the alignment of the stepper.
  final AlignmentGeometry? alignment;

  /// Creates a basic stepper.
  BaseStepper({
    required this.titles,
    this.children,
    required this.maxwidth,
    this.nextPreviousButtonsDisabled = true,
    this.stepTappingDisabled = true,
    this.previousButtonIcon,
    this.nextButtonIcon,
    this.onStepReached,
    this.direction = Axis.horizontal,
    this.stepColor,
    this.activeStepColor,
    this.activeStepBorderColor,
    this.lineColor,
    this.lineLength = 50.0,
    this.lineDotRadius = 1.0,
    this.stepRadius = 24.0,
    this.stepReachedAnimationEffect = Curves.bounceOut,
    this.stepReachedAnimationDuration = const Duration(seconds: 1),
    this.steppingEnabled = true,
    this.padding = 5.0,
    this.margin = 1.0,
    this.activeStepBorderWidth = 0.5,
    this.scrollingDisabled = false,
    this.activeStep = 0,
    this.alignment,
  }) {
    assert(
      lineDotRadius <= 10 && lineDotRadius > 0,
      'lineDotRadius must be less than or equal to 10 and greater than 0',
    );

    assert(
      stepRadius > 0,
      'iconIndicatorRadius must be greater than 0',
    );

    assert(
      activeStep >= 0 && activeStep <= children!.length,
      'Error: Active Step out of range',
    );
  }

  @override
  _BaseStepperState createState() => _BaseStepperState();
}

class _BaseStepperState extends State<BaseStepper> {
  ScrollController? _scrollController;
  late int _selectedIndex;
  int prenext=0;
  // final ItemScrollController itemScrollController = ItemScrollController();

  /// Listener that reports the position of items when the list is scrolled.
  //final ItemPositionsListener itemPositionsListener =
  //    ItemPositionsListener.create();
  
  AutoScrollController itemPositionsListener;
  
  int min=0;
  int max=0;
 
  @override
  void initState() {
    _selectedIndex = widget.activeStep;
    this._scrollController = ScrollController();
    itemPositionsListener = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: scrollDirection);
   // prenext=0;
    super.initState();
  }

  @override
  void didUpdateWidget(BaseStepper oldWidget) {
    // Verify that the active step falls within a valid range.
    if (widget.activeStep >= 0 && widget.activeStep < widget.children!.length) {
      _selectedIndex = widget.activeStep;
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _scrollController!.dispose();
    super.dispose();
  }

  /// Controls the step scrolling.
  void _afterLayout(_) {
    // ! Provide detailed explanation.
    for (int i = 0; i < widget.children!.length; i++) {
      _scrollController!.animateTo(
        i * ((widget.stepRadius * 2) + widget.lineLength),
        duration: widget.stepReachedAnimationDuration,
        curve: widget.stepReachedAnimationEffect,
      );

      if (_selectedIndex == i) break;
    }
  }
  
   /// Builds the stepper.
  Widget _stepperBuilder() {
  
    return Align(
      alignment: widget.alignment ?? Alignment.center,
      child:Container(
         
               constraints: BoxConstraints(
    maxWidth: widget.maxwidth,
),
     /*  child:ScrollablePositionedList.builder(
  //itemCount: widget.children?.length,
  itemCount:1,
  scrollDirection : widget.direction,
  itemBuilder: (context, index) =>widget.direction == Axis.horizontal ? Row(children: _buildSteps()) : Column(children: _buildSteps()),
         /*widget.direction == Axis.horizontal
            ? /*Container(
              
                  constraints: BoxConstraints(
                    maxWidth:  widget.maxwidth/8,
                  ),
             child:*/ 
         :Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _customizedIndicator(index),
                  _customizedDottedLine(index, Axis.horizontal),
                ],
              )
            : /*Container(
          constraints: BoxConstraints(
                    maxWidth:  widget.maxwidth/8,
                  ),
         child:*/
         Column(
              mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _customizedIndicator(index),
                  _customizedDottedLine(index, Axis.vertical),
                ],
              ),*/
  itemScrollController: itemScrollController,
  itemPositionsListener: itemPositionsListener,
)*/
        child:SingleChildScrollView(
        scrollDirection: widget.direction,
        controller:itemScrollController,
        //controller: _scrollController,
        physics: widget.scrollingDisabled ? NeverScrollableScrollPhysics() : ClampingScrollPhysics(),
        child: Container(
        
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          padding: const EdgeInsets.all(3.0),
          child: widget.direction == Axis.horizontal ? Row(children: _buildSteps()) : Column(children: _buildSteps()),
        ),
      )
      
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //get width of _stepperBuilder
    
    
    // Controls scrolling behavior.
   // if (!widget.scrollingDisabled) WidgetsBinding.instance!.addPostFrameCallback(_afterLayout);

    return widget.direction == Axis.horizontal
        ? Row(
        mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              widget.nextPreviousButtonsDisabled ? _previousButton() : Container(),
             
               _stepperBuilder(),
              
              widget.nextPreviousButtonsDisabled  ? _nextButton() : Container(),
            ],
          )
        : Column(
            children: <Widget>[
              widget.nextPreviousButtonsDisabled  ? _previousButton() : Container(),
              Expanded(
                child: _stepperBuilder(),
              ),
              widget.nextPreviousButtonsDisabled  ? _nextButton() : Container(),
            ],
          );
  }

 

  /// Builds the stepper steps.
  List<Widget> _buildSteps() {
    return List.generate(
      widget.children!.length,
      (index) {
        return widget.direction == Axis.horizontal
            ? Row(
                children: <Widget>[
                  _customizedIndicator(index),
                  _customizedDottedLine(index, Axis.horizontal),
                ],
              )
            : Column(
                children: <Widget>[
                  _customizedIndicator(index),
                  _customizedDottedLine(index, Axis.vertical),
                ],
              );
      },
    );
  }

  /// A customized IconStep.
  Widget _customizedIndicator(int index) {
    return BaseIndicator(
      child: widget.children![index],
      isSelected: _selectedIndex == index,
      onPressed: widget.stepTappingDisabled
          ? () {
              if (widget.steppingEnabled) {
                setState(() {
                  _selectedIndex = index;

                  if (widget.onStepReached != null) {
                    widget.onStepReached!(_selectedIndex);
                  }
                });
              }
            }
          : null,
      color: widget.stepColor,
      activeColor: widget.activeStepColor,
      activeBorderColor: widget.activeStepBorderColor,
      radius: widget.stepRadius,
      padding: widget.padding,
      margin: widget.margin,
      activeBorderWidth: widget.activeStepBorderWidth,
    );
  }

  /// A customized DottedLine.
  Widget _customizedDottedLine(int index, Axis axis) {
    return index < widget.children!.length 
        ?Row(
    
      children:[
      SizedBox(width: 5,),
        Text(widget.titles![index],style: TextStyle(
                  color: Colors.green,
                  fontSize: 10,
                  fontWeight: FontWeight.bold
              ),),
        DottedLine(
            length: widget.lineLength/2,
            color: widget.lineColor ?? Colors.blue,
            dotRadius: widget.lineDotRadius,
            spacing: 5.0,
            axis: axis,
          ),
        SizedBox(width: 5,),
      ]
    )
      
      
        : Container();
  }

  /// The previous button.
  Widget _previousButton() {
    return IgnorePointer(
      ignoring: prenext == 0,
      child: IconButton(
        visualDensity: VisualDensity.compact,
        icon: widget.previousButtonIcon ??
            Icon(
              widget.direction == Axis.horizontal ? Icons.arrow_left : Icons.arrow_drop_up,
            ),
         onPressed:() async{
          await _goPrevious();
        }
       // onPressed:_goPrevious,
       // onPressed: _goToPreviousStep,
      ),
    );
  }

  /// The next button.
  Widget _nextButton() {
    return IgnorePointer(
      ignoring: prenext == widget.children!.length - 1,
      child: IconButton(
        visualDensity: VisualDensity.compact,
        icon: widget.nextButtonIcon ??
            Icon(
              widget.direction == Axis.horizontal ? Icons.arrow_right : Icons.arrow_drop_down,
            ),
        onPressed:() async{
          await _goNext();
        }
       // onPressed:_goNext,
       // onPressed: _goToNextStep,
      ),
    );
  }
  
  
  
 Future _goNext() async{
   if(prenext<widget.children!.length){
   prenext=prenext+1;}
   await controller.scrollToIndex(prenext, preferPosition: AutoScrollPosition.begin);
  
  /* itemScrollController.scrollTo(
  index: prenext,
  duration: widget.stepReachedAnimationDuration,
        curve: widget.stepReachedAnimationEffect);*/
  
   setState(() {
     print(prenext);
      });
 }

  Future _goPrevious() async{
    if(prenext>0){
   prenext=prenext-1;}
    await controller.scrollToIndex(prenext, preferPosition: AutoScrollPosition.begin);
 /*  itemScrollController.scrollTo(
  index: prenext,
  duration: widget.stepReachedAnimationDuration,
        curve: widget.stepReachedAnimationEffect);*/
    
    

    setState(() {
     print(prenext);
      });
    
 }
  
  
  /// Contains the logic for going to the next step.
  void _goToNextStep() {
    if (_selectedIndex < widget.children!.length - 1 && widget.steppingEnabled) {
      setState(() {
        _selectedIndex++;

        if (widget.onStepReached != null) {
          widget.onStepReached!(_selectedIndex);
        }
      });
    }
  }

  /// Controls the logic for going to the previous step.
  void _goToPreviousStep() {
    if (_selectedIndex > 0) {
      setState(() {
        _selectedIndex--;

        if (widget.onStepReached != null) {
          widget.onStepReached!(_selectedIndex);
        }
      });
    }
  }
}
