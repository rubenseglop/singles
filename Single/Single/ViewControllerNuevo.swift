//
//  ViewControllerNuevo.swift
//  Single
//
//  Created by LocoColina on 01/02/2019.
//  Copyright © 2019 LocoColina. All rights reserved.
//

import UIKit
import SQLite3


class ViewControllerNuevo: UIViewController {
    var db: OpaquePointer?
    
    @IBOutlet weak var login: UITextField!
    @IBOutlet weak var clave: UITextField!
    @IBOutlet weak var nombre: UITextField!
    @IBOutlet weak var apellidos: UITextField!
    @IBOutlet weak var sexo: UITextField!
    @IBOutlet weak var provincia: UITextField!
    @IBOutlet weak var limpiar: UIButton!
    @IBOutlet weak var aceptar: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("Single.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        else {
            print("base abierta")
            
//            if sqlite3_exec(db, "DROP TABLE Perfil", nil, nil, nil) != SQLITE_OK {
//                let errmsg = String(cString: sqlite3_errmsg(db)!)
//                print("error creating table: \(errmsg)")
//            }
            
            if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Perfil (id INTEGER PRIMARY KEY AUTOINCREMENT, login TEXT unique, clave TEXT, nombre TEXT, apellidos TEXT, sexo TEXT, provincia TEXT)", nil, nil, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error creating table: \(errmsg)")
            }
        }

        // Do any additional setup after loading the view.
    }
    
    @IBAction func limpiar(_ sender: Any) {
        login.text = ""
        clave.text = ""
        nombre.text = ""
        apellidos.text = ""
        sexo.text = ""
        provincia.text = ""
    }
    @IBAction func Volver(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func aceptar(_ sender: Any) {
        if (nombre.text?.count == 0 || clave.text?.count == 0 || nombre.text?.count == 0 || apellidos.text?.count == 0 || sexo.text?.count == 0 || provincia.text?.count == 0) {
            mostrarAlerta(titulo: "Error", mensaje: "Campos vacios", comentario: "Celda pulsada")
        }
        else {
            insertar()     // insertar los datos del perfil en la tabla
            self.dismiss(animated: true, completion: nil)
            
        }
    }
    func insertar() {
        var stmt: OpaquePointer?
        let queryString = "INSERT INTO Perfil (login , clave , nombre , apellidos , sexo , provincia ) VALUES ('"
        let end = login.text! + "', '" + clave.text! + "', '" + nombre.text! + "','" + apellidos.text! + "','" + sexo.text! + "','" + provincia.text! + "')"
        print (queryString + end)
        //preparing the query
        if sqlite3_prepare(db, queryString + end, -1, &stmt, nil) != SQLITE_OK{
            mostrarAlerta(titulo: "Error",mensaje: "Error DB",comentario: "error preparing insert")
            return
        }
        
        
        //executing the query to insert values
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting hero: \(errmsg)")
            return
        
        }
    }
    
    func mostrarAlerta(titulo: String,mensaje: String,comentario: String) {
        let alert = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: comentario), style: .`default`, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
}
class Perfil {
    var id: Int
    var login: String
    var clave: String
    var nombre: String
    var apellidos: String
    var sexo: String
    var provincia: String
    init (id: Int,login: String, clave: String,nombre: String,apellidos: String,sexo: String,provincia: String){
        self.id = id
        self.login = login
        self.clave = clave
        self.nombre = nombre
        self.apellidos = apellidos
        self.sexo = sexo
        self.provincia = provincia
    }
}
