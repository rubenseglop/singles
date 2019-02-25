//
//  ViewControllertres.swift
//  Single
//
//  Created by Jorge on 5/2/19.
//  Copyright © 2019 LocoColina. All rights reserved.
//

import UIKit
import Foundation

class ViewControllertres: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate  {
    @IBOutlet weak var pic: UIPickerView!
    @IBOutlet weak var nombreFinal: UILabel!
    @IBOutlet weak var busqueda: UIButton!
    
    var nombreFi = ""
    var listaSexo = ["Hombre","Mujer","Otra Cosa"]
    var listaProvincias = ["Granada","Cádiz","Huelva","Córdoba","Sevilla","Málaga","Almería","Jaén", "Todas"]
    var selsexo = ""
    var selprov = ""
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0{
            return listaSexo.count
        }else{
            return listaProvincias.count
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.view.endEditing(true)
        if component == 0{
            return listaSexo[row]
        }else{
            return listaProvincias[row]
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
        self.selsexo = "\(listaSexo[row])"
        print (selsexo)
        }else{
        self.selprov = "\(listaProvincias[row])"
        print (selprov)
        }
        self.pic.isHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        nombreFinal.text = "Bienvenido " + nombreFi
        self.selsexo = self.listaSexo[0]
        self.selprov = self.listaProvincias[0]       

    }
    
    @IBAction func buscar(_ sender: Any) {
        let viewController = self.storyboard!.instantiateViewController(withIdentifier: "cuatro") as! ViewController4
        print ("enviando " + selsexo + " y " + selprov)
        performSegue(withIdentifier: "data", sender: self)
        //performSegue(withIdentifier: "data", sender: self)
        self.present(viewController,animated: true, completion:nil)
    }
    
    @IBAction func salir(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ViewController4
        vc.selSexo = self.selsexo
        vc.selProv = self.selprov
    }
}
