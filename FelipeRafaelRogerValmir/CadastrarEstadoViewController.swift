//
//  CadastrarEstadoViewController.swift
//  FelipeRafaelRogerValmir
//
//  Created by iterative on 21/04/20.
//  Copyright © 2020 FelipeRafaelRogerValmir. All rights reserved.
//

import UIKit
import CoreData

class CadastrarEstadoViewController: UIViewController {

    @IBOutlet weak var txtCotacao: UITextField!
    @IBOutlet weak var txtIof: UITextField!
    @IBOutlet weak var estadosTableView: UITableView!
    
    let ud = UserDefaults.standard
    var estado: Estado?
    var estados: [Estado] = []
    var fetchedResultsController: NSFetchedResultsController<Estado>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        txtCotacao.text = ud.string(forKey: UserDefaultKeys.cotacao.rawValue)
        txtIof.text = ud.string(forKey: UserDefaultKeys.iof.rawValue)
        
        self.estadosTableView.dataSource = self
        self.estadosTableView.delegate = self
        
        loadStates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        txtCotacao.text = ud.string(forKey: UserDefaultKeys.cotacao.rawValue)
        txtIof.text = ud.string(forKey: UserDefaultKeys.iof.rawValue)
    }
    
    func loadStates() {
    
        let fetchRequest: NSFetchRequest<Estado> = Estado.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "nome", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
                
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        estados = fetchedResultsController.fetchedObjects!
    }

    @IBAction func AdicionarEstado(_ sender: Any) {
        let alert = UIAlertController(title: "Adicionar Estado", message: "", preferredStyle: .alert)
        
        alert.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Nome do estado"
        }
        
        alert.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Imposto"
        }
       
        let cancelAction = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
        alert.addAction(cancelAction)
       
        let okAction = UIAlertAction(title: "Adicionar", style: .default, handler: { [weak alert] (_) in
          
            if self.estado == nil {
                self.estado = Estado(context: self.context)
             }
             
            self.estado?.nome = alert?.textFields![0].text ?? ""
            
            let imposto = alert?.textFields![1].text ?? "0"
            
            self.estado?.imposto = Double(imposto)!
            
            try? self.context.save()
             
            self.estadosTableView.reloadData()
        })
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func txtChangeCotacao(_ sender: Any) {
        ud.set(txtCotacao.text!, forKey: UserDefaultKeys.cotacao.rawValue)
    }
    
    @IBAction func txtChangeIof(_ sender: Any) {
        ud.set(txtIof.text!, forKey: UserDefaultKeys.iof.rawValue)
    }
}

enum UserDefaultKeys: String {
    case cotacao = "cotacao"
    case iof = "iof"
}

extension CadastrarEstadoViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return estados.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = self.estadosTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            as? EstadoTableViewCell else {
                return UITableViewCell()
        }
        
        let estado = fetchedResultsController.object(at: indexPath)
        
        cell.prepare(with: estado)

        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let estado = fetchedResultsController.object(at: indexPath)
            context.delete(estado)
            
            try? context.save()
            
        }
    }
}

extension CadastrarEstadoViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        self.estadosTableView.reloadData()
    }
}
