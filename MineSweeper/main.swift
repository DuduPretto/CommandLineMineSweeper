//
//  code.swift
//  escola
//
//  Created by Lucas Cunha on 13/03/23.
//
import Foundation

var field: [[quadradoBase]] = []
var totalDeBombas:Int = 6;
var flagsUsadas = 0;
var bombasSinalizadas:Int = 0;
var totalDeQuadrados:Int = 16;
var quadradosASerrevelados:Int = totalDeQuadrados - totalDeBombas;
var quadradosrevelados:Int = 0;
var gameEnd = false;
var dif = 1
var X = 0;
var Y = 0;
var currentX = 0
var currentY = 0

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
        gameEnd=true;
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
    if(A.signaled == false){
        if (flagsUsadas < totalDeBombas){
            A.signaled = true;
            flagsUsadas+=1;
            if (A.type == .bomb){
                bombasSinalizadas+=1;
                if(bombasSinalizadas == totalDeBombas && quadradosrevelados == quadradosASerrevelados){
                    print("You Win!")
                    gameEnd=true;
                }
            }
            else{
                print("Todas as flags já foram utilizadas, por favor remova alguma para poder adicionar outra")
            }
        }
        else{
            A.signaled = false;
            flagsUsadas-=1;
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
            if i == currentY && j == currentX{
                print("👇🏽", terminator: "")
            }else{
                field[j][i].showSquare()
            }
        }
        print()
    }
}



//field[0][0].showSquare()
print("X: \(X), Y: \(Y)")



func selectDifficulty(){
    print("""
    Escolha o numero correspondente a dificuldade em que deseja jogar:
        1 - Facil
        2 - Medio
        3 - Dificil
    """)

    if let difficultyChoice: String = readLine(){
        if let selectedDifficulty = Int(difficultyChoice){
            if selectedDifficulty > 3 || selectedDifficulty <= 0{
                print("O numero inserido e invalido, por favor, tente novamente")
                selectDifficulty()
            }else{
                dif = selectedDifficulty

            }
        }else{
            print("O valor inserido nao e um numero, por favor, tente novamente")
            selectDifficulty()
        }
    }
    
    
}

selectDifficulty()
print("dificuldade selecionada = \(dif)")

matrixGenerator()

bombSpreader()
//showField()

while(gameEnd == false){
    print("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n")
    showField()
    //print("Escolha o quarado (Letra),(Numero): ")
    //let selectedSquare = readLine()
    //print("O que quer fazer nesse quadrado? (1) Revelar (2) Sinalizar")
    //let choiceString = readLine()
    // split de selectedSquare na virgula
    //var x = 1;
//    var y = 2;
//    if(choiceString == "1"){
//
//    }
//    if(choiceString == "2"){
//        if(field[x][y].revealed == false){
//
//        }
//        else{
//            print ("Voce nao pode sinalizar espacos já revelados, por favor realize alguma outa acao")
//        }
//    }
    let comando = Character(UnicodeScalar(Int(getch()))!)
    
    switch comando{
        case "w":
            if currentY == 0{
                currentY = Y-1
            }else{
                currentY -= 1
            }
        case "a":
            if currentX == 0{
                currentX = X-1
            }else{
                currentX -= 1
            }
        case "s":
            if currentY == Y-1{
                currentY = 0
            }else{
                currentY += 1
            }
        case "d":
            if currentX == X-1{
                currentX = 0
            }else{
                currentX += 1
            }
//        case "1":
//
//        
        default:
            break
    }
}
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

extension FileHandle {
    func enableRawMode() -> termios {
        var raw = termios()
        tcgetattr(self.fileDescriptor, &raw)

        let original = raw
        raw.c_lflag &= ~UInt(ECHO | ICANON)
        tcsetattr(self.fileDescriptor, TCSADRAIN, &raw)
        return original
    }

    func restoreRawMode(originalTerm: termios) {
        var term = originalTerm
        tcsetattr(self.fileDescriptor, TCSADRAIN, &term)
    }
}

func getch() -> UInt8 {
    let handle = FileHandle.standardInput
    let term = handle.enableRawMode()
    defer { handle.restoreRawMode(originalTerm: term) }

    var byte: UInt8 = 0
    read(handle.fileDescriptor, &byte, 1)
    return byte
}
