//
//  ViewController.swift
//  SQliteDemo
//
//  Created by My MAC on 4/3/20.
//  Copyright © 2020 Bhavi Technologies Ltd. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    
    @IBOutlet weak var contactsTableView: UITableView!
    
    private var contacts = [Contact]()
    private var selectedContact: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contactsTableView.dataSource = self
        contactsTableView.delegate = self
        
        contacts = SQliteDB.instance.getContacts()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Button functions
    
    @IBAction func addButtonClicked() {
        let name = nameTextField.text ?? ""
        let phone = phoneTextField.text ?? ""
        let address = addressTextField.text ?? ""
        
        if let id = SQliteDB.instance.addContact(cname: name, cphone: phone, caddress: address) {
            let contact = Contact(id: id, name: name, phone: phone, address: address)
            contacts.append(contact)
            contactsTableView.insertRows(at: [(NSIndexPath(row: contacts.count-1, section: 0) as IndexPath)], with: .fade)
        }
    }
    
    func Search()
    {
        let id = contacts[selectedContact!].id!
        SQliteDB.instance.SearchContact(cid: id)
        
        
    }
    
    
    
    @IBAction func updateButtonClicked() {
       
        if selectedContact != nil {
            let id = contacts[selectedContact!].id!
            let contact = Contact(
                id: id,
                name: nameTextField.text ?? "",
                phone: phoneTextField.text ?? "",
                address: addressTextField.text ?? "")
            
            SQliteDB.instance.updateContact(cid: id, newContact: contact)
            contacts.remove(at: selectedContact!)
            contacts.insert(contact, at: selectedContact!)
            
            contactsTableView.reloadData()
        } else {
            print("No item selected")
        }
    }
    
    @IBAction func deleteButtonClicked() {
        if selectedContact != nil {
            SQliteDB.instance.deleteContact(cid: contacts[selectedContact!].id!)
            contacts.remove(at: selectedContact!)
            contactsTableView.deleteRows(at: [(NSIndexPath(row: selectedContact!, section: 0) as IndexPath)], with: .fade)
        } else {
        print("No item selected")
        }
    }

    // MARK: TableView functions
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        nameTextField.text = contacts[indexPath.row].name
        phoneTextField.text = contacts[indexPath.row].phone
        addressTextField.text = contacts[indexPath.row].address
        
        selectedContact = indexPath.row
    }
    

    func tableView (_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell")!
        var label: UILabel?
        label = cell.viewWithTag(1) as? UILabel // Name label
        label?.text = contacts[indexPath.row].name
        
        label = cell.viewWithTag(2) as? UILabel // Phone label
        label?.text = contacts[indexPath.row].phone
        
        return cell
    }
}

