//
//  ClueMesseges.swift
//  Ceria
//
//  Created by Ariel Waraney on 12/10/22.
//

import Foundation

func getDescClue(clueCode: Int)-> String {
    switch clueCode {
    case 1:
        return "Cari kartu dengan gambar pulau di sekitar rumahmu untuk membantu kapal mendarat ke pulau yang tepat"
    case 2:
        return "Kamu menemukan kartunya!\nAyo ketuk tugu yang muncul itu untuk melanjutkan ke pulau Garuda!"
    case 3:
        return "Ikuti pola dibawah untuk memilih seorang dari keempat bersaudara yang akan menyelamatkan tuan putri dari burung garuda"
    case 4:
        return "Gerakan handphone/tabmu ke kanan dan ke kiri untuk membantuku menghindari halangan sampai ke tuan Putri"
    case 5:
        return "Cari kartu bergambar wajah Rua sebelum cerita usai untuk mengambil hadiah dari Rua"
    case 6:
        return "Cari kartu dengan gambar kapal di sekitar rumahmu untuk membantu Rua dan putri kembali ke kapal"
    case 7:
        return "Cari kartu bergambar wajah Rua sebelum cerita usai untuk mengambil hadiah dari Rua"
    case 8:
        return "Kamu menemukan kartunya!\nAyo ketuk barang yang muncul itu untuk menaruhnya di rak!"
    case 9:
        return "Kamu menemukan kartunya!\nAyo ketuk tugu yang muncul itu untuk kembali ke kapal!"
    default:
        return "error instruction"
    }
}
