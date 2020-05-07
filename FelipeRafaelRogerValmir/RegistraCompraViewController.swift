//
//  RegistraCompraViewController.swift
//  FelipeRafaelRogerValmir
//
//  Created by iterative on 21/04/20.
//  Copyright © 2020 FelipeRafaelRogerValmir. All rights reserved.
//

import UIKit
import CoreData

class RegistraCompraViewController: UIViewController {

    @IBOutlet weak var txtNomeProduto: UITextField!
    @IBOutlet weak var btnSelectImage: UIButton!
    @IBOutlet weak var txtEstadoCompra: UITextField!
    @IBOutlet weak var txtValor: UITextField!
    @IBOutlet weak var btnCadastraEstado: UIButton!
    @IBOutlet weak var swtPagamentoCartao: UISwitch!
    @IBOutlet weak var ivProduto: UIImageView!
    
    var compra: Compra?
    var estados: [Estado] = []
    
    var fetchedResultsController: NSFetchedResultsController<Estado>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Cadastrar Produto"
        self.swtPagamentoCartao.isOn = true
        self.ivProduto.isHidden = true
        self.btnSelectImage.isHidden = false
        
        setupForPickerView()
        
        loadStates()
        
        self.view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadStates()
    }
    
    func setupForPickerView() {
        var statePickerView: UIPickerView
        statePickerView = UIPickerView(frame: CGRect(x:0, y:50, width: view.frame.width, height: 250))
        statePickerView.backgroundColor = .gray

        statePickerView.showsSelectionIndicator = true
        statePickerView.delegate = self
        statePickerView.dataSource = self

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
        
        self.txtEstadoCompra.inputAccessoryView = toolBar
        
        self.txtEstadoCompra.inputView = statePickerView
    }
    
    @objc func doneClick() {
        txtEstadoCompra.resignFirstResponder()
    }
    
    @objc func cancelClick() {
        txtEstadoCompra.resignFirstResponder()
    }
    
    func loadStates() {
        
        let fetchRequest: NSFetchRequest<Estado> = Estado.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "nome", ascending: true)
         fetchRequest.sortDescriptors = [sortDescriptor]
                
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil) as? NSFetchedResultsController<Estado>
        
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
    }
    
    func selectPicture(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func btnSelectImage(_ sender: Any) {
        let alert = UIAlertController(title: "Selecionar poster", message: "De onde você deseja escolher o poster?", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Câmera", style: .default) { (_) in
                self.selectPicture(sourceType: .camera)
            }
            alert.addAction(cameraAction)
        }
        
        let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default) { (_) in
            self.selectPicture(sourceType: .photoLibrary)
        }
        alert.addAction(libraryAction)
        
        let photosAction = UIAlertAction(title: "Álbum de fotos", style: .default) { (_) in
            self.selectPicture(sourceType: .savedPhotosAlbum)
        }
        alert.addAction(photosAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        
        var valid = true
        var messages = [String]()
        
        if txtNomeProduto.text == "" {
            valid = false
            messages.append("Informe o nome produto.")
        }
        
        if txtValor.text == ""{
            valid = false
            messages.append("Informe o valor produto.")
        }
        
        if txtEstadoCompra.text == ""{
            valid = false
            messages.append("Informe o estado da compra do produto.")
        }
        
        if ivProduto.image == nil {
            valid = false
            messages.append("Selecione a imagem do produto.")
        }
        
        var errorMessages: String = ""
        
        for erro in messages {
            errorMessages = errorMessages + erro + "\n"
        }
        
        if !valid {
            let alert = UIAlertController(title: "", message: errorMessages, preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(cancelAction)
            
            present(alert, animated: true, completion: nil)
        }
        
        if compra == nil {
            compra = Compra(context: context)
        }
        
        compra?.comCartao = swtPagamentoCartao.isOn
        compra?.estado = txtEstadoCompra.text
        compra?.nome = txtNomeProduto.text
        compra?.valor = Double(txtValor.text!) ?? 0
        compra?.imagem = ivProduto.image
        
        try? context.save()
        
        self.txtValor.text = ""
        self.txtNomeProduto.text = ""
        self.txtEstadoCompra.text = ""
        self.btnSelectImage.isHidden = false
        self.ivProduto.isHidden = true
        self.swtPagamentoCartao.isOn = true
    }
    
}

extension RegistraCompraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let image = info[.originalImage] as? UIImage {
        ivProduto.image = image
        ivProduto.isHidden = false
        btnSelectImage.isHidden = true
    }
        dismiss(animated: true, completion: nil)
    }
}

extension RegistraCompraViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return estados.count 
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtEstadoCompra.text = estados[row].nome ?? ""
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return estados[row].nome
    }
}

extension RegistraCompraViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        estados = fetchedResultsController.fetchedObjects!
    }
}