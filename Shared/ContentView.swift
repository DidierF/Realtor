//
//  ContentView.swift
//  Shared
//
//  Created by Didier Fuentes on 7/13/22.
//

import SwiftUI
import Combine

struct Row: Identifiable {
  var id = UUID()

  var title: String
  var usd: String
  var dop: String
}

struct Quote: Identifiable {
  var id = UUID()

  var separationP: Double = 0.1
  var separationM: Double = 0

  var timeToDeliver: Double = 18
  var savedDownPmt: Double = 36200
  var deliverP: Double = 0
  var deliverM: Double = 0
  var monthAmt: Double = 0

  var remainder: Double = 0

  var LoanInterest: Double = 0.15
  var LoanLength: Double = 20

  var loanPayment: Double = 0

  mutating func updatePrice(_ price: Double) -> Void {
    separationM = price * separationP

    deliverP = 0.5 - separationP - ( savedDownPmt / price )
    deliverM = deliverP * price
    monthAmt = deliverM / Double(timeToDeliver)

    remainder = price - (deliverM + separationM)

    let monthRate = LoanInterest / 12
    let mntPayments = LoanLength * 12
    let i = monthRate
    let n: Double = mntPayments
    let p1: Double = Double(i*pow(1.0+i, n))
    let p2: Double = Double(pow(1.0+i, n-1))
    loanPayment = price * p1 / p2
  }
}

func formatNum(_ num: Double) -> String {
  return "$ \(num.rounded())"
}

struct ContentView: View {
  let usddop = 55.0
  @State private var price: Double = 0.0
  @State private var priceStr: String = "168000"

  @State var separationP: Double = 0.1
  @State var separationM: Double = 0

  @State var timeToDeliver: Double = 18
  @State var savedDownPmt: Double = 36200
  @State var deliverP: Double = 0
  @State var deliverM: Double = 0
  @State var monthAmt: Double = 0

  @State var remainder: Double = 0

  @State var LoanInterest: Double = 0.15
  @State var LoanLength: Double = 20

  @State var loanPayment: Double = 0

  func updatePrice(_ price: Double) -> Void {
    separationM = price * separationP

    deliverP = 0.5 - separationP - ( savedDownPmt / price )
    deliverM = deliverP * price
    monthAmt = deliverM / Double(timeToDeliver)

    remainder = price - (deliverM + separationM)

    let monthRate = LoanInterest / 12
    let mntPayments = LoanLength * 12
    let i = monthRate
    let n: Double = mntPayments
    let p1: Double = Double(i*pow(1.0+i, n))
    let p2: Double = Double(pow(1.0+i, n-1))
    loanPayment = price * p1 / p2
  }

  func drawRow(_ row: Row) -> some View {
    HStack {
      Spacer()
      Text(row.title)
      Spacer()
      Text(row.usd)
      Spacer()
      Text(row.dop)
      Spacer()
    }
  }

  func drawGroup(_ group: [Row]) -> some View {
    Group {
      ForEach(group) { row in drawRow(row)}
    }.padding(.bottom)
  }

  func submit() {
    guard let tempPrice = Double(priceStr) else {
      return
    }
    self.price = tempPrice
    self.updatePrice(tempPrice)
  }

  var body: some View {
    VStack {
      Spacer()
      HStack {
        VStack (alignment: .leading) {
          Group {
            Text(" ")
            Text("Price")
              .bold()
              .padding(.bottom)
          }
          Group {
            Text("Separation %")
            Text("Separation $")
              .padding(.bottom)
          }
          Group {
            Text("Time to deliver")
            Text("Saved down payment")
            Text("Deliver %")
            Text("Deliver $")
            Text("Month Amt to deliver")
              .padding(.bottom)
          }
          Group {
            Text("Remainder")
              .padding(.bottom)
          }
          Group {
            Text("Loan %")
            Text("Loan length yr")
            Text("Loan length months")
              .padding(.bottom)
          }
        }
        VStack (alignment: .leading) {
          Group {
            Text("USD")
              .bold()
            Text(formatNum(price))
              .padding(.bottom)
          }
          Group {
            Text("Separation %")
            Text("Separation $")
              .padding(.bottom)
          }
          Group {
            Text("Time to deliver")
            Text("Saved down payment")
            Text("Deliver %")
            Text("Deliver $")
            Text("Month Amt to deliver")
              .padding(.bottom)
          }
          Group {
            Text("Remainder")
              .padding(.bottom)
          }
          Group {
            Text("Loan %")
            Text("Loan length yr")
            Text("Loan length months")
              .padding(.bottom)
          }
        }
        VStack (alignment: .leading) {
          Group {
            Text("DOP")
              .bold()
            Text(formatNum(price * usddop))
              .padding(.bottom)
          }
          Group {
            Text("Separation %")
            Text("Separation $")
              .padding(.bottom)
          }
          Group {
            Text("Time to deliver")
            Text("Saved down payment")
            Text("Deliver %")
            Text("Deliver $")
            Text("Month Amt to deliver")
              .padding(.bottom)
          }
          Group {
            Text("Remainder")
              .padding(.bottom)
          }
          Group {
            Text("Loan %")
            Text("Loan length yr")
            Text("Loan length months")
              .padding(.bottom)
          }
        }
      }
      Spacer()
      HStack {
        Spacer()
        TextField("Price", text: $priceStr)
          .onSubmit {
            submit()
          }
          .frame(width: 150, height: .none, alignment: .center)
          .keyboardType(.numberPad)
          .border(.black, width: 1)
          .onReceive(Just(priceStr)) { newValue in
            let filtered = newValue.filter { "0123456789".contains($0) }
            if filtered != newValue {
              self.priceStr = filtered
            }
          }
          .padding(.horizontal)
        Button("Update") {
          submit()
        }
        Spacer()
      }.padding(.bottom)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
