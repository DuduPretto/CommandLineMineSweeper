//
//  code.swift
//  escola
//
//  Created by Lucas Cunha on 13/03/23.
//
import Foundation

var field: [[quadradoBase]] = []
var totalDeBombas:Int = 0;
var flagsUsadas = 0;
var bombasSinalizadas:Int = 0;
var totalDeQuadrados:Int = 0;
var quadradosASerrevelados:Int = totalDeQuadrados - totalDeBombas;
var quadradosRevelados:Int = 0;
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

func gameOver(){
    if(bombasSinalizadas == totalDeBombas && quadradosRevelados == quadradosASerrevelados){
        print("You Win!")
        gameEnd=true;
    }
}

func revela(x:Int, y:Int){
    if (field[x][y].type == .bomb){
        print("Game Over! 💣🎇😵")
        field[x][y].revealed = true
        gameEnd=true;
    }
    if (field[x][y].type == .undecided){
        
        for linha in x-1...x+1{
            if linha >= 0 && linha <= X-1{
                for coluna in y-1...y+1{
                    if coluna >= 0 && coluna <= Y-1{
                        if((field[linha][coluna]).type == .bomb){ //aqui
                            field[x][y].surroundingBombs+=1;
                        }
                    }
                }
            }
        }
        if(field[x][y].surroundingBombs == 0){
            field[x][y].revealed = true;
            quadradosRevelados+=1;
            field[x][y].type = .free
            field[x][y].symbol = "⬜️"
            for linha in x-1...x+1{
                if linha >= 0 && linha <= X{
                    for coluna in y-1...y+1{
                        if coluna >= 0 && coluna <= Y{
                            if(linha>=0 && linha<=X-1 && coluna>=0 && coluna<=Y-1){
                                revela(x: linha, y: coluna)
                            }
                        }
                    }
                }
            }
        }
        else{
            field[x][y].revealed = true;
            quadradosRevelados+=1;
            field[x][y].type = .danger
            field[x][y].symbol = dangerSymbols[field[x][y].surroundingBombs]!//arrumar aqui
        }
    }
    //showField()
    print("\n\n")
}

func sinaliza(A:quadradoBase){
    if(A.signaled == false){
        if (flagsUsadas < totalDeBombas){
            A.signaled = true;
            flagsUsadas+=1;
            if (A.type == .bomb){
                bombasSinalizadas+=1;
            }
            else{
                print("Todas as flags já foram utilizadas, por favor remova alguma para poder adicionar outra")
            }
        }
        }else{
            A.signaled = false;
            flagsUsadas-=1;
        }
}

func matrixGenerator(){
    if (dif == 1){
        X = 10;
        Y = 8;
        totalDeBombas = 14;
        totalDeQuadrados = X * Y;
        quadradosASerrevelados = totalDeQuadrados - totalDeBombas
    }
    if (dif == 2){
        X = 18;
        Y = 14;
        totalDeBombas = 40;
        totalDeQuadrados = X * Y;
        quadradosASerrevelados = totalDeQuadrados - totalDeBombas
    }
    if (dif == 3){
        X = 24;
        Y = 18;
        totalDeBombas = 99;
        totalDeQuadrados = X * Y;
        quadradosASerrevelados = totalDeQuadrados - totalDeBombas
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

while(gameEnd == false){
    print("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n")
    showField()
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
        case "c":
            revela(x: currentX, y: currentY)
        case "x":
            sinaliza(A: field[currentX][currentY])
        default:
            break
        
    }
    print("Quadrados revelados: \(quadradosRevelados), Quadrados a ser revelados \(quadradosASerrevelados)")
    print("Total de bombas: \(totalDeBombas), bombas sinalizadas \(bombasSinalizadas)")
    gameOver()
    }


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
