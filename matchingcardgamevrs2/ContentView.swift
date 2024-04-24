//
//  ContentView.swift
//  matchingcardgamevrs2
//
//  Created by Alvarez-Salsedo, Tanya on 4/24/24.
//

import SwiftUI

struct Card: Identifiable {
    var id: UUID = UUID()
    var content: String
    var isFaceUp: Bool = false
    var isMatched: Bool = false
}

//struct ContentView: View {
  //  @State private var difficulty: Difficulty?
    //@State private var isGameStarted = false

    //var body: some View {
      //  NavigationView {
        //    VStack {
          //      Text("Matching Card Game")
            //        .font(.title)
              //      .padding()

                //DifficultySelectionView(selectedDifficulty: $difficulty, isGameStarted: $isGameStarted)
                   // .padding()

                //Spacer()
           // }
            //.navigationTitle("Home")
            //.background(
              //  NavigationLink(destination: GameBoardView(difficulty: difficulty ?? .easy), isActive: $isGameStarted) {
                //    EmptyView()
               // }
           // )
       // }
    //}
//}

//struct DifficultySelectionView: View {
    @Binding var selectedDifficulty: Difficulty?
    @Binding var isGameStarted: Bool

    var body: some View {
        VStack {
            Text("Select Difficulty:")
                .font(.headline)
                .padding()

            Button(action: {
                selectedDifficulty = .easy
                isGameStarted = true
            }) {
                Text("Easy (6x6)")
            }
            .padding()

            Button(action: {
                selectedDifficulty = .medium
                isGameStarted = true
            }) {
                Text("Medium (10x10)")
            }
            .padding()

            Button(action: {
                selectedDifficulty = .difficult
                isGameStarted = true
            }) {
                Text("Difficult (12x12)")
            }
            .padding()
        }
    }
}
struct ParentView: View {
    @StateObject var viewModel = GameViewModel()
    
    var body: some View {
        GameBoardView(viewModel: view)
    }
}
struct GameBoardView: View {
    let difficulty: Difficulty
    @StateObject var viewModel: GameViewModel

    init(difficulty: Difficulty) {
        self.difficulty = difficulty
        self._viewModel = StateObject(wrappedValue: GameViewModel(difficulty: difficulty))
    }

    var body: some View {
        VStack {
            ForEach(viewModel.board.indices, id: \.self) { row in
                HStack {
                    ForEach(viewModel.board[row].indices, id: \.self) { col in
                        CardView(card: $viewModel.board[row][col])
                            .onTapGesture {
                                viewModel.selectCard(row: row, col: col)
                            }
                    }
                }
            }
        }
        .padding()
    }
}

struct CardView: View {
    @Binding var card: Card

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .aspectRatio(1, contentMode: .fit)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 2)
                )
            
            if card.isFaceUp {
                //RoundedRectangle(cornerRadius: 10)
                  //  .fill(Color.blue)
                Text(card.content)
                    .foregroundColor(.black)
                    .font(.title)
            } else {
               // RoundedRectangle(cornerRadius: 10)
               //     .fill(Color.white)
                Image(systemName: card.isMatched ? "😊" : "questionmark")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(20)
            }
        }
        .frame(width: 60, height: 60)
        .padding(5)
        .rotation3DEffect(
            .degrees(card.isMatched ? 360 : 0),
            axis: (x: 0.0, y: 1.0, z: 0.0)
        )
        .animation(.easeInOut(duration: 0.5))
    }
}

struct DifficultySelectionView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

enum Difficulty {
    case easy
    case medium
    case difficult

    var boardSize: (rows: Int, cols: Int) {
        switch self {
        case .easy:
            return (2, 3) // Reduced size for preview
        case .medium:
            return (2, 5) // Reduced size for preview
        case .difficult:
            return (3, 4) // Reduced size for preview
        }
    }
}

struct Card: Identifiable {
    let id = UUID()
    var content: String
    var isFaceUp = false
    var isMatched = false
}

class GameViewModel: ObservableObject {
   // let difficulty: Difficulty
    @Published var board: [[Card]] = [[]]
    @Published var isGameOver: Bool = false
   // @StateObject var viewModel = GameViewModel(difficulty: yourDifficulty)
    
   // private var matchedPairsCount: Int = 0
    
    
    init(difficulty: Difficulty) {
       // self.difficulty = difficulty
        //self.viewModel = StateObject(wrappedValue: GameViewModel())
       // viewModel.populateBoard(difficulty: difficulty)]
       // let totalCardsCount = difficulty.boardSize.rows * difficulty.boardSize.cols
        //let totalPairsCount = totalCardsCount / 2
        //self.board = Array(repeating: Array(repeating: Card(content: ""), count: difficulty.boardSize.cols), count: difficulty.boardSize.rows)
        //populateBoard(totalPairsCount: totalPairsCount)
        switch difficulty {
        case .easy:
            board = //create board for easy
        case .medium:
            board = //create board for medium
            
        case .difficult:
            board = //
        }
    }
    
    
    private func populateBoard(totalPairsCount: Int) {
        var contentPairs = [String]()
        for i in 0..<totalPairsCount {
            contentPairs.append(String(UnicodeScalar(65 + i)!))
            contentPairs.append(String(UnicodeScalar(65 + i)!))
        }
        contentPairs.shuffle()
        
        var contentIndex = 0
        for row in 0..<board.count {
            for col in 0..<board[row].count {
                board[row][col] = Card(content: contentPairs[contentIndex])
                contentIndex += 1
            }
        }
        
        for row in 0..<board.count {
            board[row].shuffle()
        }
        
    }

    
    func cardTapped(at row: Int, _ col: Int) {
        guard !viewModel.isGameOver else { return }
        
        var card = viewModel.board[row][col]
        if !card.isFaceUp && !card.isMatched {
            card.isFaceUp.toggle()
            viewModel.checkForMatch(row: row, col)
        }
    }
    
    private func checkForMatch(row: Int, _ col: Int) {
        let card = viewModel.board[row][col]
        for r in 0..<viewModel.board.count {
            for c in 0..<viewModel.board[r].count {
                var otherCard = viewModel.board[r][c]
                if otherCard.isFaceUp && !otherCard.isMatched && otherCard.content == card.content && (r != row || c != col) {
                    card.isMatched = true
                    otherCard.isMatched = true
                    viewModel.matchedPairsCount += 1
                    if viewModel.matchedPairsCount == (viewModel.board.count * viewModel.board[0].count) / 2 {
                        viewModel.isGameOver = true
                    }
                    return
                }
            }
        }
    }
    //func populateBoard(difficulty: Difficulty) {
       // guard let difficulty = difficulty else { return }
        // Populate the board with pairs of cards
      //  var contentPairs = [String]()
        //for i in 0...(difficulty.boardSize.rows * difficulty.boardSize.cols / 2) {
          //  contentPairs.append(String(UnicodeScalar(65 + i)!))
            //contentPairs.append(String(UnicodeScalar(65 + i)!))
      //  }
        
        //shuffle content pairs
        //contentPairs.shuffle()
        
        //assign content pairs to cards
        
        
        //shuffle board
        
    }
     //   var content = "A"
       // for row in 0..<board.count {
         //   for col in 0..<board[row].count {
           //     if content == "Z" { content = "A" } // Restart content loop
             //   board[row][col] = Card(content: content)
               // content = String(UnicodeScalar(content.unicodeScalars.first!.value + 1)!)
           // }
        //}
        //board.shuffle()
        //for row in 0..<board.count {
          //  board[row].shuffle()
        //}
    //}

    func selectCard(row: Int, col: Int) {
        guard !isGameOver else { return }
       // if !board[row][col].isFaceUp && !board[row][col].isMatched {
         //   board[row][col].isFaceUp = true
            // Check for a match
           // for r in 0..<board.count {
             //   for c in 0..<board[r].count {
               //     if board[r][c].isFaceUp && !(r == row && c == col) {
                 //       if board[r][c].content == board[row][col].content {
                            // Match found
                   //         board[r][c].isMatched = true
                     //       board[row][col].isMatched = true
                            // Play confetti animation
                            // Play correct sound
                       // } else {
                            // No match, flip cards back after a delay
                         //   DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                           //     withAnimation {
                             //       self.board[r][c].isFaceUp = false
                               //     self.board[row][col].isFaceUp = false
                                    // Play incorrect sound
                                }


#Preview {
    ContentView()
}
