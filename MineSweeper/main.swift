//
//  code.swift
//  escola
//
//  Created by Lucas Cunha on 13/03/23.
//
import Foundation

var field: [[quadradoBase]] = []
var totalDeBombas:Int = 6;
var bombasSinalizadas:Int = 0;
var totalDeQuadrados:Int = 16;
var quadradosASerrevelados:Int = totalDeQuadrados - totalDeBombas;
var quadradosrevelados:Int = 0;
var dif = 1;
var X = 0;
var Y = 0;

enum state{
    case undecided
    case free
    case danger
    case bomb
}

let dangerSymbols = [1:"1️⃣", 2:"2️⃣", 3:"3️⃣", 4:"4️⃣", 5:"5️⃣", 6:"6️⃣", 7:"7️⃣", 8:"8️⃣"]

class quadradoBase{
    var surroundingBombs = 0
    var signaled = false
    var revealed = false
    var type: state = .undecided
    var symbol = "❔"
    
    func showSquare() {
        if signaled{
            print("⛳️")
        }
        else if revealed {
            print(symbol)
        }
        else {
            print("🟩")
        }
    }
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
            A.symbol = "⬜️"
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
            A.symbol = dangerSymbols[A.surroundingBombs]!//arrumar aqui
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

func matrixGenerator(){
    if (dif == 1){
        X = 10;
        Y = 8;
        totalDeBombas = 14;
        totalDeQuadrados = X * Y;
    }
    if (dif == 2){
        X = 18;
        Y = 14;
        totalDeBombas = 22;
        totalDeQuadrados = X * Y;
    }
    if (dif == 3){
        X = 24;
        Y = 18;
        totalDeBombas = 28;
        totalDeQuadrados = X * Y;
    }
//    for linha in 0...X {
//        for _ in 0...Y{
//            field[linha].append(quadradoBase())
//        }
//    }
    
    for i in 0...X-1{
        field.append([quadradoBase]())
        for _ in 0...Y-1{
            field[i].append(quadradoBase())
        }
    }
}

func bombSpreader(){
    var aux = 0;
    while(aux != totalDeBombas){
        var randX = Int.random(in: 0..<X);
        var randY = Int.random(in: 0..<Y);
        if(field[randX][randY].type != .bomb){
            field[randX][randY].type = .bomb;
            aux+=1;
        }
    }
}

//var teste: [quadradoBase] = []
//teste.append(quadradoBase())
//teste[0].revealed = true
//print(teste[0].showSquare())

matrixGenerator()
print(field[9][7].showSquare())

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
