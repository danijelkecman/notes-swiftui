//
//  UpdateNoteView.swift
//  Notes
//
//  Created by Danijel Kecman on 11/22/22.
//

import SwiftUI

struct UpdateNoteView: View {
  @Binding var note: String
  @Binding var noteId: String
  
  @Environment(\.presentationMode) var presentationMode
  
  var body: some View {
    HStack {
      TextField("Update a note", text: $note)
        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
        .clipped()
      
      Button(action: updateNote) {
        Text("Update")
          .padding(8)
      }
    }
  }
  
  func updateNote() {
    let params = ["note": note] as [String : Any]
    guard let url = URL(string: "http://localhost:3000/notes/\(noteId)") else { return }
    
    var request = URLRequest(url: url)
    request.httpMethod = "PATCH"
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
      
      let response = String(decoding: data, as: UTF8.self)
      print(response)
      
      do {
        if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String : Any] {
          print(json)
        }
      } catch {
        print(error)
      }
    }
    task.resume()
    
    presentationMode.wrappedValue.dismiss()
  }
}

struct UpdateNoteView_Previews: PreviewProvider {
  static var previews: some View {
    UpdateNoteView(note: .constant("update note"), noteId: .constant("id"))
  }
}
