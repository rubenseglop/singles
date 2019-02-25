//
//  ViewController4.swift
//  Single
//
//  Created by Jorge & Ruben on 12/2/19.
//  Copyright © 2019 LocoColina. All rights reserved.
//
 
import UIKit
import SQLite3


class ViewController4: UIViewController,UITableViewDataSource {

    
    var db: OpaquePointer?
    var selSexo = ""
    var selProv = ""
    var datos: [[String]] = [[]]
    var datos2: [[String]] = [[]]
    var sexo = ""
    let headers:[String] = ["Nombre","Apellidos"]
        override func viewDidLoad() {
        super.viewDidLoad()
       
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("Single.sqlite")

        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        else {
            print("base abierta")
            if sqlite3_exec(db, "DROP TABLE Usuario", nil, nil, nil) != SQLITE_OK {
                _ = String(cString: sqlite3_errmsg(db)!)
                print("error al borrar la base de datos")
            }else {print("BASE BORRADA")}
            
            if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Usuario (foto TEXT PRIMARY KEY, nombre TEXT, apellidos TEXT, sexo TEXT, provincia TEXT)", nil, nil, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error creating table: \(errmsg)")
            }
        }
         insertaDatos()
         muestraDatos()
        print("nuevo " + selSexo)
    }
   
    @IBAction func Volver(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func insertaDatos(){
        
        //crear las tablas e insertar datos
        
        var stmt: OpaquePointer?
        
        var queryString = "INSERT INTO Usuario (foto, nombre , apellidos , sexo , provincia ) VALUES ('http://iesayala.ddns.net/singles/1.jpg', 'Ana','Sánchez', 'Mujer', 'Granada')"
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            mostrarAlerta(titulo: "Error",mensaje: "Error DB",comentario: "error preparing insert")
            return
        }
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting Usuario: \(errmsg)")
            return
        } else {
            print ("insertado Ana")
        }
        
        queryString = "INSERT INTO Usuario (foto, nombre , apellidos , sexo , provincia ) VALUES ('http://iesayala.ddns.net/singles/2.jpg', 'Beatriz','Pérez', 'Mujer', 'Cádiz')"
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            mostrarAlerta(titulo: "Error",mensaje: "Error DB",comentario: "error preparing insert")
            return
        }
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting Usuario: \(errmsg)")
            return
        } else {
            print ("insertada Beatriz")
        }
        queryString = "INSERT INTO Usuario (foto, nombre , apellidos , sexo , provincia ) VALUES ('http://iesayala.ddns.net/singles/3.jpg', 'Claudia','Fernández', 'Mujer', 'Málaga')"
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            mostrarAlerta(titulo: "Error",mensaje: "Error DB",comentario: "error preparing insert")
            return
        }
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting Usuario: \(errmsg)")
            return
        } else {
            print ("con exito insertado")
        }
            queryString = "INSERT INTO Usuario (foto, nombre , apellidos , sexo , provincia ) VALUES ('http://iesayala.ddns.net/singles/4.jpg', 'José Luis','Melchor', 'Hombre', 'Huelva')"
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            mostrarAlerta(titulo: "Error",mensaje: "Error DB",comentario: "error preparing insert")
            return
        }
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting Usuario: \(errmsg)")
        } else {
            print ("con exito insertado")
        }
        queryString = "INSERT INTO Usuario (foto, nombre , apellidos , sexo , provincia ) VALUES ('http://iesayala.ddns.net/singles/5.jpg', 'Manuel','López', 'Hombre', 'Sevilla')"
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            mostrarAlerta(titulo: "Error",mensaje: "Error DB",comentario: "error preparing insert")
            return
        }
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting Usuario: \(errmsg)")
            return
        } else {
            print ("con exito insertado")
        }
        queryString = "INSERT INTO Usuario (foto, nombre , apellidos , sexo , provincia ) VALUES ('http://iesayala.ddns.net/singles/6.jpg', 'Alfonso','XII', 'Hombre', 'Granada')"
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            mostrarAlerta(titulo: "Error",mensaje: "Error DB",comentario: "error preparing insert")
            return
        }
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting Usuario: \(errmsg)")
            return
        } else {
            print ("con exito insertado")
        }
        queryString = "INSERT INTO Usuario (foto, nombre , apellidos , sexo , provincia ) VALUES ('http:iesayala.ddns.net/singles/7.jpg', 'Isabel','Molina', 'Mujer', 'Jaén')"
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            mostrarAlerta(titulo: "Error",mensaje: "Error DB",comentario: "error preparing insert")
            return
        }
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting Usuario: \(errmsg)")
            return
        } else {
            print ("con exito insertado")
        }
    }
    
    func muestraDatos() {
        //this is our select query
        datos.removeAll()
        var queryString = ""
        
        if selProv == "Todas" && selSexo == "Otra Cosa"{
            queryString = "SELECT * FROM Usuario"
        }
        else if selSexo == "Otra Cosa" {
            queryString = "SELECT * FROM Usuario WHERE provincia = '\(selProv)' "
        }
        else if selProv == "Todas"{
            queryString = "SELECT * FROM Usuario WHERE sexo = '\(selSexo)' "

        }
        else{
            queryString = "SELECT * FROM Usuario WHERE sexo = '\(selSexo)' and provincia = '\(selProv)' "
        }
        print(queryString)
        //statement pointer
        var stmt:OpaquePointer?
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
        }
        
        //traversing through all the records
     
          while(sqlite3_step(stmt) == SQLITE_ROW){
            let nombre = String(cString: sqlite3_column_text(stmt, 1))
            let apellido = String(cString: sqlite3_column_text(stmt, 2))
            let foto = String(cString: sqlite3_column_text(stmt, 0))
            sexo = String(cString: sqlite3_column_text(stmt, 3))
            let a = Data(nombre: String(describing: nombre), apellido: String(describing:apellido), foto: String(describing:foto), sexo: String(describing:sexo))
            datos.append(([a.nombre! + " " + a.apellido!]))
          
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)->Int{
        return datos[section].count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return datos.count
    }
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return headers[section]
//    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)-> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = datos[indexPath.section][indexPath.row]
        cell.detailTextLabel?.text = sexo
        //cell.detailTextLabel?.text = subs[indexPath.section] [indexPath.row]
        if selSexo == "Mujer" {
            cell.imageView?.image = UIImage(named: "mujer.png")
       }
        else if selSexo == "Hombre"{
           cell.imageView?.image = UIImage(named: "hombre.png")

        }else {
            cell.imageView?.image = UIImage(named: "homb1re.png")
            print ("sexo o = " + selSexo)
            
        }
        return cell
    }
    
    func mostrarAlerta(titulo: String,mensaje: String,comentario: String) {
        let alert = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: comentario), style: .`default`, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
}
class Data{
    var nombre:String?
    var apellido: String?
    var foto: String?
    var sexo: String?
    
    init(nombre : String?, apellido: String?, foto: String?,sexo: String?){
        self.nombre = nombre
        self.apellido = apellido
        self.foto = foto
        self.sexo = sexo
    }
    
}



