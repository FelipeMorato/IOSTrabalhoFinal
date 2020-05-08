//
//  ListaComprasTableViewController.swift
//  FelipeRafaelRogerValmir
//
//  Created by iterative on 20/04/20.
//  Copyright © 2020 FelipeRafaelRogerValmir. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class ListaComprasTableViewController: UITableViewController {

    @IBOutlet weak var lblListaComprasVazia: UILabel!
    var fetchedResultsController: NSFetchedResultsController<Compra>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblListaComprasVazia.isHidden = true
        loadCompras()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadCompras()
    }
    
    func loadCompras() {
        let fetchRequest: NSFetchRequest<Compra> = Compra.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "nome", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
               
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
       
       fetchedResultsController.delegate = self
       try? fetchedResultsController.performFetch()
        
        
        if fetchedResultsController.fetchedObjects?.count == 0 {
            
            lblListaComprasVazia.isHidden = false
            lblListaComprasVazia.text = "Sua lista está vazia!"
            lblListaComprasVazia.textAlignment = .center
            lblListaComprasVazia.textColor = .lightGray
        
            //lblListaComprasVazia.topAnchor.constraint(equalTo: self.view.topAnchor, constant: -10).isActive = true
            //lblListaComprasVazia.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30).isActive = true
            //lblListaComprasVazia.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 30).isActive = true
            lblListaComprasVazia.centerYAnchor.constraint(equalTo: self.tableView.centerYAnchor).isActive = true
            lblListaComprasVazia.centerXAnchor.constraint(equalTo: self.tableView.centerXAnchor).isActive = true
        }
         
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ListaComprasTableViewCell else {
            return UITableViewCell()
        }

        let compra = fetchedResultsController.object(at: indexPath)
        
        cell.prepare(with: compra)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let compra = fetchedResultsController.object(at: indexPath)
            context.delete(compra)
            
            try? context.save()
            
        }
    }


    @IBAction func GoToAddCompra(_ sender: Any) {
        
        let addCompra = RegistraCompraViewController()
        self.navigationController?.pushViewController(addCompra, animated: true)
    }

}

extension ListaComprasTableViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        self.tableView.reloadData()
        
    }
}
