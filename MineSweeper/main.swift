//
//  code.swift
//  escola
//
//  Created by Lucas Cunha on 13/03/23.
//
import Foundation
import AVFoundation

var player: AVAudioPlayer!

func playBombSound() {
    if let url = Bundle.main.url(forResource: "Bomb", withExtension: "mp3"){
        player = try? AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
        player.play()
    }
}

func playBackground() {
    if let url = Bundle.main.url(forResource: "Background", withExtension: "mp3"){
        player = try? AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
        player.play()
       }
}

func playFlag() {
    if let url = Bundle.main.url(forResource: "flag", withExtension: "mp3"){
        player = try? AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
        player.play()
        Thread.sleep(forTimeInterval: 1)
        playBackground()
    }
}

func playGameOver() {
    if let url = Bundle.main.url(forResource: "GameOver", withExtension: "mp3"){
        player = try? AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
        player.play()
    }
}

func playRevela() {
    if let url = Bundle.main.url(forResource: "revela", withExtension: "mp3"){
        player = try? AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
        player.play()
    }
}

func playVitoria() {
    if let url = Bundle.main.url(forResource: "vitoria", withExtension: "mp3"){
        player = try? AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
        player.play()
    }
}



var field: [[quadradoBase]] = []
var totalBombs:Int = 0;
var usefFlags = 0;
var markedBombs:Int = 0;
var totalDeQuadrados:Int = 0;
var quadradosASerrevelados:Int = totalDeQuadrados - totalBombs;
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
    case invalidInput
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
    if(markedBombs == totalBombs && quadradosRevelados == quadradosASerrevelados){
        print("You Win!")
        gameEnd=true;
    }
}

func revela(x:Int, y:Int){
    if (field[x][y].type == .bomb){
        print("Game Over! 💣🎇😵")
        field[x][y].revealed = true
        gameEnd=true;
        playBombSound()
        Thread.sleep(forTimeInterval: 5)
        print("passou")
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
            playRevela()
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
            playRevela()
            quadradosRevelados+=1;
            field[x][y].type = .danger
            field[x][y].symbol = dangerSymbols[field[x][y].surroundingBombs]!
        }
    }
    //showField()
    print("\n\n")
}

func sinaliza(A:quadradoBase){
    if(A.signaled == false){
        if (usefFlags < totalBombs){
            A.signaled = true;
            usefFlags+=1;
            if (A.type == .bomb){
                markedBombs+=1;
            }
            else{
                print("Todas as flags já foram utilizadas, por favor remova alguma para poder adicionar outra")
            }
        }
        playFlag()
        }else{
            A.signaled = false;
            usefFlags-=1;
        }
}

func matrixGenerator(){
    if (dif == 1){
        X = 10;
        Y = 8;
        totalBombs = 14;
        totalDeQuadrados = X * Y;
        quadradosASerrevelados = totalDeQuadrados - totalBombs
    }
    if (dif == 2){
        X = 18;
        Y = 14;
        totalBombs = 40;
        totalDeQuadrados = X * Y;
        quadradosASerrevelados = totalDeQuadrados - totalBombs
    }
    if (dif == 3){
        X = 24;
        Y = 18;
        totalBombs = 99;
        totalDeQuadrados = X * Y;
        quadradosASerrevelados = totalDeQuadrados - totalBombs
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
    while(aux != totalBombs){
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



func selectDifficulty() throws{
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
                throw InputErrors.invalidInput
            }else{
                dif = selectedDifficulty
            }
        }else{
            print("O valor inserido nao e um numero, por favor, tente novamente")
            throw InputErrors.invalidInput
        }
    }
}
func teste(){
    do{
       try selectDifficulty()
    }catch InputErrors.invalidInput{
        teste()
    }catch{
        
    }
}


teste()
print("dificuldade selecionada = \(dif)")

matrixGenerator()

bombSpreader()

playBackground()

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
    print("Total de bombas: \(totalBombs), bombas sinalizadas \(markedBombs)")
    gameOver()
    }
playGameOver()
Thread.sleep(forTimeInterval: 3)



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
