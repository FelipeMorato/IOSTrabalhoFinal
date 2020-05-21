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
    @IBOutlet weak var lblMessageStatesEmpty: UILabel!
    
    let ud = UserDefaults.standard
    var estado: Estado?
    var estados: [Estado] = []
    var fetchedResultsController: NSFetchedResultsController<Estado>!
    var fetchedResultsControllerCompra: NSFetchedResultsController<Compra>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        txtCotacao.text = ud.string(forKey: UserDefaultKeys.cotacao.rawValue)
        txtIof.text = ud.string(forKey: UserDefaultKeys.iof.rawValue)
        
        self.estadosTableView.dataSource = self
        self.estadosTableView.delegate = self
        
        self.lblMessageStatesEmpty.isHidden = true
        self.lblMessageStatesEmpty.text = ""
        self.lblMessageStatesEmpty.textColor = .lightGray
        
        loadStates()
        setupToolbar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        txtCotacao.text = ud.string(forKey: UserDefaultKeys.cotacao.rawValue)
        txtIof.text = ud.string(forKey: UserDefaultKeys.iof.rawValue)
        setupMessageEmpty()
    }
    
    func setupToolbar(){
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = .blue// UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()

        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "OK", style: .plain, target: self, action: #selector(doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancelar", style: .plain, target: self, action: #selector(cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        txtIof.inputAccessoryView = toolBar
        txtCotacao.inputAccessoryView = toolBar
    }
    
    @objc func doneClick() {
           txtIof.resignFirstResponder()
           txtCotacao.resignFirstResponder()
       }
       
       @objc func cancelClick() {
           txtIof.resignFirstResponder()
           txtCotacao.resignFirstResponder()
       }
    
    func loadStates() {
    
        let fetchRequest: NSFetchRequest<Estado> = Estado.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "nome", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
                
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        estados = fetchedResultsController.fetchedObjects!
        estadosTableView.reloadData()
        setupMessageEmpty()
    }
    
    func loadCompras() {
    
        let fetchRequest: NSFetchRequest<Compra> = Compra.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "nome", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
                
        fetchedResultsControllerCompra = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsControllerCompra.delegate = self
        try? fetchedResultsControllerCompra.performFetch()
    }
    
    func setupMessageEmpty() {
        if fetchedResultsController.fetchedObjects?.count == 0 {
            self.lblMessageStatesEmpty.isHidden = false
            self.lblMessageStatesEmpty.text = "Lista de estados vazia."
            self.lblMessageStatesEmpty.textAlignment = .center
            
            self.lblMessageStatesEmpty.translatesAutoresizingMaskIntoConstraints = false
            
            self.lblMessageStatesEmpty.topAnchor.constraint(equalTo: self.estadosTableView.topAnchor, constant: 120).isActive = true
            self.lblMessageStatesEmpty.centerXAnchor.constraint(equalTo: self.estadosTableView.centerXAnchor).isActive = true
            
        }
        else {
            self.lblMessageStatesEmpty.isHidden = true
            self.lblMessageStatesEmpty.text = ""
        }
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
                
            self.loadStates()
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
        return fetchedResultsController.fetchedObjects?.count ?? 0
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
            
            loadCompras()
            
            let compras = fetchedResultsControllerCompra.fetchedObjects!
            
            for compra in compras {
                if compra.estado == estado.nome {
                   context.delete(compra)
                   try? context.save()
               }
            }
            
            context.delete(estado)
            
            try? context.save()
            
            setupMessageEmpty()
        }
    }
}

extension CadastrarEstadoViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        estados = fetchedResultsController.fetchedObjects!
        self.estadosTableView.reloadData()
    }
}
