//
//  code.swift
//  escola
//
//  Created by Lucas Cunha on 13/03/23.
//

import Foundation

var field = [[quadradoBase]]()
var totalDeBombas:Int = 6;
var bombasSinalizadas:Int = 0;
var totalDeQuadrados:Int = 16;
var quadradosASerrevelados:Int = totalDeQuadrados - totalDeBombas;
var quadradosrevelados:Int = 0;

enum state{
    case undecided
    case free
    case danger
    case bomb
}

class quadradoBase{
    var surroundingBombs = 0
    var signaled = false
    var revealed = false
    var type: state = .undecided
}

//for linha in x-1...x+1
var A: quadradoBase = quadradoBase()
var x = 4;
var y = 3;

func revela(A:quadradoBase, x:Int, y:Int, field:[[quadradoBase]]){
    if (A.type == .bomb){
        print("Game Over! 💣🎇😵")
    }
    if (A.type == .undecided){
        for linha in x-1...x+1{
            for coluna in y-1...y+1{
                if((field[linha][coluna]).type == .bomb){
                    A.surroundingBombs+=1;
                }
            }
        }
        if(A.surroundingBombs == 0){
            A.revealed = true;
            quadradosrevelados+=1;
            A.type = .free
            for linha in x-1...x+1{
                for coluna in y-1...y+1{
                    revela(A: field[linha][coluna], x: linha, y: coluna, field: field)
                }
            }
        }
        else{
            A.revealed = true;
            quadradosrevelados+=1;
            A.type = .danger
        }
    }
}

func sinaliza(A:quadradoBase){
    A.signaled = true;
    if (A.type == .bomb){
        bombasSinalizadas+=1;
        if(bombasSinalizadas == totalDeBombas && quadradosrevelados == quadradosASerrevelados){
            print("You Win!")
        }
    }
}
// Imrpimir o campo
// Implementar dificuldades
// Criar a lógica de game over (Feito)
// Criar a lógica de ganhar o jogo (Feito)
// Criar a lógica de revelar/sinalizar (Feito)
// Geracao da matrix
// Criacao das bombas (Ainda falta)
// Refinamento da matrix (completar as informacoes com base nas posicoes das bombas) (Feito)
// Input do usuário
//
//Feito: Implementado
//Completo: Testado
