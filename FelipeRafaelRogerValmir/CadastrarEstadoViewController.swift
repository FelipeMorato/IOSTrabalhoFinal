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
        
        txtCotacao.delegate = self
        txtIof.delegate = self
        
        estadosTableView.dataSource = self
        estadosTableView.delegate = self
        
        lblMessageStatesEmpty.isHidden = true
        lblMessageStatesEmpty.text = ""
        lblMessageStatesEmpty.textColor = .lightGray
        
        loadStates()
        setupToolbar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        txtCotacao.text = ud.string(forKey: UserDefaultKeys.cotacao.rawValue)
        txtIof.text = ud.string(forKey: UserDefaultKeys.iof.rawValue)
        setupMessageEmpty()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        estadosTableView.reloadData()
    }
    
    func setupToolbar(){
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = .blue
        toolBar.sizeToFit()

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
        self.estadosTableView.reloadData()
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
            
            DispatchQueue.main.async {
                try? self.context.save()
            }
            
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
        let rows = fetchedResultsController.fetchedObjects?.count ?? 0
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = estadosTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            as? EstadoTableViewCell else {
                return UITableViewCell()
        }
        
        let newState = fetchedResultsController.object(at: indexPath)
      
        cell.prepare(with: newState)

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
        
        DispatchQueue.main.async {
            self.loadStates()
        }
    }
}

extension CadastrarEstadoViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == txtCotacao {
            let allowedCharacters = CharacterSet(charactersIn:".0123456789")
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        
        if textField == txtIof {
            let allowedCharacters = CharacterSet(charactersIn:".0123456789")
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        
        return true
    }
}
