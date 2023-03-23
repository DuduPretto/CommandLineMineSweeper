//
//  code.swift
//  escola
//
//  Created by Lucas Cunha on 13/03/23.
//
import Foundation
import AVFoundation


// MARK: - criação das variáveis

var field: [[BaseSquare]] = []
var totalBombs:Int = 0;
var usefFlags = 0;
var markedBombs:Int = 0;
var totalSquares:Int = 0;
var SquaresToBeRevealed:Int = totalSquares - totalBombs;
var revealedSquares:Int = 0;
var gameEnd = false;
var dif = 1
var Width = 0;
var Height = 0;
var currentX = 0
var currentY = 0
let dangerSymbols = [1:"1️⃣", 2:"2️⃣", 3:"3️⃣", 4:"4️⃣", 5:"5️⃣", 6:"6️⃣", 7:"7️⃣", 8:"8️⃣"]

// MARK: - estados de cada quadrado

enum state{
    case undecided
    case free
    case danger
    case bomb
}

// MARK: - enum de erros

enum InputErrors: Error{
    case invalidInput
}


// MARK: - classe do quadrado base

class BaseSquare{
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

// MARK: - condicao para fim do jogo

func gameOver(){
    if(markedBombs == totalBombs && revealedSquares == SquaresToBeRevealed){
        print("You Win!")
        playVitoria()
        gameEnd=true
    }
}

// MARK: - revelar quadrados

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
        for line in x-1...x+1{
            if line >= 0 && line <= Width-1{
                for column in y-1...y+1{
                    if column >= 0 && column <= Height-1{
                        if((field[line][column]).type == .bomb){ //aqui
                            field[x][y].surroundingBombs+=1;
                        }
                    }
                }
            }
        }
        if(field[x][y].surroundingBombs == 0){
            field[x][y].revealed = true;
            playRevela()
            revealedSquares+=1;
            field[x][y].type = .free
            field[x][y].symbol = "⬜️"
            for line in x-1...x+1{
                if line >= 0 && line <= Width{
                    for column in y-1...y+1{
                        if column >= 0 && column <= Height{
                            if(line>=0 && line<=Width-1 && column>=0 && column<=Height-1){
                                revela(x: line, y: column)
                            }
                        }
                    }
                }
            }
        }
        else{
            field[x][y].revealed = true;
            playRevela()
            revealedSquares+=1;
            field[x][y].type = .danger
            field[x][y].symbol = dangerSymbols[field[x][y].surroundingBombs]!
        }
    }
    //showField()
    print("\n\n")
}

// MARK: - sinalizar bombas (flag)

func sinaliza(A:BaseSquare){
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

// MARK: - gerar matriz de acordo com a dificuldade escolhida

func matrixGenerator(){
    if (dif == 1){
        Width = 10;
        Height = 8;
        totalBombs = 14;
        totalSquares = Width * Height;
        SquaresToBeRevealed = totalSquares - totalBombs
    }
    if (dif == 2){
        Width = 18;
        Height = 14;
        totalBombs = 40;
        totalSquares = Width * Height;
        SquaresToBeRevealed = totalSquares - totalBombs
    }
    if (dif == 3){
        Width = 24;
        Height = 18;
        totalBombs = 99;
        totalSquares = Width * Height;
        SquaresToBeRevealed = totalSquares - totalBombs
    }
    
    for i in 0...Width-1{
        field.append([BaseSquare]())
        for _ in 0...Height-1{
            field[i].append(BaseSquare())
        }
    }
}

// MARK: - geração de bombas

func bombSpreader(){
    var aux = 0;
    while(aux != totalBombs){
        let randX = Int.random(in: 0..<Width-1);
        let randY = Int.random(in: 0..<Height-1);
        if(field[randX][randY].type != .bomb){
            field[randX][randY].type = .bomb;
            field[randX][randY].symbol = "💣"
            field[randX][randY].revealed = true
            aux+=1;
        }
    }
}

// MARK: - imprimir campo


func showField(){
    for i in 0...Height-1{
        for j in 0...Width-1{
            if i == currentY && j == currentX{
                print("👇🏽", terminator: "")
            }else{
                field[j][i].showSquare()
            }
        }
        print()
    }
}



//print("Width: \(Width), Height: \(Height)")


// MARK: - escolha dificuldade

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

// MARK: - Main

teste()
print("dificuldade selecionada = \(dif)")

matrixGenerator()

bombSpreader()

playBackground()

while(gameEnd == false){
    print("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n")
    showField()
    let comando = Character(UnicodeScalar(Int(getch()))!)
    
    switch comando{
        case "w":
            if currentY == 0{
                currentY = Height-1
            }else{
                currentY -= 1
            }
        case "a":
            if currentX == 0{
                currentX = Width-1
            }else{
                currentX -= 1
            }
        case "s":
            if currentY == Height-1{
                currentY = 0
            }else{
                currentY += 1
            }
        case "d":
            if currentX == Width-1{
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
    print("Quadrados revelados: \(revealedSquares), Quadrados a ser revelados \(SquaresToBeRevealed)")
    print("Total de bombas: \(totalBombs), casas sinalizadas \(markedBombs)")
    gameOver()
    }
playGameOver()
Thread.sleep(forTimeInterval: 3)



// MARK: - funções para usar teclado automaticamente

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

// MARK: - funções de audio
var player: AVAudioPlayer!

func playBombSound() {
    if let url = Bundle.main.url(forResource: "Bomb", withExtension: "mp3"){
        player = try? AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
        player.play()
        Thread.sleep(forTimeInterval: 1)
        playBackground()
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
        Thread.sleep(forTimeInterval: 1)
        playBackground()
    }
}

func playRevela() {
    if let url = Bundle.main.url(forResource: "revela", withExtension: "mp3"){
        player = try? AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
        player.play()
        Thread.sleep(forTimeInterval: 1)
        playBackground()
    }
}

func playVitoria() {
    if let url = Bundle.main.url(forResource: "vitoria", withExtension: "mp3"){
        player = try? AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
        player.play()
        Thread.sleep(forTimeInterval: 1)
        playBackground()
    }
}


