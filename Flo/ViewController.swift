//
//  ViewController.swift
//  Flo
//
//  Created by Caroline Begbie on 15/04/2015.
//  Copyright (c) 2015 Caroline Begbie. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  //Label outlets
  @IBOutlet weak var averageWaterDrunk: UILabel!
  @IBOutlet weak var maxLabel: UILabel!
  
  var isGraphViewShowing = false
  
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var graphView: GraphView!
  
  //Counter outlets
  @IBOutlet weak var counterView: CounterView!
  @IBOutlet weak var counterLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    counterLabel.text = String(counterView.counter)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBAction func btnPushButton(button: PushButtonView) {
    if button.isAddButton {
      counterView.counter++
    } else {
      if counterView.counter > 0 {
        counterView.counter--
      }
    }
    counterLabel.text = String(counterView.counter)
    if isGraphViewShowing {
      counterViewTap(nil)
    }
  }
  
  @IBAction func counterViewTap(gesture:UITapGestureRecognizer?) {
    if (isGraphViewShowing) {
      
      //hide Graph
      UIView.transitionFromView(graphView,
        toView: counterView,
        duration: 1.0,
        options: [UIViewAnimationOptions.TransitionFlipFromLeft, UIViewAnimationOptions.ShowHideTransitionViews],
        completion:nil)
    } else {
      
      //show Graph
      
      setupGraphDisplay()

      UIView.transitionFromView(counterView,
        toView: graphView,
        duration: 1.0,
        options: [UIViewAnimationOptions.TransitionFlipFromRight, UIViewAnimationOptions.ShowHideTransitionViews],
        completion: nil)
    }
    isGraphViewShowing = !isGraphViewShowing
  }
  
  func setupGraphDisplay() {
    
    //Use 7 days for graph - can use any number,
    //but labels and sample data are set up for 7 days
    let noOfDays:Int = 7
    
    //1 - replace last day with today's actual data
    graphView.graphPoints[graphView.graphPoints.count-1] = counterView.counter
    
    //2 - indicate that the graph needs to be redrawn
    graphView.setNeedsDisplay()
    
    maxLabel.text = "\(graphView.graphPoints.maxElement()!)"
    
    //3 - calculate average from graphPoints
    let average = graphView.graphPoints.reduce(0, combine: +)
      / graphView.graphPoints.count
    averageWaterDrunk.text = "\(average)"
    
    //set up labels
    //day of week labels are set up in storyboard with tags
    //today is last day of the array need to go backwards
    
    //4 - get today's day number
    let dateFormatter = NSDateFormatter()
    let calendar = NSCalendar.currentCalendar()
    let componentOptions:NSCalendarUnit = .Weekday
    let components = calendar.components(componentOptions,
      fromDate: NSDate())
    var weekday = components.weekday
    
    let days = ["S", "S", "M", "T", "W", "T", "F"]
    
    //5 - set up the day name labels with correct day
    for i in Array((1...days.count).reverse()) {
      if let labelView = graphView.viewWithTag(i) as? UILabel {
        if weekday == 7 {
          weekday = 0
        }
        labelView.text = days[weekday--]
        if weekday < 0 {
          weekday = days.count - 1
        }
      }
    }
  }
}

