//
//  SideMenuViewController.swift
//  Cliente
//
//  Created by Everton Luiz Pascke on 07/09/17.
//  Copyright © 2017 Wasys. All rights reserved.
//

import UIKit

class Menu {
    var id: Int
    var icon: UIImage
    var label: String
    init(id: Int, icon: UIImage, label: String) {
        self.id = id
        self.icon = icon
        self.label = label
    }
}

class SideMenuViewController: CheqfastViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var nomeLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!

    fileprivate var menus = [Int: [Menu]]()
    fileprivate var headers = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepare()
    }
}

extension SideMenuViewController {
    
    fileprivate func prepare() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        prepareMenu()
        prepareHeader()
    }
    
    fileprivate func prepareMenu() {
        var value: [Menu]
        // SECTION PROCESSO
        headers.append(TextUtils.localized(forKey: "Menu.Processo"))
        value = [
            Menu(id: 1, icon: Icon.addToPhotos!, label: TextUtils.localized(forKey: "Menu.Novo")),
            Menu(id: 2, icon: Icon.warning!, label: TextUtils.localized(forKey: "Menu.Pendencia")),
            Menu(id: 3, icon: Icon.search!, label: TextUtils.localized(forKey: "Menu.Pesquisa")),
            Menu(id: 4, icon: Icon.wifiTethering!, label: TextUtils.localized(forKey: "Menu.Consulta")),
            Menu(id: 5, icon: Icon.dataUsage!, label: TextUtils.localized(forKey: "Menu.Simulador")),
            Menu(id: 6, icon: Icon.person!, label: TextUtils.localized(forKey: "Menu.MeusDados"))
        ]
        menus[0] = value
        // SECTION APLICATIVO
        headers.append(TextUtils.localized(forKey: "Menu.Aplicativo"))
        value = [
            Menu(id: 1, icon: Icon.info!, label: TextUtils.localized(forKey: "Menu.Sobre")),
            Menu(id: 2, icon: Icon.description!, label: TextUtils.localized(forKey: "Menu.TermoUso")),
            Menu(id: 3, icon: Icon.powerSettingsNew!, label: TextUtils.localized(forKey: "Menu.Sair"))
        ]
        menus[1] = value
    }
    
    fileprivate func prepareHeader() {
        if let usuario = Usuario.current {
            ViewUtils.text(usuario.nome, for: nomeLabel)
            ViewUtils.text(usuario.email, for: emailLabel)
        }
    }
    
    fileprivate func sair() {
        Dispositivo.current = nil
        let controller = UIStoryboard.viewController("Main", identifier: "Scene.Start")
        self.present(controller, animated: true, completion: nil)
    }
    
    fileprivate func onSairPressed() {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: TextUtils.localized(forKey: "Label.Sair"),
                message: TextUtils.localized(forKey: "Message.SairAplicativo"),
                preferredStyle: UIAlertControllerStyle.actionSheet
            )
            alert.addAction(UIAlertAction(
                title: TextUtils.localized(forKey: "Label.Sim"),
                style: UIAlertActionStyle.default,
                handler: { (action: UIAlertAction!) in
                    self.sair()
                }
            ))
            alert.addAction(UIAlertAction(
                title: TextUtils.localized(forKey: "Label.Nao"),
                style: UIAlertActionStyle.cancel,
                handler: nil
            ))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    fileprivate func close(completion: @escaping () -> Void) {
        let when = DispatchTime.now() + 0.3
        DispatchQueue.main.asyncAfter(deadline: when) {
            completion()
        }
    }
    
    fileprivate func onMenuTapped(_ indexPath: IndexPath) {
        let section = indexPath.section
        if let menu = menus[section]?[indexPath.row] {
            let id = menu.id
            var controller: UIViewController? = nil
            // SECTION PROCESSO
            if section == 0 {
                switch id {
                case 1:
                    controller = UIStoryboard.viewController("Menu", identifier: "Nav.Novo")
                case 2:
                    controller = UIStoryboard.viewController("Menu", identifier: "Nav.Pesquisa")
                    if let navigation = controller as? UINavigationController {
                        if let firstController = navigation.viewControllers.first as? ProcessoPesquisaViewController {
                            firstController.status = .pendente
                        }
                    }
                case 3:
                    controller = UIStoryboard.viewController("Menu", identifier: "Nav.Pesquisa")
                case 4:
                    controller = UIStoryboard.viewController("Menu", identifier: "Nav.Consulta")
                case 5:
                    controller = UIStoryboard.viewController("Menu", identifier: "Nav.Simulador")
                case 6:
                    controller = UIStoryboard.viewController("Menu", identifier: "Nav.MeusDados")
                default:
                    break
                }
            // SECTION APLICATIVO
            } else if section == 1 {
                switch id {
                case 1:
                    controller = UIStoryboard.viewController("Menu", identifier: "Nav.Sobre")
                case 2:
                    controller = UIStoryboard.viewController("Menu", identifier: "Nav.Termo")
                case 3:
                    onSairPressed()
                default:
                    break
                }
            }
            if controller != nil {
                revealViewController().pushFrontViewController(controller!, animated: true)
            }
        }
    }
}

extension SideMenuViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onMenuTapped(indexPath)
    }
}

extension SideMenuViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return headers.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus[section]!.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headers[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath) as! MenuTableViewCell
        let menu = menus[indexPath.section]![indexPath.row]
        cell.populate(menu)
        return cell
    }
}
