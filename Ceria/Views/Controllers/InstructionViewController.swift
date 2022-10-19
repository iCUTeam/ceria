//
//  InstructionViewController.swift
//  Ceria
//
//  Created by Kevin Gosalim on 12/10/22.
//

import UIKit

class InstructionViewController: UIViewController, Storyboarded {

    weak var coordinator: MainCoordinator?
    private let checkbox = Checkbox()
    
    private lazy var homeButton: MakeButton = {
        let button = MakeButton(image: "home.png", size: CGSize(width: 100, height: 100))
        button.addTarget(self, action: #selector(homeTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var startStoryButton: MakeButton = {
        let button = MakeButton(image: "startstory.png", size: CGSize(width: 290, height: 78))
        button.addTarget(self, action: #selector(startStoryTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var background: UIView = {
        let background = UIView()
        background.backgroundColor = UIColor(red: 253.0/255, green: 248.0/255, blue: 235.0/255, alpha: 1)
        return background
    }()
        
    private lazy var instructionStackView: UIStackView = {
        
        //MARK: Persiapan Bermain
        let labelHalaman = UILabel()
        labelHalaman.text = "Persiapan Bermain"
        labelHalaman.font = UIFont.scriptFont(size: 64)
        labelHalaman.textAlignment = .center
        labelHalaman.heightAnchor.constraint(equalToConstant: 110).isActive = true
        
        //MARK: Langkah 1
        let labelLangkahSatu = UILabel()
        labelLangkahSatu.text = "Langkah"
        labelLangkahSatu.textColor = .white
        labelLangkahSatu.textAlignment = .center
        labelLangkahSatu.font = UIFont.scriptFont(size: 30)
        labelLangkahSatu.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        let labelSatu = UILabel()
        labelSatu.text = "1"
        labelSatu.textColor = .white
        labelSatu.textAlignment = .center
        labelSatu.font = UIFont.scriptFont(size: 60)
        
        let stackLabelSatu = UIStackView(arrangedSubviews: [labelLangkahSatu, labelSatu])
        stackLabelSatu.axis = .vertical
        stackLabelSatu.distribution = .fill
        stackLabelSatu.backgroundColor = UIColor(red: 69.0/255, green: 173.0/255, blue: 226.0/225, alpha: 1)
        stackLabelSatu.layer.cornerRadius = 20
        stackLabelSatu.widthAnchor.constraint(equalToConstant: 177).isActive = true
        
        //MARK: Perintah 1
        let judulSatu = UILabel()
        judulSatu.text = "Cetak Kartu Permainan"
        judulSatu.textAlignment = .left
        judulSatu.font = UIFont.scriptFont(size: 25)
        judulSatu.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        let perintahSatu = UILabel()
        perintahSatu.text = "Permainan ini membutuhkan kartu fisik yang dicetak\nberwarna. Instruksi bermain dan kartu permainan bisa\ndiunduh dengan menekan link di bawah ini."
        perintahSatu.textAlignment = .left
        perintahSatu.font = UIFont.scriptFont(size: 20)
        perintahSatu.heightAnchor.constraint(equalToConstant: 75).isActive = true
        perintahSatu.numberOfLines = 0
        
        let linkInstruksi = UILabel()
        linkInstruksi.text = "Instruksi & Kartu Permainan"
        linkInstruksi.font = UIFont.scriptFont(size: 20)
        linkInstruksi.underline()
        
        //MARK: Clickable Link Label
        linkInstruksi.isUserInteractionEnabled = true
        let tapgesture = UITapGestureRecognizer.init(target: self, action: #selector(instructionClicked))
        tapgesture.numberOfTapsRequired = 1
        linkInstruksi.addGestureRecognizer(tapgesture)
        
        //MARK: Perintah 1 Stack Vertical
        let stackPerintahSatu = UIStackView(arrangedSubviews: [judulSatu, perintahSatu, linkInstruksi])
        stackPerintahSatu.axis = .vertical
        stackPerintahSatu.alignment = .leading
        stackPerintahSatu.distribution = .fill
        
        //MARK: Instruksi 1 Stack Horizontal
        let stackInstruksiSatu = UIStackView(arrangedSubviews: [stackLabelSatu, stackPerintahSatu])
        stackInstruksiSatu.axis = .horizontal
        stackInstruksiSatu.backgroundColor = UIColor(red: 242.0/255, green: 205.0/255, blue: 93.0/255, alpha: 1)
        stackInstruksiSatu.spacing = 20
        stackInstruksiSatu.distribution = .fill
        stackInstruksiSatu.layer.cornerRadius = 20
        stackInstruksiSatu.heightAnchor.constraint(equalToConstant: 194).isActive = true
        stackInstruksiSatu.frame = view.bounds
        
        //MARK: Langkah 2
        let labelLangkahDua = UILabel()
        labelLangkahDua.text = "Langkah"
        labelLangkahDua.textColor = .white
        labelLangkahDua.textAlignment = .center
        labelLangkahDua.font = UIFont.scriptFont(size: 30)
        labelLangkahDua.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        let labelDua = UILabel()
        labelDua.text = "2"
        labelDua.textColor = .white
        labelDua.textAlignment = .center
        labelDua.font = UIFont.scriptFont(size: 60)
        
        //MARK: Langkah 2 Stack Vertical
        let stackLabelDua = UIStackView(arrangedSubviews: [labelLangkahDua, labelDua])
        stackLabelDua.axis = .vertical
        stackLabelDua.distribution = .fill
        stackLabelDua.backgroundColor = UIColor(red: 69.0/255, green: 173.0/255, blue: 226.0/225, alpha: 1)
        stackLabelDua.layer.cornerRadius = 20
        stackLabelDua.widthAnchor.constraint(equalToConstant: 177).isActive = true
        
        //MARK: Perintah 2
        let judulDua = UILabel()
        judulDua.text = "Sebarkan Kartu Permainan"
        judulDua.textAlignment = .left
        judulDua.font = UIFont.scriptFont(size: 25)
        judulDua.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        let perintahDua = UILabel()
        perintahDua.text = "Sebarkan seluruh kartu di berbagai tempat berbeda di\ndalam rumah dengan lokasi yang aman untuk anak dan\nmasih bisa terlihat dari pandangannya."
        perintahDua.textAlignment = .left
        perintahDua.font = UIFont.scriptFont(size: 20)
        perintahDua.numberOfLines = 0
        
        let spacerPerintahDua = UIView()
        
        //MARK: Perintah 2 Stack Vertical
        let stackPerintahDua = UIStackView(arrangedSubviews: [judulDua, perintahDua, spacerPerintahDua])
        stackPerintahDua.axis = .vertical
        stackPerintahDua.alignment = .leading
        stackPerintahDua.distribution = .fill
        
        //MARK: Instruksi 2 Stack Horizontal
        let stackInstruksiDua = UIStackView(arrangedSubviews: [stackLabelDua, stackPerintahDua])
        stackInstruksiDua.axis = .horizontal
        stackInstruksiDua.backgroundColor = UIColor(red: 242.0/255, green: 205.0/255, blue: 93.0/255, alpha: 1)
        stackInstruksiDua.spacing = 20
        stackInstruksiDua.distribution = .fill
        stackInstruksiDua.layer.cornerRadius = 20
        stackInstruksiDua.heightAnchor.constraint(equalToConstant: 194).isActive = true
        stackInstruksiDua.frame = view.bounds
        
        //MARK: Langkah 3
        let labelLangkahTiga = UILabel()
        labelLangkahTiga.text = "Langkah"
        labelLangkahTiga.textColor = .white
        labelLangkahTiga.textAlignment = .center
        labelLangkahTiga.font = UIFont.scriptFont(size: 30)
        labelLangkahTiga.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        let labelTiga = UILabel()
        labelTiga.text = "3"
        labelTiga.textColor = .white
        labelTiga.textAlignment = .center
        labelTiga.font = UIFont.scriptFont(size: 60)
        
        //MARK: Langkah 3 Stack Vertical
        let stackLabelTiga = UIStackView(arrangedSubviews: [labelLangkahTiga, labelTiga])
        stackLabelTiga.axis = .vertical
        stackLabelTiga.distribution = .fill
        stackLabelTiga.backgroundColor = UIColor(red: 69.0/255, green: 173.0/255, blue: 226.0/225, alpha: 1)
        stackLabelTiga.layer.cornerRadius = 20
        stackLabelTiga.widthAnchor.constraint(equalToConstant: 177).isActive = true
        
        //MARK: Perintah 3
        let judulTiga = UILabel()
        judulTiga.text = "Bermain Bersama"
        judulTiga.textAlignment = .left
        judulTiga.font = UIFont.scriptFont(size: 25)
        judulTiga.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        let perintahTiga = UILabel()
        perintahTiga.text = "Ajak dan dampingi anak untuk bermain bersama, dipandu\nmenggunakan aplikasi ini, sambil nantinya akan mencari\nkartu-kartu tersebut sesuai petunjuk dari permainan.\nUntuklebih jelasnya, lihat instruksi permainan di langkah 1."
        perintahTiga.textAlignment = .left
        perintahTiga.font = UIFont.scriptFont(size: 20)
        perintahTiga.numberOfLines = 0
        
        let spacerPerintahTiga = UIView()
        
        //MARK: Perintah 3 Stack Vertical
        let stackPerintahTiga = UIStackView(arrangedSubviews: [judulTiga, perintahTiga, spacerPerintahTiga])
        stackPerintahTiga.axis = .vertical
        stackPerintahTiga.alignment = .leading
        stackPerintahTiga.distribution = .fill
        
        //MARK: Instruksi 3 Stack Horizontal
        let stackInstruksiTiga = UIStackView(arrangedSubviews: [stackLabelTiga, stackPerintahTiga])
        stackInstruksiTiga.axis = .horizontal
        stackInstruksiTiga.backgroundColor = UIColor(red: 242.0/255, green: 205.0/255, blue: 93.0/255, alpha: 1)
        stackInstruksiTiga.spacing = 20
        stackInstruksiTiga.distribution = .fill
        stackInstruksiTiga.layer.cornerRadius = 20
        stackInstruksiTiga.heightAnchor.constraint(equalToConstant: 194).isActive = true
        stackInstruksiTiga.frame = view.bounds
        
        //MARK: Checkbox
        checkbox.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        let agreeLabel = UILabel()
        agreeLabel.text = "Persiapan permainan sudah siap!"
        agreeLabel.textAlignment = .left
        agreeLabel.font = UIFont.scriptFont(size: 25)
        
        //MARK: Clickable UI agree
        checkbox.isUserInteractionEnabled = true
        let tapAgree = UITapGestureRecognizer.init(target: self, action: #selector(agreeClicked))
        tapAgree.numberOfTapsRequired = 1
        checkbox.addGestureRecognizer(tapAgree)
        
        let stackCheckbox = UIStackView(arrangedSubviews: [checkbox, agreeLabel])
        stackCheckbox.axis = .horizontal
        stackCheckbox.spacing = 20
        stackCheckbox.distribution = .fill
        stackCheckbox.heightAnchor.constraint(equalToConstant: 50).isActive = true
        stackCheckbox.frame = view.bounds
        
        //MARK: Spacer
        let spacerOuterTop = UIView()
        spacerOuterTop.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
        let spacerCheckbox = UIView()
        spacerCheckbox.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        let spacerOuterBottom = UIView()
        
        //MARK: Instruksi all stack vertival
        let stackAll = UIStackView(arrangedSubviews: [spacerOuterTop, labelHalaman, stackInstruksiSatu, stackInstruksiDua, stackInstruksiTiga, spacerCheckbox, stackCheckbox, spacerOuterBottom])
        stackAll.axis = .vertical
        stackAll.spacing = 20
        stackAll.distribution = .fill
        stackAll.frame = view.bounds
        
        let spacerOuterLeft = UIView()
        spacerOuterLeft.widthAnchor.constraint(equalToConstant: 32).isActive = true
        
        let spacerOuterRight = UIView()
        spacerOuterRight.widthAnchor.constraint(equalToConstant: 32).isActive = true
        
        let stackOuterAll = UIStackView(arrangedSubviews: [spacerOuterLeft, stackAll, spacerOuterRight])
        stackOuterAll.axis = .horizontal
        stackOuterAll.backgroundColor = UIColor(red: 253.0/255, green: 248.0/255, blue: 235.0/255, alpha: 1)
        stackOuterAll.spacing = 0
        stackOuterAll.distribution = .fillProportionally
        stackOuterAll.frame = view.bounds
        
        return stackOuterAll
    }()
    
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startStoryButton.isEnabled = false
        view.addSubview(instructionStackView)
        view.addSubview(homeButton)
        view.addSubview(startStoryButton)
        view.addSubview(background)
        setUpAutoLayout()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @objc
        func homeTapped() {
            coordinator?.toLanding()
            AudioSFXPlayer.shared.playCommonSFX()
        }
    
    @objc
        func startStoryTapped() {
            var state = defaults.string(forKey: "userState")
            switch state {
            case "clear_story_1":
                coordinator?.toExplore()
                sleep(3)
            case "clear_story_2":
                coordinator?.toPower()
            case "clear_story_3":
                coordinator?.toTutorial()
            case "clear_story_4":
                coordinator?.toExplore()
                sleep(3)
            case "cleared":
                coordinator?.toReflection()
            default:
                coordinator?.toStory()
            }
            
            AudioSFXPlayer.shared.playCommonSFX()
            AudioBGMPlayer.shared.stopLanding()
        }
    
    @objc
        func instructionClicked() {
            //TODO: action here
            print("Label Clicked")
        }
    
    @objc
    func agreeClicked() {
        let isChecked = checkbox.toggle()
        
        if isChecked {
            startStoryButton.isEnabled = true
        } else {
            startStoryButton.isEnabled = false
        }
    }
    
    func setUpAutoLayout() {
        
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let constant: CGFloat
       
        if screenWidth == 834.0 {
            constant = 500
        } else {
            constant = 580
        }
        
        NSLayoutConstraint.activate([
            homeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            homeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            
            startStoryButton.centerXAnchor.constraint(equalToSystemSpacingAfter: view.centerXAnchor, multiplier: 1),
            startStoryButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant),
        ])
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}



