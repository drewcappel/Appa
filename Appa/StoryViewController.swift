//
//  StoryViewController.swift
//  Appa
//
//  Created by Drew Cappel on 4/25/19.
//  Copyright © 2019 Drew Cappel. All rights reserved.
//

import UIKit
import Firebase

class StoryViewController: UIViewController {

    // IBOutlets
    @IBOutlet weak var siteNameLabel: UILabel!
    @IBOutlet weak var storyTitleField: UITextField!
    @IBOutlet weak var storyTextView: UITextView!
    @IBOutlet weak var postedByLabel: UILabel!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIButton!
    
    
    var site: Site!
    var story: Story!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)

        siteNameLabel.text = site.name
        
        if story == nil {
            story = Story()
        }
        
        updateUserInterface()

    }
    
    // Functions
    func addBordersToEditableObjects() {
        storyTitleField.addBorder(width: 0.5, radius: 5.0, color: .black)
        storyTextView.addBorder(width: 0.5, radius: 5.0, color: .black)
    }
    
    func enableDisableSaveButton() {
        if storyTextView.text != "" {
            saveBarButton.isEnabled = true
        } else {
            saveBarButton.isEnabled = false
        }
    }
    
    func updateUserInterface() {
        siteNameLabel.text = site.name
        
        storyTitleField.text = story.title
        storyTextView.text = story.story
        
        enableDisableSaveButton()
        
        if story.documentID == "" { // This is a new review
            addBordersToEditableObjects()
            postedByLabel.isHidden = true
            saveBarButton.isEnabled = true
        } else {
            if story.reviewerUserID == Auth.auth().currentUser?.email { // This review was posted by current user
                self.navigationItem.leftItemsSupplementBackButton = false
                saveBarButton.title = "Update"
                addBordersToEditableObjects()
                deleteButton.isHidden = false
            } else { // This review was posted by another user
                //cancelBarButton.title = ""
                saveBarButton.title = ""
                postedByLabel.text = "Posted by: \(story.reviewerUserID)"
                //storyTitleField.isEditing = false
                deleteButton.isHidden = true
            }
        }
    }
    
    func leaveViewController() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    func saveThenSegue() {
        story.title = storyTitleField.text!
        story.story = storyTextView.text!
        story.saveData(site: site) { (success) in
            if success {
                self.leaveViewController()
            } else {
                print("*** ERROR: Couldn't leave this view controller because data wasn't saved.")
            }
        }
    }

    
    
    // IBActions
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        leaveViewController()
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        saveThenSegue()
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        story.deleteData(site: site) { (success) in
            if success {
                self.leaveViewController()
            } else {
                print("ERROR: Delete unsuccessful")
            }
        }

    }
    
    
}
