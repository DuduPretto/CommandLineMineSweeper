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
var dif = 1
var X = 0;
var Y = 0;

enum state{
    case undecided
    case free
    case danger
    case bomb
}

enum InputErrors: Error{
    case ivalidInput
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
            print("⛳️", terminator: "")
        }
        else if revealed {
            print(symbol, terminator: "")
        }
        else {
            print("🟩", terminator: "")
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
        A.revealed = true
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
                    if(linha>=0 && linha<=X-1 && coluna>=0 && coluna<=Y-1){
                        revela(A: field[linha][coluna], x: linha, y: coluna, field: field)
                    }
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
    showField()
    print("\n\n")
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
        totalDeBombas = 40;
        totalDeQuadrados = X * Y;
    }
    if (dif == 3){
        X = 24;
        Y = 18;
        totalDeBombas = 99;
        totalDeQuadrados = X * Y;
    }
    
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
        let randX = Int.random(in: 0..<X-1);
        let randY = Int.random(in: 0..<Y-1);
        if(field[randX][randY].type != .bomb){
            field[randX][randY].type = .bomb;
            field[randX][randY].symbol = "💣"
            field[randX][randY].revealed = true
            aux+=1;
        }
    }
}

func showField(){
    for i in 0...Y-1{
        for j in 0...X-1{
            field[j][i].showSquare()
        }
        print()
    }
}



//field[0][0].showSquare()
print("X: \(X), Y: \(Y)")



func selectDifficulty() throws{
    print("""
    Escolha o numero correspondente a dificuldade em que deseja jogar:
        1 - Facil
        2 - Medio
        3 - Dificil
    """)

    if let difficultyChoice: String = readLine(){
        if let selectedDifficulty = Int(difficultyChoice){
            dif = selectedDifficulty
        }else{
            throw InputErrors.ivalidInput
        }
    }
}

do{
    try selectDifficulty()
}catch InputErrors.ivalidInput{
    print("Ocorreu um erro com o input, por favor, tente novamente")
}

print("dificuldade selecionada = \(dif)")

matrixGenerator()

bombSpreader()
//showField()

revela(A: field[3][3], x: 3, y: 3, field: field)


// Imrpimir o campo
// Implementar dificuldades
// Criar a lógica de game over (Feito)
// Criar a lógica de ganhar o jogo (Feito)
// Criar a lógica de revelar/sinalizar (Feito)
// Geracao da matrix (Feito)
// Criacao das bombas (Feito)
// Refinamento da matrix (completar as informacoes com base nas posicoes das bombas) (Feito)
// Input do usuário
//
//Feito: Implementado
//Completo: Testado

//trocar matrix generator para um switch com o default para repetir o input
