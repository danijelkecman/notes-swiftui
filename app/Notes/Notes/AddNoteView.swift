//
//  AddNoteView.swift
//  Notes
//
//  Created by Danijel Kecman on 11/21/22.
//

import SwiftUI

struct AddNoteView: View {
  @State var text = ""
  
  @Environment(\.presentationMode) var presentationMode
  
  var body: some View {
    HStack {
      TextField("Write a note", text: $text)
        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
        .clipped()
      
      Button(action: postNote) {
        Text("Add")
          .padding(8)
      }
    }
  }
  
  func postNote() {
    let params = ["note": text] as [String : Any]
    guard let url = URL(string: "http://localhost:3000/notes") else { return }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    do {
      request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
    } catch {
      print(error)
    }
    
    let task = URLSession.shared.dataTask(with: request) { data, res, err in
      guard err == nil else { return }
      guard let data = data else { return }
      
      do {
        if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String : Any] {
          print(json)
        }
      } catch {
        print(error)
      }
    }
    task.resume()
    
    self.text = ""
    presentationMode.wrappedValue.dismiss()
  }

}

struct AddNoteView_Previews: PreviewProvider {
  static var previews: some View {
    AddNoteView()
  }
}
