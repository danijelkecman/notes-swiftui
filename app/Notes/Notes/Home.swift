//
//  ContentView.swift
//  Notes
//
//  Created by Danijel Kecman on 11/20/22.
//

import SwiftUI

struct Home: View {
  @State var notes = [Note]()
  @State var showAddNote = false
  @State var showAlert = false
  @State var deleteItem: Note?
  @State var updateNote = ""
  @State var updateNoteId = ""
  @State var isEditMode: EditMode = .inactive
  
  var alert: Alert {
    Alert(title: Text("Delete"),
          message: Text("Are you sure you want to delete this note?"),
          primaryButton: .destructive(Text("Delete"), action: deleteNote),
          secondaryButton: .cancel())
  }
  
  var body: some View {
    NavigationView {
      List(self.notes) { note in
        if self.isEditMode == .inactive {
          Text(note.note)
            .padding()
            .onLongPressGesture {
              self.showAlert.toggle()
              deleteItem = note
            }
        } else {
          HStack {
            Image(systemName: "pencil.circle.fill")
              .foregroundColor(.yellow)
            Text(note.note)
              .padding()
          }.onTapGesture {
            self.updateNote = note.note
            self.updateNoteId = note.id
            self.showAddNote.toggle()
          }
        }
      }
      .alert(isPresented: $showAlert, content: {
        alert
      })
      .sheet(isPresented: $showAddNote, onDismiss: fetchNotes, content: {
        if self.isEditMode == .inactive {
          AddNoteView()
        } else {
          UpdateNoteView(note: $updateNote, noteId: $updateNoteId)
        }
      })
      .onAppear(perform: fetchNotes)
      .navigationTitle("Notes")
      .navigationBarItems(leading: Button(action: {
        if self.isEditMode == .inactive {
          self.isEditMode = .active
        } else {
          self.isEditMode = .inactive
        }
        self.isEditMode = .active
      }, label: {
        if self.isEditMode == .inactive {
          Text("Edit")
        } else {
          Text("Done")
        }
      }))
      .navigationBarItems(trailing: Button(action: {
        self.showAddNote.toggle()
      }, label: {
        Text("Add")
      }))
    }
  }
  
  func fetchNotes() {
    guard let url = URL(string: "http://localhost:3000/notes") else { return }
    
    let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
    
    let task = URLSession.shared.dataTask(with: request) { data, res, err in
      guard let data else { return }
      
      do {
        let notes = try JSONDecoder().decode([Note].self, from: data)
        self.notes = notes
      } catch {
        print(error)
      }
    }
    task.resume()
    
    if isEditMode == .active {
      self.isEditMode = .inactive
    }
  }
  
  func deleteNote() {
    guard let id = deleteItem?.id else { return }
    guard let url = URL(string: "http://localhost:3000/notes/\(id)") else { return }
    
    var request = URLRequest(url: url)
    
    request.httpMethod = "DELETE"
    
    let task = URLSession.shared.dataTask(with: request) { data, res, err in
      guard err == nil else { return }
      guard let data else { return }
      
      let response = String(decoding: data, as: UTF8.self)
      print(response)
    }
    task.resume()
  }
}

struct Note: Identifiable, Codable {
  var id: String { noteId }
  var noteId: String
  var note: String
  
  enum CodingKeys: String, CodingKey {
    case noteId = "_id"
    case note
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    Home()
  }
}
