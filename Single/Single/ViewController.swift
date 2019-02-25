//
//  ViewController.swift
//  Single
//
//  Created by LocoColina on 01/02/2019.
//  Copyright © 2019 LocoColina. All rights reserved.
//

import UIKit
import SQLite3

class ViewController: UIViewController {
    
    var db: OpaquePointer?
    var entradaok : Bool?
    @IBOutlet weak var login: UITextField!
    @IBOutlet weak var clave: UITextField!
    @IBOutlet weak var acceder: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("Single.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        else {
            print("base abierta")
        }
    }
    
    @IBAction func accedeRegistro(_ sender: Any) {
        let viewController2 = self.storyboard!.instantiateViewController(withIdentifier: "dos") as! ViewControllerNuevo
        self.present(viewController2,animated: true, completion:nil)

    }
    
    @IBAction func comprueba_acceder(_ sender: Any) {
        //this is our select query
        print ("boton acceder")
        let queryString = "SELECT * FROM Perfil"
        
        //statement pointer
        var stmt:OpaquePointer?
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        //traversing through all the records
        entradaok = false;
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let plogin = String(cString: sqlite3_column_text(stmt, 1))
            let pclave = String(cString: sqlite3_column_text(stmt, 2))
            if (plogin == login.text && pclave == clave.text) {entradaok = true}
        }
        if entradaok == true {//acceder a la otra página
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: "tres") as! ViewControllertres
            performSegue(withIdentifier: "nombre", sender: self)
            self.present(viewController,animated: true, completion:nil)
            
        }else {
            mostrarAlerta(titulo: "Error", mensaje: "Clave incorrecta", comentario: "No se pudo entrar en su cuenta")
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ViewControllertres
        vc.nombreFi = self.login.text!
    }
    func mostrarAlerta(titulo: String,mensaje: String,comentario: String) {
        let alert = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: comentario), style: .`default`, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
}
