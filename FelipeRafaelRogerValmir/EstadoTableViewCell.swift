//
//  EstadoTableViewCell.swift
//  FelipeRafaelRogerValmir
//
//  Created by iterative on 02/05/20.
//  Copyright © 2020 FelipeRafaelRogerValmir. All rights reserved.
//

import UIKit

class EstadoTableViewCell: UITableViewCell {

    @IBOutlet weak var lblNomeEstado: UILabel!
    @IBOutlet weak var lblImpostoEstado: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func prepare(with estado: Estado) {
        
        self.lblNomeEstado.text = estado.nome
        self.lblImpostoEstado.text = estado.imposto
    }

}
