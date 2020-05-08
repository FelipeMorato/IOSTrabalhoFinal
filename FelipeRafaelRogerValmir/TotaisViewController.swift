//
//  TotaisViewController.swift
//  FelipeRafaelRogerValmir
//
//  Created by iterative on 07/05/20.
//  Copyright © 2020 FelipeRafaelRogerValmir. All rights reserved.
//

import UIKit
import CoreData

class TotaisViewController: UIViewController {

    @IBOutlet weak var lblTotalUSA: UILabel!
    @IBOutlet weak var lblTotalBRA: UILabel!
    
    let ud = UserDefaults.standard
    var cotacao: Double = 0
    var iof: Double = 0
    var totalCompraUSA: Double = 0
    var totalComrasBRA: Double = 0
    
    var fetchedResultsControllerCompra: NSFetchedResultsController<Compra>!
    var fetchedResultsControllerEstado: NSFetchedResultsController<Estado>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblTotalUSA.textColor = .red
        self.lblTotalBRA.textColor = .green
        
        self.lblTotalUSA.text = "0"
        self.lblTotalBRA.text = "0"
       
        loadStates()
        loadCompras()
        loadParameterBundle()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        loadStates()
        loadCompras()
        loadParameterBundle()
        loadTotais()
    }
    
    func loadTotais(){
        totalUSA()
        totalBRA()
    }
    
    func totalUSA() {
        let compras = fetchedResultsControllerCompra.fetchedObjects!
        
        for item in compras {
            self.totalCompraUSA += item.valor
        }
        
        self.lblTotalUSA.text = String(format: "%.2f", self.totalCompraUSA)
        self.totalCompraUSA = 0
    }
    
    func totalBRA(){
        let compras = fetchedResultsControllerCompra.fetchedObjects!
        let estados = fetchedResultsControllerEstado.fetchedObjects!
        for item in compras {
            
            var valImposto: Double = 0
            
            for estado in estados {
                if item.estado == estado.nome {
                    valImposto = estado.imposto
                }
            }
            
            let valorComCotacao = (item.valor + (item.valor * (valImposto / 100))) * self.cotacao
            
            if(item.comCartao) {
                self.totalComrasBRA += valorComCotacao + (valorComCotacao * (self.iof / 100))
            }
            else {
                self.totalComrasBRA += valorComCotacao
            }
        }
        
        self.lblTotalBRA.text = String(format: "%.2f", self.totalComrasBRA)
        self.totalComrasBRA = 0
    }
    
    func loadCompras() {
        let fetchRequest: NSFetchRequest<Compra> = Compra.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "nome", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
            
        fetchedResultsControllerCompra = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)

        fetchedResultsControllerCompra.delegate = self
        try? fetchedResultsControllerCompra.performFetch()
    }
    
    func loadStates() {
    
        let fetchRequest: NSFetchRequest<Estado> = Estado.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "nome", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
                
        fetchedResultsControllerEstado = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsControllerEstado.delegate = self
        try? fetchedResultsControllerEstado.performFetch()
       
    }
    
    func loadParameterBundle(){
        self.cotacao = ud.double(forKey: UserDefaultKeys.cotacao.rawValue)
        self.iof = ud.double(forKey: UserDefaultKeys.iof.rawValue)
    }

}

extension TotaisViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        
    }
}
