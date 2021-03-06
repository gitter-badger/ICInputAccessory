//
//  ExampleViewController.swift
//  Example
//
//  Created by Ben on 07/03/2016.
//  Copyright © 2016 Polydice, Inc.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import UIKit
import ICInputAccessory

class ExampleViewController: UITableViewController {

  private let types: [UIView.Type] = [
    ICKeyboardDismissTextField.self,
    ICTokenField.self,
    CustomizedTokenField.self
  ]

  private lazy var flipButton: UIButton = {
    let _button = UIButton(type: .System)
    _button.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 88)
    _button.setTitle("Storyboard", forState: .Normal)
    _button.addTarget(self, action: .showStoryboard, forControlEvents: .TouchUpInside)
    return _button
  }()

  // MARK: - Initialization

  convenience init() {
    self.init(style: .Grouped)
    title = "ICInputAccessory"
  }

  // MARK: - UIViewController

  override func loadView() {
    super.loadView()
    tableView.registerClass(ExampleCell.self, forCellReuseIdentifier: NSStringFromClass(ExampleCell.self))
    tableView.tableFooterView = flipButton
    tableView.tableFooterView?.userInteractionEnabled
  }

  // MARK: - UITableViewDataSource

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return types.count
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }

  override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch types[section] {
    case is ICKeyboardDismissTextField.Type:
      return "Dismiss Keyboard"
    case is ICTokenField.Type:
      return "Text Field with Tokens"
    case is CustomizedTokenField.Type:
      return "Customize Token Field"
    default:
      return ""
    }
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(ExampleCell.self), forIndexPath: indexPath)
    switch types[indexPath.section] {
    case let type as ICKeyboardDismissTextField.Type:
      let textField = type.init()
      textField.leftViewMode = .Always
      textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
      textField.placeholder = String(type)
      (cell as? ExampleCell)?.showcase = textField

    case let type as CustomizedTokenField.Type:
      cell.textLabel?.text = String(type)
      cell.accessoryType = .DisclosureIndicator

    case let type as ICTokenField.Type:
      let container = UIView(frame: cell.bounds)
      let tokenField = type.init()
      tokenField.placeholder = String(type)
      tokenField.frame = container.bounds.insetBy(dx: 5, dy: 0)
      tokenField.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
      container.addSubview(tokenField)
      (cell as? ExampleCell)?.showcase = container

    default:
      break
    }
    return cell
  }

  // MARK: - UITableViewDelegate

  override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return types[indexPath.section] == CustomizedTokenField.self
  }

  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if types[indexPath.section] == CustomizedTokenField.self {
      presentViewController(UINavigationController(rootViewController: CustomizedTokenViewController()), animated: true, completion: nil)
    }
  }

  // MARK: - UIResponder Callbacks

  @objc private func showStoryboard(sender: UIButton) {
    if let controller = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateInitialViewController() {
      controller.modalTransitionStyle = .FlipHorizontal
      presentViewController(controller, animated: true, completion: nil)
    }
  }

}


////////////////////////////////////////////////////////////////////////////////


private extension Selector {
  static let showStoryboard = #selector(ExampleViewController.showStoryboard(_:))
}
