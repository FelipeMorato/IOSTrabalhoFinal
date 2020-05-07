//
//  ListaComprasTableViewCell.swift
//  FelipeRafaelRogerValmir
//
//  Created by iterative on 21/04/20.
//  Copyright © 2020 FelipeRafaelRogerValmir. All rights reserved.
//

import UIKit

class ListaComprasTableViewCell: UITableViewCell {

    @IBOutlet weak var lblNomeProduto: UILabel!
    @IBOutlet weak var lblValorProduto: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func prepare(with compra: Compra) {
        
        self.lblNomeProduto.text = compra.nome
        self.lblValorProduto.text = "\(compra.valor)"
       
    }

}
